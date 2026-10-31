# Upstream sync — 2026-10-31

## Commits and scope

- Fork baseline: `631f4842` (`refactor/fork-integration-boundaries`).
- Previous upstream: `8d4f9744948751f1273fe871e1d05276fac09b0e` (v0.9.1).
- Selected upstream: `7fd417fb9a9a277c6a9339a8ac87f907df7c25f7` (v0.9.2), fetched from
  `https://github.com/chen08209/FlClash.git`, branch `main`.
- Integration branch: `sync/upstream-20261031`; merge back to the fork branch only after validation.
- 17 upstream commits, touching 431 files relative to the previous upstream baseline.

## Features brought in

DNS cache clearing (manual and on network changes), optional general config overrides and earlier apply,
three-day IP quality caching, profile QR codes and phone-to-TV links, adding a running proxy to local proxies,
adjustable latency timeout, colored tray status and optional macOS monochrome icons, desktop sidebar material,
higher-contrast dark theme, revised switches/search/menus and Android bottom-bar layout, large-document editor
work in the Rust rope, Android VPN resume without unnecessary reloads, and mihomo v1.19.33.

The fork keeps its version `0.9.3+2026102805`, ToWorld branding, iOS targets, panel module and board_sdk pointer.
Upstream and fork both published a v0.9.2 with different contents; keep the fork's published CHANGELOG.md and
changelog.json instead of replacing or unioning records by tag. The imported feature history remains in Git.

## Actual conflicts and resolutions

The initial merge reported 52 conflicted paths: 35 binary icon assets and 17 text files. Only three shared Dart
implementations conflicted: bootstrap.dart, common/tray.dart and providers/actions/setup.dart. Other text conflicts
were generated files, dependency/version metadata, release history, icon sources and one lint test.

- Keep fork app icons and their Android background. Retain the fork tray glyph; distinguish the TUN state with a
  teal background. Optional macOS template icons need a transparent glyph, not the fork's opaque blue app tile.
  Keep the fork default `monochromeTrayIcon: false` in both AppSettingProps and TrayState, and generate the matching
  models. Color icons come from tray/unix; monochrome icons come from tray/macos with isTemplate true.
- Keep bootstrap's fork navigation and its existing disclaimer choice while accepting the updated dialog APIs.
- Take upstream SetupAction's serviceStartTime seam, Android resume and applied-config state. Reapply iOS restore,
  deferred apply and connection-intent hooks; do not reintroduce compatibility aliases into upstream notifiers.
- Resolve generated conflicts by choosing a side, then regenerate from merged ARB/models/providers/schema. Do not
  edit generated Dart. Preserve fork ARB branding; panel strings remain in lib/xboard/l10n.
- Keep Windows path normalization in scaffold_bottom_inset_test while taking upstream's wider lib/ui exclusion.

## Compatibility changes Git did not flag

1. Upstream adds qr 4; qr_flutter 4.1 still requires qr 3. Reuse upstream QrCodeView in the fork invitation wrapper
   and remove qr_flutter, rather than forcing an incompatible dependency override.
2. CoreController.validateConfigWithData now takes bytes. Encode the non-iOS adapter input as UTF-8; keep iOS
   validation staged in App Group files, with cleanup and age plaintext copied back on success.
3. testUrl moved from AppSettingProps to PatchClashConfig. Pass optional latency URLs through FlClashGateway and
   let upstream resolve defaults; delay widgets observe delayProvider without pinning a stale URL snapshot.
4. The new edge-to-edge rule uses context.bottomInset, including its defining context extension. Update the fork
   subscription page and dashboard copy; BottomInsetScope alone omits the system bar.
5. dialogs.showMessage no longer takes cancelable. The invitation/account confirmation wrapper retains showMessage
   and removes that obsolete parameter; showAlert is the separate no-cancel API.
6. requestLocalNetworkPermission is new on the shared app channel. Supply the iOS default response in AppChannel;
   iOS grants actual local-network access through its own system prompt on use.
7. New Core DNS/proxy/route methods already pass through the generic iOS RPC channel; no per-method Swift whitelist
   is needed. Include iOS in the existing Flutter connectivity callback for automatic DNS clearing; Android keeps
   its native NetworkObserver. Background NE path monitoring is outside this merge.
8. The dashboard source changed without touching the fork copy. Review and port padding, editor actions and narrow
   desktop service-card layout, retain the fork start button and iOS filters/status, then update reviewedBlob to
   `8842d6bd` (full blob in tool/fork_sources.json). Upstream home.dart did not change, so its baseline stays intact.

## Refactor checks

The navigation decorator merged without text conflicts. Upstream did not change the shared service or Go builder
in this range, so their clean merges do not measure a before/after conflict reduction. Their runtime boundaries
and the extracted iOS framework path are covered by the checks below. Panel command adaptation stays in the fork
gateway, which owns no running state. The reviewed-copy
manifest required a dashboard review even though Git could merge the source cleanly. Keep the integration hooks
small and the upstream-owned copies clean; a clean textual merge alone is not validation.

## Verification

- `bash tool/merge_postprocess.sh`: passed, including 38 fork invariant tests, localization and code generation.
- `flutter analyze --no-fatal-infos`: no warnings/errors; 161 existing info diagnostics.
- `dart run tool/test.dart -- --concurrency=2 --reporter expanded`: passed. The initial full run covered 4,882 tests;
  one safe-mode icon assertion still assumed upstream's monochrome default. After changing it to the fork's color
  asset, all 18 tray-menu tests passed on the automatic isolated rerun. The original shared bundle was then rerun:
  all 128 tests passed, including the corrected assertion.
- `CGO_ENABLED=0 go test -p 2 .`: passed.
- `CGO_ENABLED=0 go vet -p 2 . ./cmd/...`: passed.
- `GOOS=darwin GOARCH=arm64 CGO_ENABLED=0 go build -p 2 -tags 'ios with_gvisor' ./...`: passed.
- `GOOS=android GOARCH=arm64 CGO_ENABLED=0 go vet -p 2 -tags=with_gvisor . ./mobile ./tun ./platform`: passed.
- `GOMAXPROCS=2 GOFLAGS=-p=2 dart run bin/build_ios.dart` from setup_hooks: passed; rebuilt both device and simulator
  arm64 slices, then assembled Mobile.xcframework from the new Core.
- `flutter build ios --profile --no-codesign --dart-define-from-file=env.json`: passed; Xcode completed in 114.5 s,
  producing a 165.4 MB Runner.app. No device install, launch, signing or upload was performed.
- Final formatting: 1,274 Dart files, no changes; no unresolved index entries or whitespace errors.

Android Kotlin compilation was not run: compileSdk 37 is required, but installed platforms stop at 36.1.
The bundled JBR 21 and NDK 28.2 are present; Gradle 9.8 is not cached and the Core AAR has not been built.
No SDK or JDK was installed for this validation. Phone-to-TV transfer and native platform callbacks still need
their respective physical-device checks.

The first icon-generation attempt was stopped by proxy.golang.org download timeouts in the build hook. Pre-fetching
modules with the machine's configured GOPROXY completed successfully; no module versions or checksum checks were
relaxed. Old regenerable macOS build caches/products and the Go compilation cache were cleared for disk space; the running
installed app and its Core process were not stopped. The iOS build then regenerated the required compilation cache. Never record this machine's proxy settings in source configuration.

The ordinary first-parent comment-density check also counts comments imported from the 17 upstream commits. Its
reported violations are unchanged upstream comments (up to 48% of a file's added lines), which AGENTS.md says to
preserve. The merge-resolution check excludes lines already in either parent and enforces the normal 5% cap on
new fork lines: 21 files, 66 added lines, two standalone comments, no violation. For this merge only, use the hook's
COMMENT_DENSITY_MAX=50 override for the imported-comment check; do not persist that setting or apply it to new code.
