#!/usr/bin/env bash
# Post-merge steps for syncing with upstream. Idempotent: running it twice on a
# clean tree leaves the second run with nothing to do.
#
# The manual equivalent is in .agents/merge-upstream.md, which also covers the
# parts that cannot be scripted (branding, CI, the upstream-test value fixes).
set -euo pipefail

cd "$(dirname "$0")/.."

step() { echo "==> $1"; }

step 'merge resolution'
unmerged=$(git diff --name-only --diff-filter=U)
if [[ -n "$unmerged" ]]; then
  echo 'Resolve and stage merge conflicts before regeneration:' >&2
  echo "$unmerged" >&2
  exit 1
fi

step 'submodules'
git submodule update --init --recursive

step 'dependencies'
flutter pub get

step 'l10n generation'
dart run intl_utils:generate

step 'build_runner'
dart run build_runner build

step 'dart format'
dart format lib test tool plugins setup.dart

step 'fork invariants'
flutter test test/lint/fork_invariants_test.dart

echo
echo 'Done. Still manual, see .agents/merge-upstream.md:'
echo '  - re-apply the branding and the CI delta'
echo '  - fix the upstream tests that assert upstream values'
echo '  - review changed page sources before updating tool/fork_sources.json'
