#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../.." && pwd)"
usage() {
  echo 'Usage: build_ios.sh <verify|archive> [--env dev|pre|stable] [--build-number N] [--export-options-plist FILE] [-v] [--dry-run]'
}
mode="${1:-}"
if [[ "$mode" == '--help' || "$mode" == '-h' ]]; then
  usage
  exit 0
fi
[[ "$mode" == verify || "$mode" == archive ]] || { echo 'Expected verify or archive' >&2; exit 64; }
shift
app_env=pre
build_args=()
record_args=()
dry_run=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --env) [[ $# -ge 2 ]] || exit 64; app_env="$2"; shift 2 ;;
    --env=*) app_env="${1#*=}"; shift ;;
    --build-number|--export-options-plist)
      [[ $# -ge 2 && -n "$2" ]] || exit 64
      [[ "$1" != --export-options-plist ]] || record_args+=("--export-options-plist=$2")
      build_args+=("$1=$2"); shift 2 ;;
    --build-number=*) build_args+=("$1"); shift ;;
    --export-options-plist=*) record_args+=("$1"); build_args+=("$1"); shift ;;
    -v|--verbose) build_args+=(--verbose); shift ;;
    --dry-run) dry_run=true; shift ;;
    *) echo "Unknown argument: $1" >&2; exit 64 ;;
  esac
done
case "$app_env" in dev|pre|stable) ;; *) echo 'Invalid application environment' >&2; exit 64 ;; esac
flutter_args=(build ios --release --no-codesign)
[[ "$mode" != archive ]] || flutter_args=(build ipa --release)
flutter_args+=(--dart-define-from-file=env.json ${build_args[@]+"${build_args[@]}"})
if "$dry_run"; then
  printf 'Core: dart run bin/build_ios.dart --root %q\n' "$repo_root"
  printf 'APP_ENV=%s flutter' "$app_env"
  printf ' %q' "${flutter_args[@]}"
  printf '\n'
  exit 0
fi
[[ "$(uname -s)" == Darwin ]] || { echo 'iOS builds require macOS' >&2; exit 1; }
cd "$repo_root"
python3 - "$app_env" <<'PY'
import json
import re
import sys
from pathlib import Path

if re.search(r'^\s+build_assets:\s*false\b', Path('pubspec.yaml').read_text(), re.M):
    raise SystemExit('Restore build_assets: true before building iOS')
Path('env.json').write_text(json.dumps({'APP_ENV': sys.argv[1]}) + '\n')
PY
(
  cd plugins/setup/setup_hooks
  dart pub get
  dart run bin/build_ios.dart --root "$repo_root"
)
flutter "${flutter_args[@]}"
python3 tool/distribution/release_tools.py record-ios --mode "$mode" ${record_args[@]+"${record_args[@]}"}
