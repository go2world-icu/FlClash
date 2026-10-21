# Merging upstream

This fork adds a panel module (`lib/xboard/`) and iOS support; upstream has neither. Both are wired into
upstream-owned files, so a merge resolved by "take theirs" silently drops the wiring. That has happened twice: the
desktop guard on `RustLib.init()` in `lib/main.dart`, and the explicit iOS Core build in the CI.

Measured on the 2026-10 merge: the fork touched 448 files, upstream touched 1196, and **77 were touched by both** —
that intersection is where every conflict comes from. `test/lint/fork_invariants_test.dart` guards the invariants that
must survive; it is what turns "someone remembered" into "the build fails".

## Procedure

```bash
git merge sync/main            # or whatever the upstream branch is called here
bash tool/merge_postprocess.sh  # submodules, arb union, l10n, build_runner, format, invariants
```

`tool/merge_postprocess.sh` is idempotent and covers everything that can be scripted. What it cannot do is below.

Afterwards: `flutter analyze`, `flutter test`, and once the tree is green, the two manual passes in
"Branding" and "CI delta".

## Conflicts by kind

Resolve them by kind, not file by file — most of the 77 fall into the first three buckets and need no judgement.

| Kind | Files | What to do |
|---|---|---|
| **Generated** | `lib/l10n/**`, `lib/providers/generated/**`, `lib/models/generated/**`, `lib/database/generated/**` | Never hand-merge. Take either side and regenerate; the script does it. |
| **lock / binary / submodule** | `pubspec.lock`, `core/go.sum`, `macos/Podfile.lock`, `core/Clash.Meta`, `assets/images/**` | Take one side, then let `pub get` / regeneration settle it. |
| **Docs, CI, config** | `CHANGELOG.md`, `README*`, `Makefile`, `.gitattributes`, `analysis_options.yaml`, `pubspec.yaml`, `.github/workflows/**` | Union: upstream's structure, plus the fork's entries. |
| **Upstream rewrote, the fork only added hooks** | `lib/main.dart`, `lib/application.dart`, `lib/providers/state.dart`, `lib/core/controller.dart`, `lib/common/{constant,path,tray,app_localizations}.dart`, `lib/enum/enum.dart`, `lib/views/**`, `core/*.go` | **Take theirs wholesale, then re-apply the fork's hook** — each is a handful of lines, usually an import plus a call. |

The last row is the important one. Do not try to preserve upstream's structure and the fork's edit hunk by hunk; take
upstream, then re-add the fork's lines. That is the direction the refactors in the next section push towards.

### The arb files are upstream's; the panel has its own table

Upstream did a localization rework and renamed most of its keys, and the union in `merge_postprocess.sh` kept the fork's
copies of the old names beside upstream's new ones. The 2026-10 merge therefore left **554** keys upstream does not have,
314 of them upstream's own pre-rewrite names, and `lib/l10n/l10n.dart` grew a getter for each — which made it the largest
conflict in the repository (12,200 diff lines across those nine files).

That is fixed at the source now: 355 keys nothing referenced were deleted, and the 199 in use moved to
`lib/xboard/l10n/xboard_strings.dart`, which the panel's call sites reach as `xboardL10n.<key>`. The nine files carry
only the four branded strings, so **the arb files are upstream's** — a merge takes theirs and resolves nothing.

Keep it that way. A panel string belongs in the table, not in `arb/`; `test/lint/fork_invariants_test.dart` fails if an
`xboard*` key reappears there. If a future merge does leave fork keys in the arb, the check is:

```bash
# keys the fork has and upstream does not
comm -13 <(git show <upstream>:arb/intl_en.arb | jq -r 'keys[]' | sort) \
         <(jq -r 'keys[]' arb/intl_en.arb | sort) > /tmp/extra.txt
# of those, the ones nothing references — safe to delete, and analyze will
# catch a key that was still in use
while read -r k; do grep -rqF ".$k" lib/ --include=*.dart || echo "$k"; done < /tmp/extra.txt
```

`jq -r` on Windows emits CRLF — strip it (`tr -d '\r'`) or every key looks unreferenced.

## Where the fork attaches (the anchors)

The fork's code lives in fork-owned files; upstream files only name it. One line that calls into a fork file survives a
merge far better than twenty lines of branch, and when it does conflict the resolution is obvious. Keep it that way: when
an upstream file needs fork behaviour, put the behaviour in the owner column and leave the anchor behind.

| Upstream file | Anchor | Owner |
|---|---|---|
| `lib/main.dart` | `await xboardStartup();` | `lib/xboard/startup.dart` |
| `lib/bootstrap.dart` | `navigationPort = const XBoardNavigationPort();` | `lib/xboard/navigation_port.dart` |
| `lib/application.dart` | `mobileManagerStack(state)`, `preloadXBoard(ref)`, `buildXBoardHome()` | `lib/manager/ios_manager.dart`, `lib/xboard/bridge.dart` |
| `lib/application.dart` | `buildXBoardHome()` returns the panel's `XBoardShellHome` off iOS — so the shell itself (the start button at the dock's end) is the fork's | `lib/xboard/home_shell.dart` |
| `lib/common/path.dart` | `forkDataDir(supportDirectory)` | `lib/common/data_dir.dart` |
| `lib/providers/actions/setup.dart` | `shouldDeferApply(ref, isBoot: …)` | `lib/core/ios_lifecycle.dart` |
| `lib/providers/state/navigation.dart` | the `iosCoreOff` filter | *(still inline — small and self-contained)* |
| `core/config.go` | `loadConfigForPlatformLimits(cfg)` | `core/config_{ios,default}.go` |
| `core/lifecycle.go` | `recreateTunOnReload` | `core/config_{ios,default}.go` |
| `core/tun/tun.go` | `applyPlatformTunOptions(&options)` | `core/tun/options_{ios,android}.go` |
| `core/hub.go` | — | zero diff; `handleSuspend` lives in `core/handle_suspend.go` |

Files that are back to upstream byte-for-byte and must stay there: `lib/common/app_ports.dart`, `lib/views/navigation.dart`,
`lib/providers/state.dart`, `lib/ui/icons/app_glyphs.dart`, `test/icons/glyph_painter_test.dart`,
`lib/views/dashboard/dashboard.dart`, `lib/views/dashboard/widgets/widgets.dart`, `lib/pages/home.dart`,
`lib/ui/navigation_dock.dart`. Adding a fork parameter to
`NavigationPort` is what pulled the first three into a merge at once; adding fork glyphs to `AppGlyphs`, a
`NodeSelectorChip` to the dashboard's floating button, or a fork export to the dashboard widgets barrel is what pulled
the last five in. All of it now lives in `lib/xboard/` (`icons/xboard_glyphs.dart`, `features/dashboard/`), and the
invariants test fails if any of it creeps back.

The last two are how the start button got its place back. Upstream v0.9.1 deleted `NavigationDock`'s trailing slot
(`trailing`, `_DockTrailing`, `_SlotMaterialize`) with the Liquid Glass rewrite, and the fork restores the layout in
`lib/xboard/home_shell.dart` instead of in the dock: `XBoardShellHome` is a copy of `lib/pages/home.dart` whose dock row is
`Expanded(NavigationDock) + _DockedStartButton` on a phone, and `buildXBoardHome()` serves it. That keeps both upstream
files byte-for-byte; a merge that re-copies `home.dart` over the copy drops the row and the invariants test says so.

The dashboard is the one upstream page the fork copies rather than wraps
(`lib/xboard/features/dashboard/xboard_dashboard_view.dart` is upstream's `dashboard.dart` with a `_XBoardDashboardAction`
overlay in the corner). When upstream rewrites that page — v0.9.1 moved the start toggle out of the floating button and
into the current-outbound card, and replaced the `SuperGrid` layout with `DashboardDensity` — re-copy the file and re-apply
only the overlay; everything else it imports (`views/dashboard/{layout,style,edit,widget_registry}.dart`, the cards) is
upstream's and is shared, not copied. Copying `DashboardDensityScope` or `DashboardWidgetMetrics` would give the cards a
second inherited type and make them silently fall back to the mobile metrics.

Accepted residuals — small, additive, self-contained, and not worth a seam: `lib/core/lib.dart` (`markConnected()` and
`isMobile`), `lib/common/tray.dart`, `lib/views/proxies/{list,tab}.dart` (the iOS empty-state label), `lib/plugins/app.dart`,
`lib/views/tools.dart`.

## iOS: the port that has to be redone every merge

Upstream has no iOS at all — no `ios/`, no iOS build tags in `core/`, no iOS in the build tooling. The whole layer is
the fork's, and it is wired into upstream files. Checklist, outermost to innermost:

1. **Core build tags.** `core/{lib.go, tun/tun.go}` must be `android || ios`; `core/{cmd/core/main.go, server.go,
   exit.go}` and `dial_socket.go` must exclude iOS. The invariants test asserts all of these. Upstream v0.9.0 moved
   `main.go` to `cmd/core/` and dropped the c-archive, so the old `(android || ios) && cgo` spellings are gone.
2. **iOS is bound with gomobile, like Android.** `core/mobile/mobile_ios.go` is the iOS half of the binding package;
   `plugins/setup/setup_hooks` builds one `Mobile.framework` per slice with `gomobile bind` and combines them into
   `libclash/ios/Mobile.xcframework`, which `Runner` and `PacketTunnel` link. That xcframework has to exist before
   `flutter build ios` reaches Xcode's link step, so `bin/build_ios.dart` builds it explicitly — the CI's `Build iOS`
   step and `setup.dart`'s iOS branch both run it first. The Swift side is `ios/PacketTunnel/ClashCore.swift`, which
   talks to the generated `Mobile*` API rather than the C function pointers the hand-built archive used.
3. **A few things upstream shares between the mobile targets only compile on Android.** `handleUpdateDns` calls
   `dns.UpdateSystemDNS`, which mihomo builds behind an `android` tag; `lib.go`'s protect/resolve hooks call
   `core/platform`, which is android/linux only. Both are behind a tag pair (`dns_{android,ios}.go`,
   `platform/limit_ios.go`) with the shared file naming them. Expect more of this: `go build` for iOS is the only
   thing that finds it, and no local machine here can.
4. **`rust_api` skips iOS.** It builds for every target Flutter builds, but `rquickjs-sys` publishes no iOS bindings.
   The hook returns early on `OS.IOS`, which is only safe because `main.dart` keeps `RustLib.init()` behind
   `system.isDesktop`.
5. **Handler/glue files** (`core/{config,dns,limit}_ios.go`, `config_default.go`, `core/platform/limit_ios.go`,
   `core/handle_suspend.go`, `core/mobile/mobile_ios.go`) and `ios/` are fork-owned — a merge never conflicts on them,
   only on the upstream files they hook into. Keep it that way: when an upstream `core/` file needs an iOS branch, add
   the branch to the fork-owned side of a tag pair and leave a one-line call behind. `core/config.go`, `core/lifecycle.go`
   and `core/tun/tun.go` are the three that already are.

   The iOS side of a pair is compiled by nothing before a release tag (CI vets host and Android only), so the
   invariants test asserts both sides still define every hook — and locally, `GOOS=darwin GOARCH=arm64 CGO_ENABLED=0
   go build -tags "ios <build_config tags>" ./...` type-checks the same file set `GOOS=ios` would, which real
   `GOOS=ios` cannot because it forces cgo.

Background: the fork's original iOS pipeline (`build-ios-fastlane.yaml`) pinned **Flutter 3.44.4**, before
`package:hooks` existed. iOS never ran a build hook there, so the whole class of problems only appeared once the fork
moved to upstream's toolchain.

## Branding

`appName = 'ToWorld'` and `repository` live in `lib/common/constant.dart`, but the rename is spread across platform
files that upstream also edits:

| File | What |
|---|---|
| `windows/CMakeLists.txt` | `project()`, `BINARY_NAME` |
| `windows/runner/main.cpp` | window title |
| `windows/runner/Runner.rc` | `OriginalFilename`, `ProductName` |
| `windows/packaging/exe/make_config.yaml` | `app_name`, `display_name`, `executable_name`, `output_base_file_name` |
| `windows/packaging/exe/inno_setup.iss` | process list — **keep `FlClash.exe`** so upgrades still kill the old process |
| `linux/CMakeLists.txt` | `BINARY_NAME` |
| `linux/runner/my_application.cc` | GTK titles |
| `linux/packaging/{deb,rpm,appimage}/make_config.yaml` | `display_name`, `package_name` |
| `macos/Runner/Configs/AppInfo.xcconfig` | `PRODUCT_NAME` |
| `macos/Runner.xcodeproj/project.pbxproj` | Runner target `PRODUCT_NAME` (**not** RunnerTests), the `.app` product reference, `CFBundleDisplayName` |
| `macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme` | `BuildableName` |
| `macos/Runner/Info.plist` | location permission string |
| `ios/Runner/Channels/ServiceChannel.swift` | the name Settings → VPN shows; read from `Bundle.main`'s `CFBundleDisplayName`, not written twice, and `renameIfNeeded` rewrites a configuration saved before a rename — iOS persists it with the profile, so it would otherwise keep the old name for the life of the install |
| `lib/common/protocol.dart` | Linux desktop-entry `Name=` |
| `tool/generate_status_icons.dart` | macOS status art sources |
| `.github/homebrew_cask_template.rb` | **leave pointing at upstream's repo** — it downloads real FlClash, not this fork |

**Do not rename**: `FlClashCore(.exe)` / `FlClashHelperService(.exe)` (the Go/Rust artifacts, and the helper
self-checks its SHA256), the bundle id `com.follow.clash`, the URL scheme `flclash`, or `FlClash.lock`.

## CI delta

`.github/workflows/build.yaml` is upstream's file with a fixed set of fork edits:

- six checkouts carry `submodules: recursive` **and** `token: ${{ secrets.BOARD_SDK_PAT || secrets.GITHUB_TOKEN }}`
  (`dart`, `desktop`, `go`, `android`, `build`, `upload`). Missing the token → `Repository not found` on the private
  `board_sdk` submodule; missing `submodules` → `flutter pub get` cannot find the path dependency.
- `strategy.fail-fast: false` on `build` — otherwise a failing iOS cancels the other six platforms' artifacts.
- the `ios` matrix entry and the two `if: startsWith(matrix.platform,'ios')` steps (`Build iOS core`, `Build iOS`).
- `Push to telegram`, the telegram-bot-api service, and the Homebrew/fdroid steps stay commented out — the script
  posts to `@FlClash`, upstream's channel, and the service is disabled here.

Upstream has none of the fork's other workflows — `build-ios-fastlane.yaml` (signed IPA + TestFlight),
`regen-ios-profiles.yaml`, `pages.yaml`, `sync-gitee-gitcode.yaml` — so a merge never touches them and whatever they pin
drifts silently. **Check their toolchain pins against `build.yaml` after every merge**: v0.9.0 moved to
Flutter 3.47.6 / Go 1.27.1, and `build-ios-fastlane.yaml` had been left on 3.44.4 / 1.26.4. Go is the sharp one —
`core/go.mod`'s `go` line makes an older toolchain download a newer one mid-build rather than fail cleanly.

## Upstream tests that assert upstream's values

Upstream's new tests hardcode upstream's choices, which this fork deliberately changed. Fix the **test** (the fork's
choice is the product), and prefer referencing a constant over the literal so the next merge has nothing to resolve:

| Test | Upstream asserts | The fork |
|---|---|---|
| `test/views/theme_test.dart` | default `ThemeMode.dark` | `ThemeMode.system` |
| `test/state_run_globals_test.dart` | UA contains `'FlClash/v…'` | `'$appName/v…'` |
| `test/providers/backup_action_test.dart`, `test/views/resources_view_test.dart` | homeDir is the support dir | `<supportDir>/<appName>` (commit `838f15a`) |
| `test/common/tray_menu_test.dart` | `isTemplate: true` on macOS | `false` — the tray art is a full-colour app icon |
| `test/lint/*` | `p.relative()` compared against `'/'` paths | normalize with `p.posix.joinAll(p.split(...))`; otherwise they vacuously pass on Windows (and their `_allowed` allowlists silently stop matching, so they *fail* on files they mean to skip) |
| `test/lint/length_unit_test.dart` | nothing may contain `Npx` | allowlist `lib/xboard/features/shared/styles/html_styles.dart` — it builds CSS declarations for the HTML renderer, where `px` is the unit |
| `test/lint/{reorder_proxy_decorator,sheet_scroll_controller,scaffold_bottom_inset}_test.dart` | *(new in v0.9.0)* | the path fix above; `commission_history_dialog.dart` also had to move to `sheetScrollController(context)` |

Not a value conflict, just a Windows-only failure — leave it, CI's `go test` is ubuntu-only:
`core/hub_test.go`'s `TestHandleValidateProxiesLeavesARunningProxysResolverInPlace` asserts the resolved path contains
`"/outside"`, which is `C:\outside` here. Editing an upstream test for a local-only failure adds a file to the
conflict set for no gain.

## Deliberate divergences (do not "fix" these)

- `appName = 'ToWorld'`, `repository = 'go2world-icu/FlClash-Publish'`.
- Default theme mode is `system`, not `dark`.
- The home directory is `<supportDirectory>/<appName>` on every platform.
- `PageLabel.xboard` and `FunctionTag.updateStatus` exist in upstream enums; `lib/common/app_ports.dart` may carry
  fork-facing parameters.
- `lib/sdk/board_sdk` is a private submodule; `assets/config/xboard.config.yaml` is tracked and holds placeholders
  only.
