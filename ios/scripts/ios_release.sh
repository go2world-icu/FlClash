#!/usr/bin/env bash
# 本地 macOS 上跑出与 CI（build-ios-fastlane）完全一致的 iOS 签名 ipa + 可选上传 TestFlight。
#
# 用法:
#   ./ios/scripts/ios_release.sh                          # 打签名 ipa（默认 --env stable）
#   ./ios/scripts/ios_release.sh --build-number 2026080303 # 指定构建号（TestFlight 必须递增）
#   ./ios/scripts/ios_release.sh --upload                   # 构建后上传 TestFlight
#
# 证书来源（二选一，也可都设）:
#   IOS_CERT_P12_FILE=<本地 p12 路径>        # 推荐：本地直接给 p12 文件
#   IOS_CERTIFICATE=<p12 的 base64>         # 等价于 CI 的 IOS_CERTIFICATE secret
#   IOS_CERTIFICATE_PASSWORD=<密码>          # 必需
#
# 上传时需要（等价于 CI secrets）:
#   ASC_KEY_ID ASC_ISSUER_ID ASC_API_KEY     # API key 的 p8 原文
#
# 前提: 仓库已 checkout 子模块、已装 Flutter/Xcode/Go/CocoaPods。

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

ENV="stable"
BUILD_NUMBER=""
DO_UPLOAD=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --build-number) BUILD_NUMBER="$2"; shift 2 ;;
    --env) ENV="$2"; shift 2 ;;
    --upload) DO_UPLOAD=1; shift ;;
    *) echo "未知参数: $1"; exit 1 ;;
  esac
done

# bundle id / App Group 单一数据源 = Xcode 工程。Xcode 里改完，这里自动跟随。
APP_ID=$(xcodebuild -showBuildSettings -project ios/Runner.xcodeproj -target Runner -sdk iphoneos -configuration Release 2>/dev/null | awk -F' = ' '$1 ~ /^[[:space:]]*PRODUCT_BUNDLE_IDENTIFIER$/ {print $2; exit}')
PKT_ID=$(xcodebuild -showBuildSettings -project ios/Runner.xcodeproj -target PacketTunnel -sdk iphoneos -configuration Release 2>/dev/null | awk -F' = ' '$1 ~ /^[[:space:]]*PRODUCT_BUNDLE_IDENTIFIER$/ {print $2; exit}')
GROUP_APP=$(/usr/libexec/PlistBuddy -c 'Print :com.apple.security.application-groups:0' ios/Runner/Runner.entitlements)
GROUP_PKT=$(/usr/libexec/PlistBuddy -c 'Print :com.apple.security.application-groups:0' ios/PacketTunnel/PacketTunnel.entitlements)
[ -n "$APP_ID" ] && [ -n "$PKT_ID" ] || { echo "ERROR: 解析 bundle id 失败" >&2; exit 1; }
[ "$GROUP_APP" = "$GROUP_PKT" ] || { echo "ERROR: 主 App 与 PacketTunnel 的 App Group 不一致: $GROUP_APP vs $GROUP_PKT" >&2; exit 1; }
echo "[ids] APP_ID=$APP_ID PKT_ID=$PKT_ID GROUP=$GROUP_APP"

echo "==> 1/5 证书到登录钥匙串"
: "${IOS_CERTIFICATE_PASSWORD:?需要 IOS_CERTIFICATE_PASSWORD}"
if [ -n "${IOS_CERT_P12_FILE:-}" ]; then
  P12="$IOS_CERT_P12_FILE"
elif [ -n "${IOS_CERTIFICATE:-}" ]; then
  echo "$IOS_CERTIFICATE" | base64 --decode > /tmp/ios-cert.p12
  P12=/tmp/ios-cert.p12
else
  echo "ERROR: 需要 IOS_CERT_P12_FILE 或 IOS_CERTIFICATE" >&2; exit 1
fi
if security import "$P12" -k ~/Library/Keychains/login.keychain-db \
     -P "$IOS_CERTIFICATE_PASSWORD" -T /usr/bin/codesign >/dev/null 2>&1; then
  echo "[signing] cert imported"
else
  echo "[signing] import 返回非零（可能已存在），校验钥匙串里的 Apple Distribution 证书..."
  security find-identity -v -p codesigning | grep -qi 'Apple Distribution' \
    || { echo "ERROR: 钥匙串里没有 Apple Distribution 证书" >&2; exit 1; }
fi

echo "==> 2/5 安装描述文件（仓库内已提交，按内嵌 UUID 装到两处）"
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
mkdir -p ~/Library/Developer/Xcode/UserData/Provisioning\ Profiles
MAIN_UUID=""
PKT_UUID=""
for p in ios/ToWorld.mobileprovision ios/ToWorldPacketTunnel.mobileprovision; do
  uuid=$(grep -a -A1 '<key>UUID</key>' "$p" | grep -a '<string>' | sed 's/.*<string>//;s/<\/string>.*//')
  cp "$p" ~/Library/MobileDevice/Provisioning\ Profiles/${uuid}.mobileprovision
  cp "$p" ~/Library/Developer/Xcode/UserData/Provisioning\ Profiles/${uuid}.mobileprovision
  if [ "$p" = "ios/ToWorld.mobileprovision" ]; then MAIN_UUID="$uuid"; else PKT_UUID="$uuid"; fi
done
echo "[signing] profiles installed (main=$MAIN_UUID pkt=$PKT_UUID)"

echo "==> 3/5 生成 ExportOptions.plist（manual 签名 + profile UUID）"
cat > ExportOptions.plist <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>9ZKNBU3VL4</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>${APP_ID}</key>
        <string>${MAIN_UUID}</string>
        <key>${PKT_ID}</key>
        <string>${PKT_UUID}</string>
    </dict>
</dict>
</plist>
PLIST

echo "==> 4/5 构建（与 CI 相同入口）"
BN_ARGS=""
if [ -n "$BUILD_NUMBER" ]; then
  BN_ARGS="--build-number=$BUILD_NUMBER"
fi
dart setup.dart ios --env "$ENV" --export-options-plist ExportOptions.plist $BN_ARGS -v

echo "==> 5/5 产物"
IPA=$(ls -t build/ios/ipa/*.ipa 2>/dev/null | head -1)
if [ -z "$IPA" ]; then echo "ERROR: 没找到 build/ios/ipa/*.ipa" >&2; exit 1; fi
echo "ipa: $IPA"
echo "  version: $(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$(dirname "$IPA")/../Runner.app/Info.plist" 2>/dev/null || echo '?')"

if [ "$DO_UPLOAD" = "1" ]; then
  echo "==> 上传 TestFlight"
  : "${ASC_KEY_ID:?需要 ASC_KEY_ID}" "${ASC_ISSUER_ID:?需要 ASC_ISSUER_ID}" "${ASC_API_KEY:?需要 ASC_API_KEY}"
  cp "$IPA" dist/ToWorld-ios-arm64.ipa 2>/dev/null || { mkdir -p dist; cp "$IPA" dist/ToWorld-ios-arm64.ipa; }
  bundle exec fastlane deploy_testflight
fi

echo "done."
