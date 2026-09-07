#!/bin/sh
set -eu

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
test_root=$(mktemp -d "${TMPDIR:-/tmp}/fleet-review-agents.XXXXXX")

cleanup() {
  rm -rf -- "$test_root"
}
trap cleanup EXIT HUP INT TERM

register="$script_dir/register-agents.sh"

"$register" --host all --project-root "$test_root"
test -f "$test_root/.codex/agents/fleet_best_practices_reviewer.toml"
test -f "$test_root/.codex/agents/fleet_senior_code_reviewer.toml"
test -f "$test_root/.claude/agents/fleet-best-practices-reviewer.md"
test -f "$test_root/.claude/agents/fleet-senior-code-reviewer.md"

"$register" --host all --project-root "$test_root"

printf '%s\n' '# local customization' > "$test_root/.claude/agents/fleet-best-practices-reviewer.md"
rm "$test_root/.codex/agents/fleet_best_practices_reviewer.toml"
if "$register" --host all --project-root "$test_root" >/dev/null 2>&1; then
  printf '%s\n' 'expected registration to preserve a conflicting file' >&2
  exit 1
fi
test ! -e "$test_root/.codex/agents/fleet_best_practices_reviewer.toml"

"$register" --host claude --project-root "$test_root" --force
cmp -s \
  "$script_dir/../agents/claude/fleet-best-practices-reviewer.md" \
  "$test_root/.claude/agents/fleet-best-practices-reviewer.md"

"$register" --host codex --project-root "$test_root"
printf '%s\n' 'outside sentinel' > "$test_root/outside.toml"
rm "$test_root/.codex/agents/fleet_best_practices_reviewer.toml"
ln -s "$test_root/outside.toml" "$test_root/.codex/agents/fleet_best_practices_reviewer.toml"
"$register" --host codex --project-root "$test_root" --force
grep -Fxq 'outside sentinel' "$test_root/outside.toml"
test ! -L "$test_root/.codex/agents/fleet_best_practices_reviewer.toml"
cmp -s \
  "$script_dir/../agents/codex/fleet_best_practices_reviewer.toml" \
  "$test_root/.codex/agents/fleet_best_practices_reviewer.toml"

printf '%s\n' 'register-agents tests passed'
