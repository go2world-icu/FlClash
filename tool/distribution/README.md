# Fork release pipelines

`build.yaml` owns the Android/desktop checks, packages and GitHub Release. The fork's
`build-ios-fastlane.yaml` owns iOS; `publish-cos.yaml` mirrors stable Android/desktop installers.

| Trigger | iOS | GitHub Release / TestFlight | COS |
| --- | --- | --- | --- |
| `vX.Y.Z-pre.N` | Unsigned Release verification | Neither | Skipped |
| Manual iOS run | Unsigned Release verification | Neither | Skipped |
| `vX.Y.Z` push | Signed archive/export | Attach IPA after the same tag/SHA's `build` succeeds, then upload to TestFlight | Mirror Android/desktop installers |

The iOS workflow saves its artifact before publishing. Re-run only the failed publishing
job to reuse that signed IPA; re-running the build can produce different signed bytes and
existing Release attachments are never overwritten. A failed common build blocks iOS
publication. Fastlane uploads the IPA; Flutter owns archive/export so VPN entitlements are
embedded during signing. A TestFlight upload does not submit an App Store review.

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
| `COS_KEY_PREFIX` | `toworld` |

Set GitHub Secrets `COS_SECRET_ID` and `COS_SECRET_KEY`; temporary credentials additionally
use `COS_SESSION_TOKEN`. The upload identity needs HEAD/GET/PUT access only to the configured
prefix. Release tools do not read credentials from the app's panel configuration.

Writes and HEAD checks use the COS SDK origin endpoint derived from bucket/region:
`https://dwc-1256539025.cos.ap-hongkong.myqcloud.com`. `COS_PUBLIC_BASE_URL` is exclusively the
read/download endpoint. Its CDN configuration must allow anonymous GET of the installer
prefix and authenticated origin pulls if the bucket is private. Existing configuration
objects outside `toworld/` are untouched.

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

COS accepts Android, Windows, macOS and Linux installers only. iOS IPA files and their
release records stay in GitHub Release / TestFlight and are excluded even during manual
backfills. iOS workflow completion does not trigger COS publication.

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
credentials. TestFlight uses the existing `ASC_*` secrets, signing uses the existing
`IOS_CERTIFICATE` / `IOS_CERTIFICATE_PASSWORD`, and optional mirror dispatch uses
`FlClash_AND_Publish_PAT`. iOS attachment completion dispatches the mirror again so it can
pick up the late iOS assets.
