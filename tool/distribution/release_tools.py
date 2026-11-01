#!/usr/bin/env python3
import argparse
import hashlib
import json
import os
import plistlib
import re
import shutil
import subprocess
import time
import zipfile
from pathlib import Path


STABLE_TAG = re.compile(r'v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)\Z')
REPOSITORY = 'go2world-icu/FlClash'


def stable_version(tag):
    match = STABLE_TAG.fullmatch(tag)
    if not match:
        raise ValueError('Expected a stable vX.Y.Z tag')
    return tuple(map(int, match.groups()))


def sha256(path):
    digest = hashlib.sha256()
    with Path(path).open('rb') as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(chunk)
    return digest.hexdigest()


def github(path):
    result = subprocess.run(
        ['gh', 'api', path],
        check=True,
        capture_output=True,
        text=True,
    )
    return json.loads(result.stdout)


def tag_commit(repo, tag):
    stable_version(tag)
    obj = github(f'repos/{repo}/git/ref/tags/{tag}')['object']
    for _ in range(5):
        if obj['type'] == 'commit':
            return obj['sha']
        if obj['type'] != 'tag':
            break
        obj = github(f'repos/{repo}/git/tags/{obj["sha"]}')['object']
    raise ValueError('Tag does not resolve to a commit')


def check_release(release, tag):
    if release['tag_name'] != tag or release['draft'] or release['prerelease']:
        raise ValueError('Expected a published stable GitHub Release')
    return release


def context():
    ref = os.environ['GITHUB_REF']
    tag = ref.removeprefix('refs/tags/') if ref.startswith('refs/tags/') else ''
    publish = (
        os.environ['GITHUB_EVENT_NAME'] == 'push'
        and os.environ['GITHUB_REPOSITORY'] == REPOSITORY
        and STABLE_TAG.fullmatch(tag) is not None
    )
    version = re.search(r'^version:\s*(\S+)', Path('pubspec.yaml').read_text(), re.M)
    if not version:
        raise ValueError('Missing pubspec version')
    if publish and tag != 'v' + version[1].split('+')[0]:
        raise ValueError('Release tag and pubspec version differ')
    with Path(os.environ['GITHUB_OUTPUT']).open('a') as output:
        output.write(f'tag={tag}\npublish={str(publish).lower()}\n')
        output.write(f'app_env={"stable" if publish else "pre"}\n')
        commit = subprocess.check_output(
            ['git', 'rev-parse', 'HEAD'], text=True
        ).strip()
        output.write(f'commit={commit}\n')
    source = Path('.github/workflows/build.yaml').read_text()
    with Path(os.environ['GITHUB_ENV']).open('a') as output:
        for key in ('FLUTTER_VERSION', 'GO_VERSION', 'CA_BUNDLE', 'CA_BUNDLE_SHA256'):
            match = re.search(
                rf'^\s+{key}:\s*[\x27\x22]?([\w.-]+)[\x27\x22]?\s*$', source, re.M
            )
            if not match:
                raise ValueError(f'Missing pinned {key} in build.yaml')
            output.write(f'{key}={match[1]}\n')


def record_ios(mode, export_options=None):
    dist = Path('dist')
    dist.mkdir(exist_ok=True)
    source_sha = subprocess.check_output(
        ['git', 'rev-parse', 'HEAD'], text=True
    ).strip()
    tag = os.environ.get('GITHUB_REF_NAME', '')
    app = Path('build/ios/iphoneos/Runner.app')
    if mode == 'archive':
        files = list(Path('build/ios/ipa').glob('*.ipa'))
        if len(files) != 1:
            raise ValueError('Expected exactly one exported IPA')
        with zipfile.ZipFile(files[0]) as ipa:
            infos = [
                name
                for name in ipa.namelist()
                if re.fullmatch(r'Payload/[^/]+\.app/Info.plist', name)
            ]
            if len(infos) != 1:
                raise ValueError('Expected one application in IPA')
            info = plistlib.loads(ipa.read(infos[0]))
        if not re.fullmatch(r'\d+', str(info['CFBundleVersion'])):
            raise ValueError('Expected a numeric iOS build number')
        label = (
            tag[1:] if STABLE_TAG.fullmatch(tag) else info['CFBundleShortVersionString']
        )
        package = dist / f'ToWorld-{label}-ios-arm64.ipa'
        shutil.copyfile(files[0], package)
        archive_app = Path(
            'build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app'
        )
        subprocess.run(
            ['codesign', '--verify', '--deep', '--strict', str(archive_app)], check=True
        )
        for target in (archive_app, archive_app / 'PlugIns/PacketTunnel.appex'):
            signed = subprocess.run(
                ['codesign', '-d', '--entitlements', ':-', str(target)],
                check=True,
                capture_output=True,
            )
            entitlements = plistlib.loads(signed.stdout)
            if 'packet-tunnel-provider' not in entitlements.get(
                'com.apple.developer.networking.networkextension', []
            ):
                raise ValueError(f'Missing VPN entitlement in {target.name}')
            groups = entitlements.get('com.apple.security.application-groups', [])
            if not groups:
                raise ValueError(f'Missing App Group in {target.name}')
            if target == archive_app:
                app_groups = groups
            elif groups != app_groups:
                raise ValueError('Runner and PacketTunnel App Groups differ')
        method = (
            plistlib.loads(Path(export_options).read_bytes())['method']
            if export_options
            else 'unknown'
        )
        distribution = (
            'app-store' if method in ('app-store', 'app-store-connect') else method
        )
    else:
        info = plistlib.loads((app / 'Info.plist').read_bytes())
        extension = app / 'PlugIns/PacketTunnel.appex/Info.plist'
        if not extension.is_file():
            raise ValueError('Missing PacketTunnel extension')
        ext_info = plistlib.loads(extension.read_bytes())
        if ext_info['CFBundleVersion'] != info['CFBundleVersion']:
            raise ValueError('Runner and PacketTunnel build numbers differ')
        package = dist / 'ToWorld-ios-arm64-unsigned.zip'
        subprocess.run(
            ['ditto', '-c', '-k', '--keepParent', str(app), str(package)], check=True
        )
        distribution = 'unsigned'
    record = {
        'schemaVersion': 1,
        'tag': tag,
        'commit': source_sha,
        'runId': os.environ.get('GITHUB_RUN_ID', ''),
        'appEnv': json.loads(Path('env.json').read_text())['APP_ENV'],
        'toolchain': {
            name: os.environ[name]
            for name in ('FLUTTER_VERSION', 'GO_VERSION', 'CA_BUNDLE_SHA256')
            if os.environ.get(name)
        },
        'inputs': {
            name: sha256(name)
            for name in ('pubspec.lock', 'ios/Podfile.lock', 'build_config.yaml')
            if Path(name).is_file()
        },
        'distribution': distribution,
        'platform': 'ios',
        'architecture': 'arm64',
        'version': info['CFBundleShortVersionString'],
        'buildNumber': str(info['CFBundleVersion']),
        'bundleIdentifier': info['CFBundleIdentifier'],
        'fileName': package.name,
        'size': package.stat().st_size,
        'sha256': sha256(package),
    }
    package.with_suffix('.json').write_text(json.dumps(record, indent=2) + '\n')
    package.with_suffix(package.suffix + '.sha256').write_text(
        f'{record["sha256"]}  {package.name}\n'
    )


def validate_ios(directory, tag, commit):
    stable_version(tag)
    files = list(Path(directory).glob('*-ios-arm64.json'))
    if len(files) != 1:
        raise ValueError('Expected one signed iOS release record')
    record = json.loads(files[0].read_text())
    if (
        record['tag'] != tag
        or record['commit'] != commit
        or record['distribution'] != 'app-store'
        or record.get('appEnv') != 'stable'
    ):
        raise ValueError('iOS artifact does not belong to this signed release')
    name = record['fileName']
    if Path(name).name != name or not name.endswith('.ipa'):
        raise ValueError('Invalid IPA file name')
    package = Path(directory) / name
    if package.stat().st_size != record['size'] or sha256(package) != record['sha256']:
        raise ValueError('IPA integrity check failed')
    return record


def wait_release(repo, tag, commit, timeout):
    if tag_commit(repo, tag) != commit:
        raise ValueError('Tag moved since the iOS build')
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        runs = github(
            f'repos/{repo}/actions/workflows/build.yaml/runs?head_sha={commit}&event=push&per_page=100'
        )['workflow_runs']
        matching = [
            run
            for run in runs
            if run['head_branch'] == tag and run['head_sha'] == commit
        ]
        if matching:
            run = max(matching, key=lambda item: item['id'])
            if run['status'] == 'completed':
                if run['conclusion'] != 'success':
                    raise ValueError('The matching build workflow did not succeed')
                return check_release(github(f'repos/{repo}/releases/tags/{tag}'), tag)
        print('Waiting for the matching build workflow and Release', flush=True)
        time.sleep(20)
    raise TimeoutError('Timed out waiting for the matching build workflow')


def attach_ios(repo, tag, commit, directory):
    if tag_commit(repo, tag) != commit:
        raise ValueError('Tag moved since the iOS build')
    record = validate_ios(directory, tag, commit)
    release = check_release(github(f'repos/{repo}/releases/tags/{tag}'), tag)
    existing = {asset['name']: asset for asset in release['assets']}
    package = Path(record['fileName'])
    allowed = {
        package.name,
        package.with_suffix('.json').name,
        package.name + '.sha256',
    }
    for path in sorted(Path(directory).iterdir()):
        if not path.is_file() or path.name not in allowed:
            raise ValueError('Unexpected file in the iOS artifact')
        asset = existing.get(path.name)
        if asset:
            if (
                asset.get('digest') != 'sha256:' + sha256(path)
                or asset['size'] != path.stat().st_size
            ):
                raise ValueError(f'Release already has different bytes for {path.name}')
            continue
        subprocess.run(
            ['gh', 'release', 'upload', tag, str(path), '--repo', repo], check=True
        )


def main():
    parser = argparse.ArgumentParser()
    commands = parser.add_subparsers(dest='command', required=True)
    commands.add_parser('context')
    record = commands.add_parser('record-ios')
    record.add_argument('--mode', choices=('verify', 'archive'), required=True)
    record.add_argument('--export-options-plist')
    for name in ('wait-release', 'attach-ios', 'validate-ios'):
        command = commands.add_parser(name)
        command.add_argument('--repo', default=REPOSITORY)
        command.add_argument('--tag', required=True)
        command.add_argument('--commit', required=True)
        command.add_argument('--directory', default='dist')
        command.add_argument('--timeout', type=int, default=3600)
    args = parser.parse_args()
    if args.command == 'context':
        context()
    elif args.command == 'record-ios':
        record_ios(args.mode, args.export_options_plist)
    elif args.command == 'wait-release':
        wait_release(args.repo, args.tag, args.commit, args.timeout)
    elif args.command == 'attach-ios':
        attach_ios(args.repo, args.tag, args.commit, args.directory)
    else:
        validate_ios(args.directory, args.tag, args.commit)


if __name__ == '__main__':
    main()
