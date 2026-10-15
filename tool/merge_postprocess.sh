#!/usr/bin/env bash
# Post-merge steps for syncing with upstream. Idempotent: running it twice on a
# clean tree leaves the second run with nothing to do.
#
# The manual equivalent is in .agents/merge-upstream.md, which also covers the
# parts that cannot be scripted (branding, CI, the upstream-test value fixes).
set -euo pipefail

cd "$(dirname "$0")/.."

step() { echo "==> $1"; }

step 'submodules'
git submodule update --init --recursive

# The fork's xboard keys land in upstream's arb files, so a merge conflicts on
# the whole key block. Union them instead of hand-merging the JSON: upstream's
# side wins (it carries their reworded values and deletions), and the fork's
# keys are appended. `:2:` is ours, `:3:` is theirs.
step 'arb union'
for arb in arb/intl_*.arb; do
  grep -q '^<<<<<<<' "$arb" || continue
  git show ":2:$arb" > /tmp/fork_arb_ours.json
  git show ":3:$arb" > /tmp/fork_arb_theirs.json
  jq -n --indent 2 \
    --slurpfile theirs /tmp/fork_arb_theirs.json \
    --slurpfile ours /tmp/fork_arb_ours.json \
    '$theirs[0] + ($ours[0] | with_entries(select(.key as $k | ($theirs[0] | has($k)) | not)))' \
    > "$arb"
  echo "    unioned $arb"
done

step 'l10n generation'
dart run intl_utils:generate

step 'build_runner'
dart run build_runner build --delete-conflicting-outputs

step 'dart format'
dart format lib test tool plugins setup.dart

step 'fork invariants'
flutter test test/lint/fork_invariants_test.dart

echo
echo 'Done. Still manual, see .agents/merge-upstream.md:'
echo '  - re-apply the branding and the CI delta'
echo '  - fix the upstream tests that assert upstream values'
