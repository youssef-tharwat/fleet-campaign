#!/usr/bin/env bash
# Hermetic, seconds-long checks in a supplied durable empty directory; no network.
set -euo pipefail
test_root=${1:?pass an existing empty durable test directory outside a real checkout}
[[ -d $test_root && -z $(ls -A "$test_root") ]] || exit 64
test_root=$(cd "$test_root" && pwd -P)
case $test_root in /|/tmp|/tmp/*|/private/tmp|/private/tmp/*) exit 64;; esac
collector=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/collect-changes.sh
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null
export GIT_CONFIG_NOSYSTEM=1 GIT_TEMPLATE_DIR="" GIT_ATTR_NOSYSTEM=1
mkdir "$test_root/repo" "$test_root/output"
cd "$test_root/repo"
git init -q -b main
git config user.name 'Skill Fixture'
git config user.email 'skill-fixture@example.invalid'
git config core.hooksPath /dev/null
git config commit.gpgsign false
collect() { bash "$collector" --output-dir "$test_root/output" "$@"; }
printf 'first\n' > 'tracked file.txt'
git add -- 'tracked file.txt'
collect staged > "$test_root/unborn-staged.txt"
grep -q 'files: 1' "$test_root/unborn-staged.txt"
collect working > "$test_root/unborn-working.txt"
grep -q 'files: 1' "$test_root/unborn-working.txt"
git commit -qm root
root_commit=$(git rev-parse HEAD)
collect commit "$root_commit" > "$test_root/root.txt"
grep -q 'files: 1' "$test_root/root.txt"
collect working > "$test_root/clean.txt"
grep -q 'No changes to review' "$test_root/clean.txt"
touch 'empty untracked.txt'
collect working > "$test_root/empty-untracked.txt"
grep -q 'files: 1' "$test_root/empty-untracked.txt"
grep -q 'empty untracked.txt' "$test_root/output"/review-pass.*/changes.diff
rm 'empty untracked.txt'
printf 'second\n' >> 'tracked file.txt'
git add -- 'tracked file.txt'
printf 'third\n' >> 'tracked file.txt'
printf 'untracked\n' > 'new file.txt'
index_before=$(git hash-object .git/index)
collect working > "$test_root/working.txt"
collect staged > "$test_root/staged.txt"
[[ $(git hash-object .git/index) == "$index_before" && $(git rev-parse HEAD) == "$root_commit" ]]
grep -q 'files: 2' "$test_root/working.txt"
grep -q 'files: 1' "$test_root/staged.txt"
git add -- 'tracked file.txt' 'new file.txt'
git commit -qm changes
change_commit=$(git rev-parse HEAD)
collect commit "$change_commit" > "$test_root/commit.txt"
grep -q 'files: 2' "$test_root/commit.txt"
git checkout -qb other "$root_commit"
printf 'other branch\n' > other.txt
git add -- other.txt
git commit -qm other
collect range "HEAD..$change_commit" > "$test_root/range.txt"
grep -q "base: $root_commit" "$test_root/range.txt"
if collect commit not-a-ref > "$test_root/bad-ref.txt" 2>&1; then exit 1; fi
git merge --no-ff -qm merged "$change_commit"
if collect commit HEAD > "$test_root/merge-ambiguous.txt" 2>&1; then exit 1; fi
if bash "$collector" --output-dir "$test_root/repo" working > "$test_root/unignored-output.txt" 2>&1; then exit 1; fi
mkdir "$test_root/repo/nested"
(
  cd "$test_root/repo/nested"
  bash "$collector" --output-dir ../../output working
) > "$test_root/relative-output.txt"
grep -Fq "DIFF_FILE=$test_root/output/" "$test_root/relative-output.txt"
printf 'PASS: unborn staged/working, root, clean, empty untracked, dirty+untracked, staged, index/HEAD preservation, commit, diverged merge-base, bad ref, merge ambiguity, output isolation, relative output from a nested directory\n'
