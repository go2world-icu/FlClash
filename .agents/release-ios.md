# iOS Release & TestFlight

iOS 发布到 TestFlight 的构建/签名管线。改动签名、CI、描述文件、构建号相关代码前先读这篇。

## 构建方式

iOS 编排位于 fork 自己的 `ios/scripts/build_ios.sh`：

```bash
bash ios/scripts/build_ios.sh verify --env pre
bash ios/scripts/build_ios.sh archive --env stable \
  --export-options-plist ExportOptions.plist \
  --build-number <递增的构建号>
```

两种模式复用现有核心构建器：

1. 在 `plugins/setup/setup_hooks/` 运行 `dart run bin/build_ios.dart`，生成 `libclash/ios/Mobile.xcframework`。
2. `verify` 运行 `flutter build ios --release --no-codesign`；`archive` 运行 `flutter build ipa --release`。
   - `--build-number` 直接覆盖 `CFBundleVersion`（Info.plist 引用 `$(FLUTTER_BUILD_NUMBER)`，flutter 的 flag 正确处理）。
   - TestFlight 构建号必须**严格递增**，否则上传被拒。

证书、描述文件安装和 TestFlight 上传由 workflow 或本地签名 wrapper 管理。`dart setup.dart ios ...`
仅保留兼容转发；新调用直接使用 shell，避免根 Dart 包先触发主机 native hooks。iOS 只能在 macOS 上构建。

## 本地运行（与 CI 一致）

本地签名脚本是 **`ios/scripts/ios_release.sh`**，负责安装证书和描述文件、生成 ExportOptions、调用 archive 模式并可选上传：

```bash
# 证书来源（二选一）
export IOS_CERT_P12_FILE=/path/to/your-cert.p12     # 或
export IOS_CERTIFICATE=<p12 的 base64>
export IOS_CERTIFICATE_PASSWORD=...

./ios/scripts/ios_release.sh                          # 打签名 ipa（--env stable）
./ios/scripts/ios_release.sh --build-number 2026080303 # 指定构建号
./ios/scripts/ios_release.sh --upload                   # 构建后上传 TestFlight
```

脚本调用 `bash ios/scripts/build_ios.sh archive --env stable ...`。`--upload` 还需 `ASC_KEY_ID` / `ASC_ISSUER_ID` / `ASC_API_KEY`。

要点：**构建号必须比 TestFlight 上已上传的大**（本地传之前先看一眼上次的号），否则上传被拒。

## CI 流水线（`.github/workflows/build-ios-fastlane.yaml`）

- pre tag 和手动运行只做无签名 Release 验证，保存 Actions artifact。
- 正式 `vX.Y.Z` tag push 才执行签名构建并上传 TestFlight。
- iOS 不附加 GitHub Release 文件、不触发镜像同步；TestFlight 只依赖 iOS 构建成功。
- Flutter、Go 和 CA bundle pin 从 `build.yaml` 读取；通用 build matrix 不再包含 iOS。

正式流程：

1. 环境：Go / Flutter / Xcode / Ruby + bundler。
2. `flutter precache --ios`、`pod install`。
3. **Setup Code Signing**：建 `build.keychain` 并放进搜索列表、导入 `IOS_CERTIFICATE` p12、`set-key-partition-list`、再 `unlock-keychain`；把仓库里两个描述文件按**内嵌 UUID** 装到两处：
   - `~/Library/MobileDevice/Provisioning Profiles/`（codesign/export 用）
   - `~/Library/Developer/Xcode/UserData/Provisioning Profiles/`（archive 的 GatherProvisioningInputs 用）
4. **Build & Export**：写 `ExportOptions.plist` → 解锁钥匙串 → `build_ios.sh archive`，产出
   `dist/ToWorld-<version>-ios-arm64.ipa`、SHA256 和来源 JSON。验证 Runner/PacketTunnel 的签名、VPN entitlement 和 App Group。
5. **保存 artifact**：发布前保存这份 IPA、来源 JSON 和 SHA256。
6. **fastlane 上传**：独立 job 校验已保存的 IPA 并上传 TestFlight。失败后只重试发布 job，避免重编译不同的签名字节。

COS 配置与首次 dry-run/staging 验证见 [`tool/distribution/README.md`](../tool/distribution/README.md)。
无签名验证产物仅保存在 CI；签名 IPA 保存在 Actions artifact 并上传 TestFlight，不上传 COS 或 GitHub Release。

## 关键非显然约束

- **不要用 fastlane gym（`build_app`）**：它会把 `CODE_SIGNING_ALLOWED=NO` 同时传给 export，导致 `xcodebuild -exportArchive` 卡死（几分钟到超时）。用 `flutter build ipa` 或原生 xcodebuild，fastlane 只上传。
- **archive 必须真签名**（不能 `CODE_SIGNING_ALLOWED=NO`）：entitlements（VPN 的 `networkextension`）在 codesign 阶段嵌入；跳过签名 → export 重新签名也不补 → 上传被 App Store 以 "Missing Entitlement" 拒。
- **`IOS_CERTIFICATE` p12 里有 4 把证书**（Apple Development ×2、Apple Distribution 指纹 `6186B637E95AF2B1D39B5F532413833B991D69CB`、旧 iPhone Distribution `EAB7C37A...`）。只有 **Apple Distribution** 与描述文件匹配。
- **sigh 在有多把证书时会建错（旧 iPhone Distribution）profile**：regen workflow 导入 p12 后先把其余证书从 keychain 删掉再让 sigh 重建。
- **有些 runner 的钥匙串授权是坏的，而且坏一整天（整个 job）**。这是 2026-10-16 查清的，之前的记录把它写成「间歇性」，那是误读。

  现象：`codesign` 卡在读私钥 ACL（`sample` 的栈永远停在 `SecCodeSigner::sign → … → CSSM_GetKeyAcl`），没人能点那个授权框，于是永久挂起。**同一台机器上，`canary` 一上来就挂，之后每一次签名都挂**——所以「同一个 job 里重试」毫无意义，只会把二十分钟一轮的失败重复三遍（实测三次尝试各烧满上限）。

  证据链：同一个 runner 镜像（`macos-26-arm64` / `20260907.0351.1`）、同一个 Xcode 26.3，成功与失败都出现过——**所以不是 Xcode 升级、不是镜像滚动、也不是应用代码**；成功/失败是**好机器与坏机器的区别**。

  **`canary` 就是体检**：构建前用同一个身份签一个 1 字节文件，**限时 20 秒**。它挂了就说明这台机器不可用，立刻退出（约 40 秒），重新派发去换一台——**别在这里重试**。这是目前唯一正确的应对。

  仍要保证的钥匙串状态（都对，但不足以治好坏机器）：

  ```bash
  security list-keychains -d user -s build.keychain      # 进搜索列表
  security import cert.p12 -k build.keychain -P "$PW" -A # -A：任何程序可用，不留按应用的 ACL
  security unlock-keychain -p "$PW" build.keychain       # import 之后再解锁一次
  security set-keychain-settings -lut 21600 build.keychain  # 默认 5 分钟不用就上锁
  ```

  构建前再 `unlock-keychain` + `default-keychain`，并 `find-identity -v -p codesigning build.keychain` 打出来。
- **看门狗盯的是「卡住的 codesign」本身，不是「这一步跑了多久」**。按整步超时写是错的：canary 挂死、被杀之后构建才刚开始，那时看门狗已经用掉了。判据是**同一个 pid 跨过一个采样周期还在**——正常签名不到一秒，跨周期就是死。

  **别用 `ps -o etimes`**：macOS 的 BSD ps 没有这个字段，取值为空 → 跳过分支永远命中 → 看门狗静默失效，job 一路挂到 60 分钟。这个 bug 在开发机（GNU ps）上测不出来。同理别在 runner 上用 `local`：那里是 bash 3.2。

## 描述文件（提交在仓库）

- `ios/ToWorld.mobileprovision` —— 主 App `uk.toworld.clash`，UUID `f3102d11-8212-4bab-8328-a9ff3cf965d3`
- `ios/ToWorldPacketTunnel.mobileprovision` —— 扩展 `uk.toworld.clash.PacketTunnel`，UUID `92c366cf-96f5-4a06-a67e-c0ea88e8141a`

`ios/Runner.xcodeproj/project.pbxproj` 的 Runner/PacketTunnel **Release 配置是 Manual 签名**：`CODE_SIGN_STYLE = Manual` + `PROVISIONING_PROFILE_SPECIFIER` = 上面两个 UUID。**profile 重建后 UUID 会变**，pbxproj 的 specifier 必须同步（regen workflow 按每个 Release buildSettings 块里的 `PRODUCT_BUNDLE_IDENTIFIER` 自动改，不依赖文件顺序）。

## 重建描述文件（`.github/workflows/regen-ios-profiles.yaml`）

证书/描述文件过期或不匹配时跑一次。**必须跑 macOS**（sigh 装 profile 需要 Xcode）。流程：导入 p12 → 删掉非 Apple Distribution 证书 → `sigh force: true` 重建两个 profile → 校验证书是 Apple Distribution → 重命名提交 + 用 awk 同步 pbxproj specifier。

## Secrets

- iOS：`ASC_API_KEY`（p8 原文，非 base64）、`ASC_KEY_ID`、`ASC_ISSUER_ID`、`IOS_CERTIFICATE`（p12 base64）、`IOS_CERTIFICATE_PASSWORD`
- checkout/发布：`BOARD_SDK_PAT`、`FLCLASH_AND_PUBLISH_PAT`

Gitee/GitCode release 同步在独立 workflow `sync-gitee-gitcode.yaml`（手动触发），与 iOS 无关。

## 相关 workflow

- `build-ios-fastlane.yaml` —— TestFlight 发布
- `regen-ios-profiles.yaml` —— 重建描述文件 + 同步 pbxproj
- `build.yaml` —— 其他平台打包（`dart setup.dart <platform>`）+ release
