#!/usr/bin/env bash
# Read-only Git snapshot; writes only to an explicitly approved artifact parent.
set -euo pipefail
export GIT_OPTIONAL_LOCKS=0
die() { printf 'code-review-pass: %s\n' "$1" >&2; exit "${2:-1}"; }
[[ ${1:-} == --output-dir && -n ${2:-} ]] || die 'usage: collect-changes.sh --output-dir <existing-durable-directory> [working|staged|commit <sha>|range <base>..<head>|pr <number-or-url>]' 64
output_parent=$2
shift 2
command -v git >/dev/null || die 'git is required' 2
repo=$(git rev-parse --show-toplevel) || die 'not inside a Git working tree' 2
[[ -d $output_parent ]] || die 'create the approved artifact parent first' 64
output_parent=$(cd -- "$output_parent" && pwd -P)
cd "$repo"
case $output_parent in /|/tmp|/tmp/*|/private/tmp|/private/tmp/*) die 'choose a durable, scoped artifact directory' 64;; esac
case $output_parent/ in
  "$repo/"*) git check-ignore -q -- "$output_parent/" || die 'artifact parent inside the repository must already be ignored; no ignore rules were changed' 64;;
esac
mode=${1:-working}
case $mode in
  working|uncommitted|staged) [[ $# -le 1 ]] || die 'unexpected extra arguments' 64;;
  commit|range|pr) [[ $# == 2 && -n $2 ]] || die 'target mode requires exactly one argument' 64;;
  *) die 'unknown mode; use working, staged, commit, range or pr' 64;;
esac
[[ $mode != uncommitted ]] || mode=working
run_dir=$(mktemp -d "$output_parent/review-pass.XXXXXX")
diff_file=$run_dir/changes.diff
manifest=$run_dir/manifest.txt
base_ref=''
head_ref=''
resolve_commit() { git rev-parse --verify --end-of-options "$1^{commit}"; }
diff_args=(--no-ext-diff --no-textconv --no-color --binary)
git status --porcelain=v1 -z --untracked-files=all > "$run_dir/status-before.z"
git rev-parse --verify -q HEAD > "$run_dir/checkout-head.txt" || true

case $mode in
  pr)
    command -v gh >/dev/null || die 'gh is needed for GitHub PR targets; use a local range or the host provider tools otherwise' 3
    pr=$2
    [[ $pr != -* ]] || die 'invalid PR target' 64
    pr_before=$(gh pr view "$pr" --json baseRefOid,headRefOid,url --jq '[.baseRefOid,.headRefOid,.url]|@tsv') || die 'failed to resolve PR identity' 3
    IFS=$'\t' read -r base_ref head_ref pr_url <<< "$pr_before"
    [[ $base_ref =~ ^[0-9a-f]{40,64}$ && $head_ref =~ ^[0-9a-f]{40,64}$ ]] || die 'PR did not return full commit identities' 3
    gh pr diff "$pr" --color never > "$diff_file" || die 'failed to fetch PR diff' 3
    pr_after=$(gh pr view "$pr" --json baseRefOid,headRefOid,url --jq '[.baseRefOid,.headRefOid,.url]|@tsv') || die 'failed to revalidate PR identity' 3
    [[ $pr_before == "$pr_after" ]] || die 'PR changed during collection; recollect before reviewing' 75
    printf '%s\n' "$pr_before" > "$run_dir/pr-identity.tsv"
    label=$pr_url
    ;;
  range)
    spec=$2
    [[ $spec == *..* && $spec != *...* ]] || die 'use base..head; the helper computes its merge-base explicitly' 64
    left=${spec%%..*}; right=${spec#*..}
    [[ -n $left && -n $right && $right != *..* ]] || die 'invalid range' 64
    base_tip=$(resolve_commit "$left") || die 'unknown base revision' 64
    head_ref=$(resolve_commit "$right") || die 'unknown head revision' 64
    base_ref=$(git merge-base --all "$base_tip" "$head_ref") || die 'no usable merge-base' 64
    [[ $base_ref =~ ^[0-9a-f]{40,64}$ ]] || die 'multiple merge-bases; select an explicit comparison before reviewing' 64
    git diff "${diff_args[@]}" "$base_ref" "$head_ref" -- > "$diff_file"
    label="merge-base of $base_tip and $head_ref"
    ;;
  commit)
    head_ref=$(resolve_commit "$2") || die 'unknown commit' 64
    read -r -a lineage <<< "$(git rev-list --parents -n 1 "$head_ref")"
    [[ ${#lineage[@]} -le 2 ]] || die 'merge commit is ambiguous; choose an explicit parent-to-head range' 64
    if [[ ${#lineage[@]} == 2 ]]; then
      base_ref=${lineage[1]}
      git diff "${diff_args[@]}" "$base_ref" "$head_ref" -- > "$diff_file"
    else
      base_ref=empty-tree
      git show "${diff_args[@]}" --format= "$head_ref" -- > "$diff_file"
    fi
    label="commit $head_ref"
    ;;
  staged)
    base_ref=$(git rev-parse --verify -q HEAD || printf 'empty-tree')
    head_ref='index (staged content, not necessarily working-file bytes)'
    git diff "${diff_args[@]}" --cached -- > "$diff_file"
    label='staged changes'
    ;;
  working)
    base_ref=$(git rev-parse --verify -q HEAD || git hash-object -t tree /dev/null)
    head_ref='working tree (net tracked changes plus untracked files)'
    git diff "${diff_args[@]}" "$base_ref" -- > "$diff_file"
    while IFS= read -r -d '' path; do
      code=0
      git diff --no-index "${diff_args[@]}" -- /dev/null "$path" >> "$diff_file" || code=$?
      [[ $code -le 1 ]] || die "could not collect untracked path: $path" 74
    done < <(git ls-files --others --exclude-standard -z)
    label='uncommitted working tree'
    ;;
esac

git status --porcelain=v1 -z --untracked-files=all > "$run_dir/status-after.z"
cmp -s "$run_dir/status-before.z" "$run_dir/status-after.z" || die 'checkout status changed during collection; recollect' 75
git rev-parse --verify -q HEAD > "$run_dir/checkout-head-after.txt" || true
cmp -s "$run_dir/checkout-head.txt" "$run_dir/checkout-head-after.txt" || die 'checkout HEAD changed during collection; recollect' 75
if [[ -s $diff_file ]]; then
  git apply --numstat -z < "$diff_file" > "$run_dir/numstat.z" || die 'diff could not be parsed; not a clean review' 74
  file_count=$(grep -c '^diff --git ' "$diff_file" || true)
else
  file_count=0
fi
{
  printf 'target: %s\nmode: %s\nrepository: %s\nbase: %s\nhead: %s\nfiles: %s\n' \
    "$label" "$mode" "$repo" "$base_ref" "$head_ref" "$file_count"
  printf 'scope: current worktree status is recorded separately; inspect source at the selected target\n'
  printf 'limitation: status equality does not prove concurrent edits to already-dirty bytes were absent; keep writers quiescent\n'
  [[ $file_count != 0 ]] || printf 'No changes to review.\n'
  printf 'DIFF_FILE=%s\n' "$diff_file"
} | tee "$manifest"
