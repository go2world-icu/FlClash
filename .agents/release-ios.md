# iOS Release & TestFlight

iOS 发布到 TestFlight 的构建/签名管线。改动签名、CI、描述文件、构建号相关代码前先读这篇。

## 构建方式

iOS 已统一进 `setup.dart`（所有平台统一入口）：

```bash
dart setup.dart ios --env stable \
  --export-options-plist ExportOptions.plist \
  --build-number <递增的构建号>
```

`setup.dart` 的 iOS 分支做两件事：

1. `make core-ios` —— 编 Go core（产出 `libclash/ios/Libclash.xcframework`，Xcode 嵌入用）。
2. `flutter build ipa --release --dart-define-from-file=env.json [--build-number N] [--export-options-plist <path>]`。
   - `--build-number` 直接覆盖 `CFBundleVersion`（Info.plist 引用 `$(FLUTTER_BUILD_NUMBER)`，flutter 的 flag 正确处理）。
   - TestFlight 构建号必须**严格递增**，否则上传被拒。

`setup.dart` 只负责编译/打包；**证书、描述文件的安装**和 **TestFlight 上传**在 CI workflow 里单独做，不归它管。iOS 只能在 macOS 上编译（签名依赖 Xcode）。

## 本地运行（与 CI 一致）

本地跑 `dart setup.dart ios` 前，需要手动复刻 CI 的 Setup Code Signing 那几步。封装好的脚本在 **`ios/scripts/ios_release.sh`**（把签名前置 + ExportOptions.plist + 构建 + 可选上传做成一条命令，与 CI 逻辑一致）：

```bash
# 证书来源（二选一）
export IOS_CERT_P12_FILE=/path/to/your-cert.p12     # 或
export IOS_CERTIFICATE=<p12 的 base64>
export IOS_CERTIFICATE_PASSWORD=...

./ios/scripts/ios_release.sh                          # 打签名 ipa（--env stable）
./ios/scripts/ios_release.sh --build-number 2026080303 # 指定构建号
./ios/scripts/ios_release.sh --upload                   # 构建后上传 TestFlight
```

脚本做的事 = CI 的 Setup Code Signing + Build & Export：证书进登录钥匙串 → 描述文件按 UUID 装两处 → 生成 ExportOptions.plist → `dart setup.dart ios --env stable ...`。`--upload` 还需 `ASC_KEY_ID` / `ASC_ISSUER_ID` / `ASC_API_KEY`。

要点：**构建号必须比 TestFlight 上已上传的大**（本地传之前先看一眼上次的号），否则上传被拒。

## CI 流水线（`.github/workflows/build-ios-fastlane.yaml`）

1. 环境：Go / Flutter / Xcode / Ruby + bundler。
2. `flutter precache --ios`、`pod install`。
3. **Setup Code Signing**：建 `build.keychain`、导入 `IOS_CERTIFICATE` p12、把仓库里两个描述文件按**内嵌 UUID** 装到两处：
   - `~/Library/MobileDevice/Provisioning Profiles/`（codesign/export 用）
   - `~/Library/Developer/Xcode/UserData/Provisioning Profiles/`（archive 的 GatherProvisioningInputs 用）
4. **Build & Export**：写 `ExportOptions.plist`（manual 签名 + profile UUID）→ `dart setup.dart ios ...` → 产出 `dist/ToWorld-ios-arm64.ipa`。
5. **fastlane 上传**：`bundle exec fastlane deploy_testflight`（只上传，不做构建）。

## 关键非显然约束

- **不要用 fastlane gym（`build_app`）**：它会把 `CODE_SIGNING_ALLOWED=NO` 同时传给 export，导致 `xcodebuild -exportArchive` 卡死（几分钟到超时）。用 `flutter build ipa` 或原生 xcodebuild，fastlane 只上传。
- **archive 必须真签名**（不能 `CODE_SIGNING_ALLOWED=NO`）：entitlements（VPN 的 `networkextension`）在 codesign 阶段嵌入；跳过签名 → export 重新签名也不补 → 上传被 App Store 以 "Missing Entitlement" 拒。
- **`IOS_CERTIFICATE` p12 里有 4 把证书**（Apple Development ×2、Apple Distribution 指纹 `6186B637E95AF2B1D39B5F532413833B991D69CB`、旧 iPhone Distribution `EAB7C37A...`）。只有 **Apple Distribution** 与描述文件匹配。
- **sigh 在有多把证书时会建错（旧 iPhone Distribution）profile**：regen workflow 导入 p12 后先把其余证书从 keychain 删掉再让 sigh 重建。

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
