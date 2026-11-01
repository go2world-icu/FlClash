#!/usr/bin/env python3
import argparse
import hashlib
import io
import json
import mimetypes
import os
import re
import subprocess
import tempfile
import time
import urllib.parse
import urllib.request
from pathlib import Path

from release_tools import (
    REPOSITORY,
    check_release,
    github,
    sha256,
    stable_version,
    tag_commit,
)


INSTALLER = re.compile(
    r'(?:ToWorld|FlClash)-(?P<version>[\d.]+)-'
    r'(?P<platform>android|windows|macos|linux)-'
    r'(?P<architecture>arm64-v8a|armeabi-v7a|x86_64|amd64|arm64|aarch64)'
    r'(?P<setup>-setup)?\.(?P<format>apk|exe|zip|dmg|deb|rpm|AppImage)\Z'
)
FORMATS = {
    'android': {'apk'},
    'windows': {'exe', 'zip'},
    'macos': {'dmg'},
    'linux': {'deb', 'rpm', 'AppImage'},
}


def installer(asset, tag):
    match = INSTALLER.fullmatch(asset['name'])
    if not match or match['version'] != tag[1:]:
        return None
    if match['format'] not in FORMATS[match['platform']]:
        return None
    if match['setup'] and (match['platform'], match['format']) != ('windows', 'exe'):
        return None
    return {key: match[key] for key in ('platform', 'architecture', 'format')}


def release_installers(release):
    result = []
    for asset in sorted(release['assets'], key=lambda item: item['name']):
        target = installer(asset, release['tag_name'])
        if not target:
            continue
        result.append((asset, target))
    return result


def source_tag(event, event_name, requested_tag):
    if event_name == 'workflow_run':
        run = event['workflow_run']
        path = run.get('path', '').split('@')[0]
        if (
            run['repository']['full_name'] != REPOSITORY
            or run['head_repository']['full_name'] != REPOSITORY
            or run['event'] != 'push'
            or run['conclusion'] != 'success'
            or path != '.github/workflows/build.yaml'
        ):
            raise ValueError('Untrusted or unsuccessful source workflow')
        tag = run['head_branch']
        stable_version(tag)
        commit = tag_commit(REPOSITORY, tag)
        if commit != run['head_sha']:
            raise ValueError('Source workflow and release tag commits differ')
    else:
        tag = requested_tag
        stable_version(tag)
        commit = tag_commit(REPOSITORY, tag)
    return tag, commit


def encode(data):
    return (json.dumps(data, sort_keys=True, indent=2) + '\n').encode()


def public_url(base, key):
    parsed = urllib.parse.urlsplit(base)
    if (
        parsed.scheme != 'https'
        or not parsed.netloc
        or parsed.query
        or parsed.fragment
        or parsed.username
    ):
        raise ValueError('COS_PUBLIC_BASE_URL must be an HTTPS base URL')
    return base.rstrip('/') + '/' + urllib.parse.quote(key, safe='/')


def verify_cdn(url, expected):
    for attempt in range(3):
        try:
            digest = hashlib.sha256()
            with urllib.request.urlopen(url, timeout=180) as response:
                for chunk in iter(lambda: response.read(1024 * 1024), b''):
                    digest.update(chunk)
            if digest.hexdigest() != expected:
                raise ValueError('CDN returned different bytes')
            return
        except (OSError, ValueError):
            if attempt == 2:
                raise
            time.sleep(2 ** (attempt + 1))


class Store:
    def __init__(self, bucket, region):
        from qcloud_cos import CosConfig, CosS3Client

        self.bucket = bucket
        self.client = CosS3Client(
            CosConfig(
                Region=region,
                SecretId=os.environ['COS_SECRET_ID'],
                SecretKey=os.environ['COS_SECRET_KEY'],
                Token=os.environ.get('COS_SESSION_TOKEN') or None,
                Scheme='https',
            )
        )

    def head(self, key):
        from qcloud_cos import CosServiceError

        try:
            response = self.client.head_object(Bucket=self.bucket, Key=key)
            return {name.lower(): value for name, value in response.items()}
        except CosServiceError as error:
            if str(error.get_status_code()) == '404':
                return None
            raise

    def read_json(self, key):
        if self.head(key) is None:
            return None
        response = self.client.get_object(Bucket=self.bucket, Key=key)
        stream = response['Body'].get_raw_stream()
        try:
            return json.load(stream)
        finally:
            stream.close()

    def put(self, key, stream, size, digest, content_type, immutable):
        current = self.head(key)
        if immutable and current:
            if (
                current.get('x-cos-meta-sha256') != digest
                or int(current['content-length']) != size
            ):
                raise ValueError(f'Refusing to overwrite different bytes at {key}')
            return False
        headers = {'x-cos-meta-sha256': digest}
        if immutable:
            # The pinned SDK passes custom COS headers through Metadata.
            headers['x-cos-forbid-overwrite'] = 'true'
        self.client.put_object(
            Bucket=self.bucket,
            Key=key,
            Body=stream,
            EnableMD5=True,
            ContentType=content_type,
            CacheControl=(
                'public, max-age=31536000, immutable'
                if immutable
                else 'public, max-age=60, must-revalidate'
            ),
            Metadata=headers,
        )
        uploaded = self.head(key)
        if (
            not uploaded
            or uploaded.get('x-cos-meta-sha256') != digest
            or int(uploaded['content-length']) != size
        ):
            raise ValueError(f'Uploaded object failed verification: {key}')
        return True


def advance_channel(store, key, manifest):
    current = store.read_json(key)
    if (
        current
        and current['tag'] == manifest['tag']
        and current['commit'] != manifest['commit']
    ):
        raise ValueError('A published tag cannot change its source commit')
    if current and stable_version(current['tag']) > stable_version(manifest['tag']):
        print(f'Keeping newer channel {current["tag"]}: {key}')
        return
    data = encode(manifest)
    store.put(
        key,
        io.BytesIO(data),
        len(data),
        hashlib.sha256(data).hexdigest(),
        'application/json',
        False,
    )


def publish(release, commit, config, store, directory, staging=False):
    tag = release['tag_name']
    prefix = config['prefix'].strip('/')
    if not prefix or any(part in ('', '.', '..') for part in prefix.split('/')):
        raise ValueError('Invalid COS key prefix')
    if staging:
        prefix += '/staging'
    base = config['publicBaseUrl']
    public_url(base, prefix)
    manifests = {}
    for asset, target in release_installers(release):
        name = asset['name']
        subprocess.run(
            [
                'gh',
                'release',
                'download',
                tag,
                '--repo',
                REPOSITORY,
                '--pattern',
                name,
                '--dir',
                str(directory),
            ],
            check=True,
        )
        path = directory / name
        digest = sha256(path)
        if path.stat().st_size != asset['size'] or asset.get('digest') not in (
            None,
            'sha256:' + digest,
        ):
            raise ValueError(f'GitHub asset integrity check failed: {name}')
        key = f'{prefix}/releases/{tag}/{target["platform"]}/{target["architecture"]}/{name}'
        url = public_url(base, key)
        with path.open('rb') as stream:
            store.put(
                key,
                stream,
                asset['size'],
                digest,
                mimetypes.guess_type(name)[0] or 'application/octet-stream',
                True,
            )
        verify_cdn(url, digest)
        manifests.setdefault(target['platform'], []).append(
            {
                **target,
                'fileName': name,
                'size': asset['size'],
                'sha256': digest,
                'url': url,
                'githubUrl': asset['browser_download_url'],
            }
        )
    if not manifests:
        raise ValueError('Release contains no supported installers')
    for platform, files in manifests.items():
        manifest = {
            'schemaVersion': 1,
            'tag': tag,
            'commit': commit,
            'platform': platform,
            'publishedAt': release['published_at'],
            'sourceReleaseId': release['id'],
            'assets': files,
        }
        key = f'{prefix}/releases/{tag}/{platform}/manifest.json'
        data = encode(manifest)
        digest = hashlib.sha256(data).hexdigest()
        store.put(key, io.BytesIO(data), len(data), digest, 'application/json', True)
        verify_cdn(public_url(base, key), digest)
        advance_channel(
            store,
            f'{prefix}/channels/stable/{platform}.json',
            {
                'schemaVersion': 1,
                'tag': tag,
                'commit': commit,
                'manifestUrl': public_url(base, key),
            },
        )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--tag', default=os.environ.get('RELEASE_TAG', ''))
    parser.add_argument('--dry-run', action='store_true')
    parser.add_argument('--staging', action='store_true')
    args = parser.parse_args()
    event = (
        json.loads(Path(os.environ['GITHUB_EVENT_PATH']).read_text())
        if os.environ.get('GITHUB_EVENT_PATH')
        else {}
    )
    tag, commit = source_tag(
        event, os.environ.get('GITHUB_EVENT_NAME', 'workflow_dispatch'), args.tag
    )
    release = check_release(github(f'repos/{REPOSITORY}/releases/tags/{tag}'), tag)
    config = json.loads(Path(__file__).with_name('cos.json').read_text())
    for key, variable in (
        ('bucket', 'COS_BUCKET'),
        ('region', 'COS_REGION'),
        ('publicBaseUrl', 'COS_PUBLIC_BASE_URL'),
        ('prefix', 'COS_KEY_PREFIX'),
    ):
        config[key] = os.environ.get(variable) or config[key]
    public_url(config['publicBaseUrl'], config['prefix'])
    plan = [asset['name'] for asset, _ in release_installers(release)]
    print(
        json.dumps(
            {
                'tag': tag,
                'commit': commit,
                'bucket': config['bucket'],
                'prefix': config['prefix'],
                'staging': args.staging,
                'files': plan,
            },
            indent=2,
        )
    )
    if not plan:
        raise ValueError('Release contains no installers')
    if args.dry_run:
        return
    for variable in ('COS_SECRET_ID', 'COS_SECRET_KEY'):
        if not os.environ.get(variable):
            raise ValueError(f'Configure the GitHub secret {variable} before uploading')
    with tempfile.TemporaryDirectory(prefix='cos-release-') as directory:
        publish(
            release,
            commit,
            config,
            Store(config['bucket'], config['region']),
            Path(directory),
            args.staging,
        )


if __name__ == '__main__':
    main()
