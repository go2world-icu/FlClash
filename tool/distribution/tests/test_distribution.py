import copy
import hashlib
import importlib.util
import io
import json
import os
import plistlib
import subprocess
import sys
import tempfile
import threading
import unittest
import zipfile
from types import SimpleNamespace
from pathlib import Path
from unittest.mock import Mock, patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import publish_cos as cos
import release_tools as release


TAG = 'v0.9.3'
COMMIT = 'a' * 40


class MemoryStore:
    def __init__(self):
        self.objects = {}
        self.writes = []

    def read_json(self, key):
        return json.loads(self.objects[key]) if key in self.objects else None

    def put(self, key, stream, size, digest, content_type, immutable):
        data = stream.read()
        if len(data) != size or hashlib.sha256(data).hexdigest() != digest:
            raise ValueError('Invalid upload data')
        if immutable and key in self.objects:
            if self.objects[key] != data:
                raise ValueError('Immutable object changed')
            return False
        self.objects[key] = data
        self.writes.append(key)
        return True


class ReleaseTests(unittest.TestCase):
    def test_signed_ios_record_requires_vpn_entitlements_and_matching_app_groups(self):
        for fault in (None, 'vpn', 'group'):
            with self.subTest(fault=fault), tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                ipa_dir = root / 'build/ios/ipa'
                ipa_dir.mkdir(parents=True)
                info = {
                    'CFBundleIdentifier': 'com.follow.clash',
                    'CFBundleShortVersionString': '0.9.3',
                    'CFBundleVersion': '2026110102',
                }
                with zipfile.ZipFile(ipa_dir / 'Runner.ipa', 'w') as package:
                    package.writestr(
                        'Payload/Runner.app/Info.plist', plistlib.dumps(info)
                    )
                export = root / 'ExportOptions.plist'
                export.write_bytes(plistlib.dumps({'method': 'app-store'}))
                (root / 'env.json').write_text('{"APP_ENV": "stable"}')

                def codesign(args, **kwargs):
                    entitlements = {
                        'com.apple.developer.networking.networkextension': [
                            'packet-tunnel-provider'
                        ],
                        'com.apple.security.application-groups': ['group.example'],
                    }
                    if str(args[-1]).endswith('PacketTunnel.appex'):
                        if fault == 'vpn':
                            entitlements[
                                'com.apple.developer.networking.networkextension'
                            ] = []
                        elif fault == 'group':
                            entitlements['com.apple.security.application-groups'] = [
                                'group.other'
                            ]
                    return SimpleNamespace(stdout=plistlib.dumps(entitlements))

                previous = Path.cwd()
                try:
                    os.chdir(root)
                    with patch.dict(os.environ, {'GITHUB_REF_NAME': TAG}), patch.object(
                        release.subprocess, 'check_output', return_value=COMMIT
                    ), patch.object(release.subprocess, 'run', side_effect=codesign):
                        if fault:
                            with self.assertRaises(ValueError):
                                release.record_ios('archive', str(export))
                            self.assertEqual(list((root / 'dist').glob('*.json')), [])
                        else:
                            release.record_ios('archive', str(export))
                            record = release.validate_ios(root / 'dist', TAG, COMMIT)
                            self.assertEqual(record['distribution'], 'app-store')
                            self.assertEqual(record['buildNumber'], '2026110102')
                finally:
                    os.chdir(previous)

    def test_stable_tag_requires_the_complete_numeric_tag(self):
        self.assertEqual(release.stable_version(TAG), (0, 9, 3))
        for tag in ('v0.9.3-pre.9', 'main', 'v0.9.3/other', 'v00.9.3', 'v0.9.3\n'):
            with self.subTest(tag=tag), self.assertRaises(ValueError):
                release.stable_version(tag)

    def test_only_the_fork_stable_tag_push_enables_ios_publishing(self):
        root = Path(__file__).resolve().parents[3]
        pins = (root / '.github/workflows/build.yaml').read_text()
        for ref, event, repository, expected in (
            ('refs/tags/v0.9.3', 'push', release.REPOSITORY, True),
            ('refs/tags/v0.9.3-pre.9', 'push', release.REPOSITORY, False),
            ('refs/heads/v0.9.3', 'push', release.REPOSITORY, False),
            ('refs/tags/v0.9.3', 'workflow_dispatch', release.REPOSITORY, False),
            ('refs/tags/v0.9.3', 'push', 'other/fork', False),
        ):
            with self.subTest(
                ref=ref, event=event, repository=repository
            ), tempfile.TemporaryDirectory() as directory:
                output = Path(directory) / 'output'
                env_file = Path(directory) / 'env'
                Path(directory, 'pubspec.yaml').write_text(
                    'version: 0.9.3+2026110102\n'
                )
                Path(directory, '.github/workflows').mkdir(parents=True)
                Path(directory, '.github/workflows/build.yaml').write_text(pins)
                env = {
                    'GITHUB_REF': ref,
                    'GITHUB_EVENT_NAME': event,
                    'GITHUB_REPOSITORY': repository,
                    'GITHUB_OUTPUT': str(output),
                    'GITHUB_ENV': str(env_file),
                }
                previous = Path.cwd()
                try:
                    os.chdir(directory)
                    with patch.dict(os.environ, env), patch.object(
                        release.subprocess, 'check_output', return_value=COMMIT
                    ):
                        release.context()
                finally:
                    os.chdir(previous)
                self.assertIn(f'publish={str(expected).lower()}\n', output.read_text())
                self.assertIn('CA_BUNDLE_SHA256=', env_file.read_text())

    def test_unsigned_or_tampered_ios_artifact_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            directory = Path(directory)
            package = directory / 'ToWorld-0.9.3-ios-arm64.ipa'
            package.write_bytes(b'signed package')
            record = {
                'tag': TAG,
                'commit': COMMIT,
                'distribution': 'app-store',
                'appEnv': 'stable',
                'fileName': package.name,
                'size': package.stat().st_size,
                'sha256': release.sha256(package),
            }
            metadata = package.with_suffix('.json')
            metadata.write_text(json.dumps(record))
            self.assertEqual(release.validate_ios(directory, TAG, COMMIT), record)
            record['distribution'] = 'unsigned'
            metadata.write_text(json.dumps(record))
            with self.assertRaises(ValueError):
                release.validate_ios(directory, TAG, COMMIT)
            record['distribution'] = 'app-store'
            metadata.write_text(json.dumps(record))
            package.write_bytes(b'tampered package')
            with self.assertRaises(ValueError):
                release.validate_ios(directory, TAG, COMMIT)

    def test_moved_tag_cannot_publish_a_previously_built_ipa(self):
        with patch.object(
            release, 'tag_commit', return_value='b' * 40
        ), self.assertRaises(ValueError):
            release.wait_release(release.REPOSITORY, TAG, COMMIT, 0)

    def test_a_failed_common_build_prevents_ios_release(self):
        run = {
            'id': 1,
            'head_branch': TAG,
            'head_sha': COMMIT,
            'status': 'completed',
            'conclusion': 'failure',
        }
        with patch.object(release, 'tag_commit', return_value=COMMIT), patch.object(
            release, 'github', return_value={'workflow_runs': [run]}
        ), self.assertRaises(ValueError):
            release.wait_release(release.REPOSITORY, TAG, COMMIT, 5)


class CosTests(unittest.TestCase):
    def test_cdn_verification_sends_the_download_referer(self):
        content = b'installer'
        with patch.object(
            cos.urllib.request, 'urlopen', return_value=io.BytesIO(content)
        ) as request:
            cos.verify_cdn(
                'https://cdn.example.com/file.apk',
                hashlib.sha256(content).hexdigest(),
                {'Referer': 'https://toworld.uk/'},
            )
        self.assertEqual(
            request.call_args.args[0].get_header('Referer'), 'https://toworld.uk/'
        )

    def test_ios_ipa_and_release_records_never_enter_cos_uploads(self):
        source = {
            'tag_name': TAG,
            'assets': [
                {'name': 'ToWorld-0.9.3-ios-arm64.ipa'},
                {'name': 'ToWorld-0.9.3-ios-arm64.json'},
                {'name': 'ToWorld-0.9.3-windows-amd64-setup.exe'},
            ],
        }
        selected = cos.release_installers(source)
        self.assertEqual(
            [item['name'] for item, _ in selected],
            ['ToWorld-0.9.3-windows-amd64-setup.exe'],
        )
        self.assertIsNone(cos.installer({'name': 'ToWorld-0.9.3-ios-arm64.ipa'}, TAG))

    def test_existing_cos_object_is_skipped_only_when_size_and_digest_match(self):
        store = object.__new__(cos.Store)
        store.bucket = 'test-bucket'
        store.client = SimpleNamespace(put_object_acl=Mock())
        digest = hashlib.sha256(b'apk').hexdigest()
        head = {'content-length': '3', 'x-cos-meta-sha256': digest}
        with patch.object(store, 'head', return_value=head):
            self.assertFalse(
                store.put(
                    'file',
                    io.BytesIO(b'apk'),
                    3,
                    digest,
                    'application/octet-stream',
                    True,
                )
            )
            store.client.put_object_acl.assert_called_once_with(
                Bucket='test-bucket',
                Key='file',
                ACL='public-read',
            )
            store.client.put_object_acl.reset_mock()
            with self.assertRaises(ValueError):
                store.put(
                    'file',
                    io.BytesIO(b'other'),
                    5,
                    hashlib.sha256(b'other').hexdigest(),
                    'application/octet-stream',
                    True,
                )
            store.client.put_object_acl.assert_not_called()

    def test_dry_run_needs_no_cos_sdk_client_or_downloads(self):
        source = {
            'tag_name': TAG,
            'id': 1,
            'draft': False,
            'prerelease': False,
            'assets': [{'name': 'ToWorld-0.9.3-windows-amd64-setup.exe'}],
        }
        with patch.dict(os.environ, {}, clear=True), patch.object(
            sys, 'argv', ['publish_cos.py', '--tag', TAG, '--dry-run']
        ), patch.object(cos, 'source_tag', return_value=(TAG, COMMIT)), patch.object(
            cos, 'github', return_value=source
        ), patch.object(
            cos, 'Store'
        ) as store, patch.object(
            cos.subprocess, 'run'
        ) as download, patch(
            'sys.stdout', new_callable=io.StringIO
        ) as output:
            cos.main()
        store.assert_not_called()
        download.assert_not_called()
        self.assertIn('windows-amd64-setup.exe', output.getvalue())

    def test_windows_setup_names_and_platform_formats_match_real_releases(self):
        for arch in ('amd64', 'arm64'):
            self.assertIsNotNone(
                cos.installer({'name': f'ToWorld-0.9.3-windows-{arch}-setup.exe'}, TAG)
            )
        self.assertIsNone(cos.installer({'name': 'ToWorld-0.9.3-ios-arm64.exe'}, TAG))

    @unittest.skipUnless(
        importlib.util.find_spec('qcloud_cos'), 'COS SDK is only needed by the uploader'
    )
    def test_real_sdk_uses_the_cos_origin_and_protects_immutable_objects(self):
        digest = hashlib.sha256(b'apk').hexdigest()
        with patch.dict(
            os.environ,
            {'COS_SECRET_ID': 'test-id', 'COS_SECRET_KEY': 'test-key'},
            clear=True,
        ):
            store = cos.Store('dwc-1256539025', 'ap-hongkong')
        head = {'content-length': '3', 'x-cos-meta-sha256': digest}
        with patch.object(store, 'head', side_effect=[None, head]), patch.object(
            store.client, 'send_request', return_value=SimpleNamespace(headers={})
        ) as request:
            store.put(
                'toworld/file.apk',
                io.BytesIO(b'apk'),
                3,
                digest,
                'application/octet-stream',
                True,
            )
        self.assertEqual(
            request.call_args.kwargs['url'],
            'https://dwc-1256539025.cos.ap-hongkong.myqcloud.com/toworld/file.apk',
        )
        headers = request.call_args.kwargs['headers']
        self.assertEqual(headers['x-cos-forbid-overwrite'], 'true')
        self.assertEqual(headers['x-cos-meta-sha256'], digest)
        self.assertEqual(headers['x-cos-acl'], 'public-read')
        self.assertIn('Content-MD5', headers)

    def test_all_existing_installer_formats_are_supported(self):
        for platform, arch, formats in (
            ('android', 'arm64-v8a', ['apk']),
            ('windows', 'arm64', ['exe', 'zip']),
            ('macos', 'amd64', ['dmg']),
            ('linux', 'amd64', ['deb', 'rpm', 'AppImage']),
        ):
            for extension in formats:
                with self.subTest(platform=platform, extension=extension):
                    self.assertIsNotNone(
                        cos.installer(
                            {'name': f'ToWorld-0.9.3-{platform}-{arch}.{extension}'},
                            TAG,
                        )
                    )
        self.assertIsNone(
            cos.installer({'name': '../ToWorld-0.9.3-linux-amd64.deb'}, TAG)
        )
        self.assertIsNone(cos.installer({'name': 'ToWorld-0.9.2-linux-amd64.deb'}, TAG))

    def test_untrusted_workflows_and_non_tag_commits_are_rejected(self):
        run = {
            'repository': {'full_name': release.REPOSITORY},
            'head_repository': {'full_name': release.REPOSITORY},
            'path': '.github/workflows/build.yaml',
            'event': 'push',
            'conclusion': 'success',
            'head_branch': TAG,
            'head_sha': COMMIT,
        }
        with patch.object(cos, 'tag_commit', return_value=COMMIT):
            self.assertEqual(
                cos.source_tag({'workflow_run': run}, 'workflow_run', ''), (TAG, COMMIT)
            )
            for key, value in (
                ('event', 'pull_request'),
                ('head_sha', 'b' * 40),
                ('path', '.github/workflows/untrusted.yaml'),
                ('head_branch', TAG + '-pre.1'),
                ('conclusion', 'failure'),
            ):
                changed = {**run, key: value}
                with self.subTest(key=key), self.assertRaises(ValueError):
                    cos.source_tag({'workflow_run': changed}, 'workflow_run', '')

    def test_older_release_cannot_move_a_channel_backwards(self):
        store = MemoryStore()
        key = 'toworld/channels/stable/linux.json'
        current = {'tag': 'v0.10.0', 'commit': COMMIT}
        store.objects[key] = cos.encode(current)
        cos.advance_channel(store, key, {'tag': TAG, 'commit': COMMIT})
        self.assertEqual(store.read_json(key), current)
        self.assertEqual(store.writes, [])

    def test_public_download_url_is_separate_from_the_write_client(self):
        url = cos.public_url(
            'https://cdn.example.com', 'toworld/releases/v0.9.3/file.apk'
        )
        self.assertEqual(
            url, 'https://cdn.example.com/toworld/releases/v0.9.3/file.apk'
        )
        for base in (
            'http://cdn.example.com',
            'https://user:secret@cdn.example.com',
            'https://cdn.example.com?key=value',
        ):
            with self.subTest(base=base), self.assertRaises(ValueError):
                cos.public_url(base, 'file.apk')

    def publish_fixture(self, directory, store, staging=False, cdn_error=False):
        content = b'installer bytes'
        name = 'ToWorld-0.9.3-linux-amd64.deb'
        asset = {
            'name': name,
            'size': len(content),
            'digest': 'sha256:' + hashlib.sha256(content).hexdigest(),
            'browser_download_url': 'https://github.com/example/file.deb',
        }
        source = {
            'tag_name': TAG,
            'id': 1,
            'published_at': '2026-11-01T00:00:00Z',
            'assets': [asset],
        }
        config = {'prefix': 'toworld', 'publicBaseUrl': 'https://cdn.example.com'}

        def download(*args, **kwargs):
            (directory / name).write_bytes(content)

        with patch.object(cos.subprocess, 'run', side_effect=download), patch.object(
            cos,
            'verify_cdn',
            side_effect=ValueError('CDN failure') if cdn_error else None,
        ):
            cos.publish(source, COMMIT, config, store, directory, staging)

    def test_staging_upload_never_changes_the_production_channel(self):
        store = MemoryStore()
        with tempfile.TemporaryDirectory() as directory:
            self.publish_fixture(Path(directory), store, staging=True)
        self.assertTrue(store.writes)
        self.assertTrue(all(key.startswith('toworld/staging/') for key in store.writes))

    def test_failed_cdn_validation_does_not_advance_the_channel(self):
        store = MemoryStore()
        with tempfile.TemporaryDirectory() as directory, self.assertRaises(ValueError):
            self.publish_fixture(Path(directory), store, cdn_error=True)
        self.assertFalse(any('/channels/' in key for key in store.writes))
        with tempfile.TemporaryDirectory() as directory, self.assertRaises(ValueError):
            self.publish_fixture(Path(directory), store, cdn_error=True)
        self.assertFalse(any('/channels/' in key for key in store.writes))

    def test_parallel_cdn_checks_finish_before_any_index_is_published(self):
        store = MemoryStore()
        content = b'installer'
        names = [f'ToWorld-0.9.3-linux-{arch}.deb' for arch in ('amd64', 'arm64')]
        source = {
            'tag_name': TAG,
            'assets': [
                {
                    'name': name,
                    'size': len(content),
                    'browser_download_url': 'https://github.com/example/' + name,
                }
                for name in names
            ],
        }
        barrier = threading.Barrier(2)

        def verify(url, *args):
            barrier.wait(timeout=5)
            if '/arm64/' in url:
                raise ValueError('CDN failure')

        with tempfile.TemporaryDirectory() as directory:
            directory = Path(directory)
            for name in names:
                (directory / name).write_bytes(content)
            with patch.object(cos.subprocess, 'run'), patch.object(
                cos, 'verify_cdn', side_effect=verify
            ), self.assertRaisesRegex(ValueError, 'CDN failure'):
                cos.publish(
                    source,
                    COMMIT,
                    {'prefix': 'toworld', 'publicBaseUrl': 'https://cdn.example.com'},
                    store,
                    directory,
                )
        self.assertEqual(len(store.writes), 2)
        self.assertFalse(any(key.endswith('.json') for key in store.writes))

    def test_retries_preserve_immutable_manifest_and_artifact_bytes(self):
        store = MemoryStore()
        with tempfile.TemporaryDirectory() as directory:
            self.publish_fixture(Path(directory), store)
            snapshot = copy.deepcopy(store.objects)
            self.publish_fixture(Path(directory), store)
            self.assertEqual(store.objects, snapshot)
            key = next(key for key in store.objects if key.endswith('.deb'))
            store.objects[key] = b'different installer'
            with self.assertRaises(ValueError):
                self.publish_fixture(Path(directory), store)


class IosScriptTests(unittest.TestCase):
    def test_verify_and_archive_commands_use_the_same_core_entry(self):
        script = Path(__file__).resolve().parents[3] / 'ios/scripts/build_ios.sh'
        for mode, expected in (('verify', '--no-codesign'), ('archive', 'build ipa')):
            result = subprocess.run(
                ['bash', str(script), mode, '--dry-run'],
                check=True,
                capture_output=True,
                text=True,
            )
            self.assertIn('bin/build_ios.dart', result.stdout)
            self.assertIn(expected, result.stdout)
        result = subprocess.run(
            ['bash', str(script), 'verify', '--env', 'invalid', '--dry-run'],
            capture_output=True,
        )
        self.assertNotEqual(result.returncode, 0)


if __name__ == '__main__':
    unittest.main()
