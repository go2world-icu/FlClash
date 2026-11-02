# Fork release pipelines

`build.yaml` owns the Android/desktop checks, packages and GitHub Release. The fork's
`build-ios-fastlane.yaml` owns iOS; `publish-cos.yaml` mirrors stable Android/desktop installers.

| Trigger | iOS | iOS distribution | COS |
| --- | --- | --- | --- |
| `vX.Y.Z-pre.N` | Unsigned Release verification | Actions artifact only | Skipped |
| Manual iOS run, `upload_testflight=false` (default) | Unsigned Release verification | Actions artifact only | Skipped |
| Manual iOS run, `upload_testflight=true` | Signed archive/export | Actions artifact and TestFlight | Skipped |
| `vX.Y.Z` push | Signed archive/export | Actions artifact and TestFlight | Mirror Android/desktop installers |

The iOS workflow saves its artifact before uploading to TestFlight. Re-run only a failed
TestFlight job to reuse that signed IPA; re-running the build can produce different signed
bytes. TestFlight depends only on the successful iOS build, not the common build or GitHub
Release. Fastlane uploads the IPA; Flutter owns archive/export so VPN entitlements are
embedded during signing. A TestFlight upload does not submit an App Store review.

For a manual run, select `main` and enable `upload_testflight` to sign and upload.
The application version comes from `pubspec.yaml`; no GitHub tag or Release is needed.
The optional `build_number` overrides the build number in both build modes. Leaving it
empty uses the pubspec build number; TestFlight uploads need a number greater than the
one already uploaded. The source commit and application version remain in the artifact record.

## iOS entry point

```bash
bash ios/scripts/build_ios.sh verify --env pre
bash ios/scripts/build_ios.sh archive --env stable --export-options-plist ExportOptions.plist
bash ios/scripts/build_ios.sh archive --env stable --build-number 2026110103 --export-options-plist ExportOptions.plist
```

Both modes build `Mobile.xcframework` through the existing `setup_hooks` CLI before Xcode
links it. Certificate/profile installation stays in the signing workflow or the local
`ios/scripts/ios_release.sh` wrapper. `dart setup.dart ios ...` is a compatibility forwarder;
CI uses the shell entry to avoid running host Go/Rust build hooks through a root Dart script.
`--dry-run` shows the commands without building. Toolchain and CA bundle pins come from
`build.yaml`; verification and signed builds use the same Core builder and cache.

## COS configuration

Defaults live in `cos.json`; repository Variables can override them:

| Variable | Default |
| --- | --- |
| `COS_BUCKET` | `dwc-1256539025` |
| `COS_REGION` | `ap-hongkong` |
| `COS_PUBLIC_BASE_URL` | `https://dwc-1256539025.file.myqcloud.com` |
| `COS_DOWNLOAD_REFERER` | `https://toworld.uk/` |
| `COS_KEY_PREFIX` | `toworld` |

Set GitHub Secrets `COS_SECRET_ID` and `COS_SECRET_KEY`; temporary credentials additionally
use `COS_SESSION_TOKEN`. The upload identity needs HEAD/GET/PUT and PutObjectACL access only
to the configured prefix. Release tools do not read credentials from the panel configuration.

Writes and HEAD checks use the COS SDK origin endpoint derived from bucket/region:
`https://dwc-1256539025.cos.ap-hongkong.myqcloud.com`. `COS_PUBLIC_BASE_URL` is exclusively the
read/download endpoint. Installer objects, manifests and channels receive object-level
`public-read`; matching existing objects have their ACL repaired without overwriting bytes.
The bucket ACL and existing panel configuration objects outside `toworld/` are untouched.
The CDN domain must allow anonymous GET of the distribution prefix.
CDN verification sends the configured `Referer`. Download entries and channel pointers
include the same `headers` for clients; browser downloads should originate from `toworld.uk`.

```text
toworld/releases/vX.Y.Z/<platform>/<architecture>/<installer>
toworld/releases/vX.Y.Z/<platform>/manifest.json
toworld/channels/stable/<platform>.json
```

Installers and per-platform manifests are immutable and use a one-year cache policy.
Uploads check MD5, object SHA256 metadata/size and downloaded CDN bytes. A conflicting
object or failed CDN validation aborts before advancing channels. Channels have a 60-second
cache policy; configure CDN rules to respect it. Urgent channel changes may require a CDN
cache purge. An older release cannot replace a newer channel recommendation.

COS accepts Android, Windows, macOS and Linux installers only. Windows uploads include
only EXE installers; ZIP archives remain available on GitHub Release. iOS IPA files and their
release records stay in Actions artifacts, and signed IPAs go to TestFlight. iOS files are
excluded from COS even during manual backfills. iOS workflow completion does not trigger COS publication.

## First validation and retries

Install `publish-cos.yaml` on the default branch first: `workflow_run` is evaluated there.
Choose an existing stable Release and run the workflow manually with its `tag`:

1. Leave `dry_run=true`: inspect the tag/commit and upload plan without COS access.
2. Set `dry_run=false`, `staging=true`: upload and verify under `toworld/staging/`.
3. Set both to `false`: publish under `toworld/releases/` and advance stable channels.

Automatic runs publish only successful, same-repository stable tag pushes from `build`.
The tag must still resolve to the producer's exact SHA. The source
is the fork's GitHub Release, so mirrors do not depend on expiring Actions artifacts or
on `GITHUB_TOKEN` triggering a `release` event. Concurrent COS runs are serialized; a
cancelled pending run can be replayed manually by tag.

```bash
python3 -m unittest discover -s tool/distribution/tests -v
python3 tool/distribution/publish_cos.py --tag v0.9.3 --dry-run
```

The publisher uses Python and `gh`; it does not need Flutter, Go, submodules or Apple
credentials. TestFlight uses the existing `ASC_*` secrets, and signing uses the existing
`IOS_CERTIFICATE` / `IOS_CERTIFICATE_PASSWORD`. The iOS workflow does not attach GitHub
Release files or dispatch mirror publication.
