#!/usr/bin/env bash
set -euo pipefail

# This script is invoked by the CocoaPods script build phase.
# It forwards Xcode build environment to the build_tool and runs it.

# Xcode strips PATH to a minimal set. Restore common tool locations.
export PATH="/opt/homebrew/bin:/usr/local/bin:${HOME}/fvm/default/bin:${HOME}/.pub-cache/bin:${PATH}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Resolve the repo root:
# - CocoaPods script phase (macOS): PODS_ROOT=<root>/macos/Pods
# - Direct target phase (iOS PacketTunnel): SRCROOT=<root>/ios
if [ -n "${PODS_ROOT:-}" ]; then
  PROJECT_DIR="$(cd "$PODS_ROOT/../.." && pwd)"
elif [ -n "${SRCROOT:-}" ]; then
  PROJECT_DIR="$(cd "$SRCROOT/.." && pwd)"
else
  PROJECT_DIR="$(cd "$PWD/../.." && pwd)"
fi

# Source the Flutter export environment (PATH etc.) generated per platform.
case "${PLATFORM_NAME:-macosx}" in
  iphoneos|iphonesimulator)
    FLUTTER_EXPORT_BUILD_ENVIRONMENT="${PROJECT_DIR}/ios/Flutter/ephemeral/flutter_export_environment.sh"
    ;;
  *)
    FLUTTER_EXPORT_BUILD_ENVIRONMENT="${PROJECT_DIR}/macos/Flutter/ephemeral/flutter_export_environment.sh"
    ;;
esac
if [ -f "$FLUTTER_EXPORT_BUILD_ENVIRONMENT" ]; then
  # shellcheck disable=SC1090
  source "$FLUTTER_EXPORT_BUILD_ENVIRONMENT"
fi

# Forward CocoaPods/Xcode environment to variables the build_tool expects.
export BUILDKIT_CONFIGURATION="${CONFIGURATION:-Release}"
export PROJECT_DIR

if [ -z "${APP_ENV:-}" ]; then
  export APP_ENV="pre"
fi

build_args=(macos)
case "${PLATFORM_NAME:-macosx}" in
  iphoneos|iphonesimulator)
    build_args=(ios --sdk "${PLATFORM_NAME}")
    ;;
  *)
    case "${ARCHS:-}" in
      arm64)
        build_args+=(--arch arm64)
        ;;
      x86_64)
        build_args+=(--arch amd64)
        ;;
    esac
    ;;
esac

"$SCRIPT_DIR/run_build_tool.sh" "${build_args[@]}"

# Match Cargokit's phony input strategy so CocoaPods invokes the build tool on
# every native build and lets setup's fingerprint cache decide what to compile.
ln -fs "$OBJROOT/XCBuildData/build.db" "${BUILT_PRODUCTS_DIR}/buildkit_phony"
ln -fs "${BUILT_PRODUCTS_DIR}/${EXECUTABLE_PATH}" "${BUILT_PRODUCTS_DIR}/buildkit_phony_out"
