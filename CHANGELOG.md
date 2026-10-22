# Changelog

## v0.9.2 (2026-10-22)

**Bug Fixes**

- **xboard** Keep login available when panel health checks fail (474d3c8)

## v0.9.1 (2026-10-22)

**Breaking Changes**

- **network** Desktop TUN keys follow the profile unless picked; changed values carry over (cb08088)
- **views** DNS and NTP override toggles are removed; picked keys apply to every profile (491fae1)
- **database** Custom overwrites are removed; rebuild them as custom profiles (1677024)

**Features**

- **xboard** One shell for every platform, iOS included (3e198e9)
- **xboard** Park the node picker and seat the start button at the dock's end (f44dcac)
- **l10n** French, Spanish and Korean translations (f43755c)
- **android** No more Firebase analytics or crash reporting (bc72bba)
- **network** Per-key desktop TUN settings; system proxy and tray fixes (cb08088)
- **theme** Redesigned theme colors and color styles (5eafd7a)
- **dashboard** A redesigned dashboard around the current exit (9bd258f)
- **profiles** Profile-detail resources and include-all in custom groups (0bac500)
- **proxies** Proxy groups as cards, group tabs as chips (2ea52fd)
- **views** Sortable tables for connections, requests and DNS (da6fb0a)
- **ui** Optional two-tier Liquid Glass and slide-to-pick menus (7c9627f)
- **ui** iOS-style surfaces, alerts and sheets; clearer TV focus (9bd2286)
- **ios** Let the extension say whether it booted the core (e23ad12)
- **ios** A third signal, so a dead channel stops looking like a dead core (78ce407)
- **ios** Put the startup status in the shell's navigation bar (827dd67)
- **icons** 手绘 26 个字形并让 xboard 停用 Material 图标 (4f4e926)
- **views** Per-key DNS, NTP, sniffer and TUN settings (491fae1)
- **profiles** Custom profiles (3abda78)
- **ui** Stacked sheets, context menus and a sort mode (8c43053)
- **providers** DNS, Hosts and ports apply without a restart (532ebf0)
- **android** Launcher shortcuts and one-step on-demand access (d3fa225)
- **core** Share link import and mrs rule sets (2fa2f7f)
- **editor** Editor word wrap and snippets (e131675)
- **dashboard** More dashboard cards (e62afb7)
- **views** Hide timed-out nodes and search every list (8378c70)
- **ui** Sidebar, floating dock and drag to go back (841d603)
- **ui** New app glyphs, empty states and theme page (ee6a497)
- **overwrite** Invalid override warnings and rule presets (46fb7fe)
- **config** DNS query log and per-key DNS/NTP overrides (a390a42)
- **core** Proxied service checks and outbound IP risk (8068e68)
- **platform** Tray hotkeys, node delays and a delay test (1e97716)
- **ui** Rework the app UI and refresh the localization (26cfbaf)
- **app** Rework the app layer and window handling, and add proxy authentication (aaf934c)
- **desktop** Rework the desktop runners, packaging, and native build (c0fcbc0)
- **android** Rework the Android VPN service and lifecycle handling (ae29f38)
- **plugins** Rework the desktop plugins and add the Helper service and Rust bridge (adf715f)
- **core** Rework the core IPC and process lifecycle (c6eaa0a)

**Bug Fixes**

- **xboard** Save a subscription before asking the core to validate it (40bbdca)
- **ios** Answer the core channel upstream split off (82be26c)
- **xboard** Clear the floating dock under the panel's own page (c24deb1)
- **ui** Fix pasting and Chinese input in text fields (5607f70)
- **core** Large profiles no longer crash; downloads trust core CAs (5984c16)
- **ios** Stop dropping GEOSITE rules when their database is there (9e27740)
- **ios** Implement the two app-channel probes the shared UI calls (6b35ce7)
- **ios** Read the extension's answer in either shape (3857a41)
- **ios** The service channel answered in the wrong type (86adfb2)
- **ci** The watchdog was reading a ps field macOS does not have (e2e7fd5)
- **ci** Watch the stuck codesign itself, and retry up to three times (a8a5dbc)
- **ci** The retry never ran, and drop the partition list the canary indicted (75044c5)
- **ios** Stop losing the Core silently, and show where startup got to (a1e0c08)
- **ios** Name the VPN entry after the app, not "FlClash" (6fccec1)
- **ios** The gomobile framework is static, so it is not embedded (66a5365)
- **ci** Follow build.yaml in the fork-owned iOS workflows (97f85f2)
- **ios** Conform to the generated protocol, not its class (d9198eb)
- **ios** Declare files, not the .framework directory, as outputs (3516b25)
- **ios** Put gobind on PATH for gomobile (cd76476)
- **ios** Gomobile writes the xcframework itself (1ed76ee)
- **ci** Upload job 的 checkout 补上子模块与 token (31ffce8)
- **ios** 恢复 RustLib 的桌面守卫，并让 rust_api 在 iOS 上跳过构建 (4b23849)
- **ios** Rust_api 的 rust-toolchain.toml 补上 iOS 目标 (b6a17ff)
- **ios** Bride.c 补上 ios 构建标签；清理误入库的 core 二进制 (be9cd9b)
- **ios** 恢复显式的 iOS core 构建，并关掉 matrix fail-fast (e588029)
- **ci** 恢复 fork 对 Push to telegram 步骤的注释 (43e7c20)
- **lint** 修 Go 格式与 dead_file_test 的两处问题 (7d55ac9)
- **tray** 统一托盘图标路径的分隔符，修 Windows 上两个测试 (920463c)
- **ci** 修 checkout 认证、插件测试与新增测试的格式 (754b7c0)
- 恢复 fork 的托盘图标与 ToWorld 品牌 (1d2250c)
- **database** Unreadable settings no longer block startup or restores (1677024)
- **desktop** Windows and Linux desktop fixes (94a25f4)
- **core,helper** The elevated Core only answers its owner (d780cb8)
- **core** A changed resource link is now used by the next sync and by auto update (ff23f30)
- **core** DNS lookups no longer fail on networks that report no DNS servers (e55f6d1)
- **proxies** Smaller icons in icon-only group headers (786a6ab)
- **core,android** Push notifications reconnect in Doze (1e9955d)
- **backup,database** Restores never apply halfway (bee8f24)
- **resources** Refresh the geo file size and time after an update finishes (c5bf5bd)
- **core** Keep the core running while Windows sleeps with the app suspended (60f371a)

**Performance**

- **xboard** Stop the panel's own speed tests from running the link ragged (ae84afa)
- **android** Smoother Android UI while the proxy is busy (2201c19)

**Reverts**

- **ci** Keep the partition list the working recipe had (531790d)

<!-- changelog:frozen -->
<!-- Entries below predate the structured pipeline. Their wording is kept as written; only the heading and list style were normalized. -->

## v0.8.96 (2026-08-17)

- Optimize commented policy
- Fix whole group delay test failing on Windows
- Optimize package icon loading and connections polling

## v0.8.95 (2026-08-14)

- Optimize core service
- Optimize Android TV launcher icon
- Optimize back navigation
- Optimize more details
- Fix some issues
- Optimize app layout
- Optimize focus control
- Adjust android process
- 主题默认为系统跟随/升级版本

## v0.8.94-pre1

- 修改build版本
- 仪表盘添加节点选择/隐藏代理菜单
- 位置	修改	作用
- _setupConfig	MD5 没变时跳过 setupConfig	层1: 防止不必要的 Core 重载
- restartCore	重置 lastConfigMd5 = null	层2: 保证重启后一定重载 config
- updateGroups	空数据/异常时不清空已有 groups	层3: 安全网，任何瞬态失败不丢失数据
- 安卓桌面图标修复/脚本修复
- fix: 修复登录后代理菜单为空的问题 — _setupConfig 时序竞态
- 根因: _addProfile() 调用 applyProfile(silence: true) 后，fullSetup()
- 通过 addPostFrameCallback 再次调用 applyProfile(force: true)，两次都
- 触发 _setupConfig → coreController.setupConfig()，导致 Core 在 reload
- 期间 getProxies() 返回空数据覆盖了正确的代理列表。
- 修复 (lib/providers/action.dart):
- 1. _setupConfig: config MD5 未变时跳过 coreController.setupConfig()，
-    避免不必要的 Core 重载，但保留 onUpdated 刷新代理数据
- 2. restartCore: 重置 lastConfigMd5 = null，确保 Core 重启后 config
-    一定会重新加载
- 诊断 (profile_import_service.dart):
- - _addProfile() 中记录 Core 状态、applyProfile 前后的 groups 数量
- Add .agents/app-store-release.md: TestFlight review + App Store release flow
- 修改buid版本
- fix: align iOS AppGroup paths with Dart appName (ToWorld) + shared.json
- Add local ios_release.sh that mirrors CI signing+build (dart setup.dart ios)
- Add .agents/release-ios.md: iOS TestFlight publishing pipeline docs
- Unify iOS build into setup.dart (make core-ios + flutter build ipa); CI uses dart setup.dart ios
- Move Gitee/GitCode release sync to standalone sync-gitee-gitcode workflow
- Remove obsolete build-ios.yaml (superseded by build-ios-fastlane.yaml)
- Regen workflow also syncs pbxproj profile specifiers
- Manual signing with explicit PROVISIONING_PROFILE_SPECIFIER per target (fixes GatherProvisioningInputs)
- Install profiles to UserData location too (Xcode GatherProvisioningInputs)
- Sign at archive time so entitlements get embedded (CODE_SIGN_STYLE=Manual)
- Override FLUTTER_BUILD_NUMBER (Info.plist uses it directly for CFBundleVersion)
- Use raw xcodebuild archive+export (gym export hung on CODE_SIGNING_ALLOWED=NO); fastlane uploads only
- Pass profile UUIDs via GITHUB_ENV (workflow bash) instead of Ruby backticks
- Match profiles by embedded UUID in export (names change after regen)
- Regenerate iOS provisioning profiles with Apple Distribution cert
- Install profiles by embedded UUID (no hardcoded UUIDs); regen no longer patches workflow file
- Use GITHUB_TOKEN in regen checkout so workflow-file push is allowed
- Use BSD sed syntax (-i '') for macOS runner
- Set UUID shell vars alongside GITHUB_ENV (nounset was killing verify step)
- Fix find-identity hash extraction regex (had missing index prefix)
- Keep only Apple Distribution cert in regen keychain (sigh picks wrong cert otherwise)
- Import signing cert in regen workflow so sigh can create profiles
- Run regen-ios-profiles on macos (sigh install needs Xcode)
- Fix sigh conflict: force implies readonly=false, drop explicit readonly
- Add iOS profile regeneration workflow (fastlane sigh force-regenerate)
- bug
- ios ci
- iOS 包名加版本号，统一为 ToWorld-{version}-ios-arm64.ipa

## v0.8.94 (2026-07-11)

- Fix macos performance issue
- Support custom global-ua
- Update core
- Optimize some details
- Fix linux silent launching not working
- 环境问题linux-arm64不编译
- 不编译linux arm64
- ubuntu-22.04-arm
- pub.dev
- fix: 直接在 jni 目标上应用 -Wno-error=incompatible-pointer-types
- fix: 兼容 GCC 14+ 编译 jni 插件时 va_list 类型不匹配（CMAKE_C_FLAGS）
- refactor: homeDir 统一放入 appName 子目录，隔离原项目文件
- fix: 全局兼容 GCC 14+ va_list 编译错误（jni FFI 插件）
- fix: 兼容 GCC 14+ 编译 jni 插件时 va_list 类型不匹配
- rename: FlClash -> ToWorld（仅改用户可见的显示名，保留内部标识）

## v0.8.93 (2026-05-29)

- Support custom overwrite
- Support run on demand
- Optimize windows ipc
- Optimize windows arm64
- Optimize build
- Optimize some details
- Update core
- fix: _hasCommand 使用 which 替代 command，兼容 CI 环境
- 打包中间文件
- @
- feat: 集成 xboard 面板模块
- 基于上游 main，合并 main（含 xboard 分支）的全部改动。
- @

## v0.8.92 (2026-02-02)

- Add sqlite store
- Optimize android quick action
- Optimize backup and restore
- Optimize more details

## v0.8.91 (2025-12-12)

- Fix windows some issues
- Optimize overwrite handle
- Optimize access control page
- Optimize some details

## v0.8.90 (2025-10-08)

- Fix android tile service
- Support append system DNS
- Fix some issues
- Update changelog

## v0.8.89 (2025-09-27)

- Fix some issues
- Optimize Windows service mode
- Update core
- Update changelog

## v0.8.88 (2025-09-23)

- Add android separates the core process
- Support core status check and force restart
- Optimize proxies page and access page
- Update flutter and pub dependencies
- Update go version
- Optimize more details
- Update changelog

## v0.8.87 (2025-07-29)

- Optimize desktop view
- Optimize logs, requests, connection pages
- Optimize windows tray auto hide
- Optimize some details
- Update core
- Update changelog

## v0.8.86 (2025-06-15)

- Fix windows tun issues
- Optimize android get system dns
- Optimize more details
- Update changelog

## v0.8.85 (2025-06-07)

- Support override script
- Support proxies search
- Support svg display
- Optimize config persistence
- Add some scenes auto close connections
- Update core
- Optimize more details

## v0.8.84 (2025-05-01)

- Fix windows service verify issues
- Update changelog

## v0.8.83 (2025-05-01)

- Add windows server mode start process verify
- Add linux deb dependencies
- Add backup recovery strategy select
- Support custom text scaling
- Optimize the display of different text scale
- Optimize windows setup experience
- Optimize startTun performance
- Optimize android tv experience
- Optimize default option
- Optimize computed text size
- Optimize hyperOS freeform window
- Add developer mode
- Update core
- Optimize more details
- Add issues template
- Update changelog

## v0.8.82 (2025-04-18)

- Optimize android vpn performance
- Add custom primary color and color scheme
- Add linux nad windows arm release
- Optimize requests and logs page
- Fix map input page delete issues
- Update changelog

## v0.8.81 (2025-04-08)

- Add rule override
- Update core
- Optimize more details
- Update changelog

## v0.8.80 (2025-03-10)

- Optimize dashboard performance
- Fix some issues
- Fix unselected proxy group delay issues
- Fix asn url issues
- Update changelog

## v0.8.79 (2025-03-07)

- Fix tab delay view issues
- Fix tray action issues
- Fix get profile redirect client ua issues
- Fix proxy card delay view issues
- Add Russian, Japanese adaptation
- Fix some issues
- Update changelog

## v0.8.78 (2025-03-05)

- Fix list form input view issues
- Fix traffic view issues
- Update changelog

## v0.8.77 (2025-03-05)

- Optimize performance
- Update core
- Optimize core stability
- Fix linux tun authority check error
- Fix some issues
- Fix scroll physics error
- Update changelog

## v0.8.75 (2025-02-09)

- Add windows storage corruption detection
- Fix core crash caused by windows resource manager restart
- Optimize logs, requests, access to pages
- Fix macos bypass domain issues
- Update changelog

## v0.8.74 (2025-02-03)

- Fix some issues
- Update changelog

## v0.8.73 (2025-02-02)

- Update popup menu
- Add file editor
- Fix android service issues
- Optimize desktop background performance
- Optimize android main process performance
- Optimize delay test
- Optimize vpn protect
- Update changelog

## v0.8.72 (2025-01-10)

- Update core
- Fix some issues
- Update changelog

## v0.8.71 (2025-01-09)

- Remake dashboard
- Optimize theme
- Optimize more details
- Update flutter version
- Update changelog

## v0.8.70 (2024-12-09)

- Support better window position memory
- Add windows arm64 and linux arm64 build script
- Optimize some details

## v0.8.69 (2024-12-06)

- Remake desktop
- Optimize change proxy
- Optimize network check
- Fix fallback issues
- Optimize lots of details
- Update change.yaml
- Fix android tile issues
- Fix windows tray issues
- Support setting bypassDomain
- Update flutter version
- Fix android service issues
- Fix macos dock exit button issues
- Add route address setting
- Optimize provider view
- Update changelog
- Update CHANGELOG.md

## v0.8.67 (2024-11-09)

- Add android shortcuts
- Fix init params issues
- Fix dynamic color issues
- Optimize navigator animate
- Optimize window init
- Optimize fab
- Optimize save

## v0.8.66 (2024-10-26)

- Fix the collapse issues
- Add fontFamily options

## v0.8.65 (2024-10-26)

- Update core version
- Update flutter version
- Optimize ip check
- Optimize url-test

## v0.8.64 (2024-10-12)

- Update release message
- Init auto gen changelog
- Fix windows tray issues
- Fix urltest issues
- Add auto changelog
- Fix windows admin auto launch issues
- Add android vpn options
- Support proxies icon configuration
- Optimize android immersion display
- Fix some issues
- Optimize ip detection
- Support android vpn ipv6 inbound switch
- Support log export
- Optimize more details
- Fix android system dns issues
- Optimize dns default option
- Fix some issues
- Update readme

## v0.8.60 (2024-09-17)

- Fix build error2
- Fix build error
- Support desktop hotkey
- Support android ipv6 inbound
- Support android system dns
- fix some bugs

## v0.8.59 (2024-09-09)

- Fix delete profile error

## v0.8.58 (2024-09-08)

- Fix submit error 2
- Fix submit error
- Optimize DNS strategy
- Fix the problem that the tray is not displayed in some cases
- Optimize tray
- Update core
- Fix some error

## v0.8.57 (2024-09-02)

- Fix tun update issues
- Add DNS override
- Fixed some bugs
- Optimize more detail
- Add Hosts override

## v0.8.56 (2024-08-26)

- fix android tip error
- fix windows auto launch error

## v0.8.55 (2024-08-25)

- Fix windows tray issues
- Optimize windows logic
- Optimize app logic
- Support windows administrator auto launch
- Support android close vpn

## v0.8.53 (2024-08-15)

- Change flutter version
- Support profiles sort
- Support windows country flags display
- Optimize proxies page and profiles page columns

## v0.8.52 (2024-08-11)

- Update flutter version
- Update version
- Update timeout time
- Update access control page
- Fix bug

## v0.8.51 (2024-08-05)

- Optimize provider page
- Optimize delay test
- Support local backup and recovery
- Fix android tile service issues

## v0.8.49 (2024-07-31)

- Fix linux core build error
- Add proxy-only traffic statistics
- Update core
- Optimize more details
- Merge pull request #140 from txyyh/main
- 添加自建 F-Droid 仓库相关 workflow
- Rename readme fingerprint
- Rename workflow deploy repo name
- Add download guide to README
- Add push release files to fdroid-repo

## v0.8.48 (2024-07-25)

- Optimize proxies page
- Fix ua issues
- Optimize more details

## v0.8.47 (2024-07-22)

- Fix windows build error

## v0.8.46 (2024-07-22)

- Update app icon
- Fix desktop backup error
- Optimize request ua
- Change android icon
- Optimize dashboard

## v0.8.44 (2024-07-18)

- Remove request validate certificate
- Sync core

## v0.8.43 (2024-07-18)

- Fix windows error

## v0.8.42 (2024-07-18)

- Fix setup.dart error
- Fix android system proxy not effective
- Add macos arm64

## v0.8.41 (2024-07-17)

- Optimize proxies page
- Support mouse drag scroll
- Adjust desktop ui
- Revert "Fix android vpn issues"
- This reverts commit 891977408e6938e2acd74e9b9adb959c48c79988.

## v0.8.40 (2024-07-15)

- Fix android vpn issues
- Fix android vpn issues
- Rollback partial modification

## v0.8.39 (2024-07-15)

- Fix the problem that ui can't be synchronized when android vpn is occupied by an external
- Override default socksPort,port

## v0.8.38 (2024-07-14)

- Fix fab issues

## v0.8.37 (2024-07-14)

- Update version
- Fix the problem that vpn cannot be started in some cases
- Fix the problem that geodata url does not take effect

## v0.8.36 (2024-07-13)

- Update ua
- Fix change outbound mode without check ip issues
- Separate android ui and vpn
- Fix url validate issues 2
- Add android hidden from the recent task
- Add geoip file
- Support modify geoData URL

## v0.8.35 (2024-07-07)

- Fix url validate issues
- Fix check ip performance problem
- Optimize resources page

## v0.8.34 (2024-07-04)

- Add ua selector
- Support modify test url
- Optimize android proxy
- Fix the error that async proxy provider could not selected the proxy

## v0.8.33 (2024-07-01)

- Fix android proxy error
- Fix submit error
- Add windows tun
- Optimize android proxy
- Optimize change profile
- Update application ua
- Optimize delay test

## v0.8.32 (2024-06-28)

- Fix android repeated request notification issues

## v0.8.31 (2024-06-28)

- Fix memory overflow issues

## v0.8.30 (2024-06-27)

- Optimize proxies expansion panel 2
- Fix android scan qrcode error

## v0.8.29 (2024-06-27)

- Optimize proxies expansion panel
- Fix text error

## v0.8.28 (2024-06-26)

- Optimize proxy
- Optimize delayed sorting performance
- Add expansion panel proxies page
- Support to adjust the proxy card size
- Support to adjust proxies columns number
- Fix autoRun show issues
- Fix Android 10 issues
- Optimize ip show

## v0.8.26 (2024-06-22)

- Add intranet IP display
- Add connections page
- Add search in connections, requests
- Add keyword search in connections, requests, logs
- Add basic viewing editing capabilities
- Optimize update profile

## v0.8.25 (2024-06-19)

- Update version
- Fix the problem of excessive memory usage in traffic usage.
- Add lightBlue theme color
- Fix start unable to update profile issues
- Fix flashback caused by process

## v0.8.23 (2024-06-16)

- Add build version
- Optimize quick start
- Update system default option

## v0.8.22 (2024-06-16)

- Update build.yml
- Fix android vpn close issues
- Add requests page
- Fix checkUpdate dark mode style error
- Fix quickStart error open app
- Add memory proxies tab index
- Support hidden group
- Optimize logs
- Fix externalController hot load error

## v0.8.21 (2024-06-13)

- Add tcp concurrent switch
- Add system proxy switch
- Add geodata loader switch
- Add external controller switch
- Add auto gc on trim memory
- Fix android notification error

## v0.8.20 (2024-06-12)

- Fix ipv6 error
- Fix android udp direct error
- Add ipv6 switch
- Add access all selected button
- Remove android low version splash

## v0.8.19 (2024-06-10)

- Update version
- Add allowBypass
- Fix Android only pick .text file issues

## v0.8.18 (2024-06-09)

- Fix search issues

## v0.8.17 (2024-06-09)

- Fix LoadBalance, Relay load error
- Fix build.yml4
- Fix build.yml3
- Fix build.yml2
- Fix build.yml
- Add search function at access control
- Fix the issues with the profile add button to cover the edit button
- Adapt LoadBalance and Relay
- Add arm
- Fix android notification icon error

## v0.8.16 (2024-06-08)

- Add one-click update all profiles
- Add expire show

## v0.8.15 (2024-06-06)

- Temp remove tun mode
- Remove macos in workflow
- Change go version

## v0.8.14 (2024-06-06)

- Update Version
- Fix tun unable to open

## v0.8.13 (2024-06-06)

- Optimize delay test2
- Optimize delay test
- Add check ip
- add check ip request

## v0.8.12 (2024-06-06)

- Fix the problem that the download of remote resources failed after GeodataMode was turned on, which caused the
  application to flash back.
- Fix edit profile error
- Fix quickStart change proxy error
- Fix core version

## v0.8.10 (2024-06-05)

- Fix core version

## v0.8.9 (2024-06-05)

- Update file_picker
- Add resources page
- Optimize more detail
- Add access selected sorted
- Fix notification duplicate creation issue
- Fix AccessControl click issue

## v0.8.7 (2024-05-31)

- Fix Workflow
- Fix Linux unable to open
- Update README.md 3
- Create LICENSE
- Update README.md 2
- Update README.md
- Optimize workFlow

## v0.8.6 (2024-05-31)

- optimize checkUpdate

## v0.8.5 (2024-05-30)

- Fix submit error

## v0.8.4 (2024-05-30)

- add WebDAV
- add Auto check updates
- Optimize more details
- optimize delayTest

## v0.8.2 (2024-05-15)

- upgrade flutter version

## v0.8.1 (2024-05-15)

- Update kernel
- Add import profile via QR code image

## v0.8.0 (2024-05-11)

- Add compatibility mode and adapt clash scheme.

## v0.7.14 (2024-05-07)

- update Version
- Reconstruction application proxy logic

## v0.7.13 (2024-05-06)

- Fix Tab destroy error

## v0.7.12 (2024-05-06)

- Optimize repeat healthcheck

## v0.7.11 (2024-05-06)

- Optimize Direct mode ui

## v0.7.10 (2024-05-06)

- Optimize Healthcheck
- Remove proxies position animation, improve performance
- Add Telegram Link
- Update healthcheck policy
- New Check URLTest
- Fix the problem of invalid auto-selection

## v0.7.8 (2024-05-05)

- New Async UpdateConfig
- add changeProfileDebounce
- Update Workflow
- Fix ChangeProfile block
- Fix Release Message Error

## v0.7.7 (2024-05-04)

- Update Selector 2

## v0.7.6 (2024-05-04)

- Update Version
- Fix Proxies Select Error

## v0.7.5 (2024-05-03)

- Fix the problem that the proxy group is empty in global mode.
- Fix the problem that the proxy group is empty in global mode.

## v0.7.4 (2024-05-03)

- Add ProxyProvider2

## v0.7.3 (2024-05-03)

- Add ProxyProvider
- Update Version
- Update ProxyGroup Sort
- Fix Android quickStart VpnService some problems

## v0.7.1 (2024-05-01)

- Update version
- Set Android notification low importance
- Fix the issue that VpnService can't be closed correctly in special cases
- Fix the problem that TileService is not destroyed correctly in some cases
- Adjust tab animation defaults
- Add Telegram in README_zh_CN.md
- Add Telegram

## v0.7.0 (2024-04-30)

- update mobile_scanner
- Initial commit
