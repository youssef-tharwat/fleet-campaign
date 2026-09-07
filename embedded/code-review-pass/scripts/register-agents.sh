#!/bin/sh
set -eu

usage() {
  cat <<'EOF'
Usage:
  register-agents.sh --host codex|claude|all --project-root DIR [--force]
  register-agents.sh --host codex|claude|all --user [--force]

Registers Fleet Campaign's embedded Code Review Pass agents in a project or the
current user's agent directory. Existing different files are preserved unless
--force is supplied.
EOF
}

host=""
project_root=""
user_scope=0
force=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --host)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      host=$2
      shift 2
      ;;
    --project-root)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      project_root=$2
      shift 2
      ;;
    --user)
      user_scope=1
      shift
      ;;
    --force)
      force=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$host" in
  codex|claude|all) ;;
  *)
    printf '%s\n' '--host must be codex, claude, or all' >&2
    exit 2
    ;;
esac

if [ "$user_scope" -eq 1 ] && [ -n "$project_root" ]; then
  printf '%s\n' 'Choose exactly one scope: --project-root DIR or --user' >&2
  exit 2
fi
if [ "$user_scope" -eq 0 ] && [ -z "$project_root" ]; then
  printf '%s\n' 'Choose exactly one scope: --project-root DIR or --user' >&2
  exit 2
fi

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
agents_dir=$(CDPATH='' cd -- "$script_dir/../agents" && pwd -P)

if [ "$user_scope" -eq 1 ]; then
  target_root=${HOME:?HOME is required for --user}
else
  [ -d "$project_root" ] || {
    printf 'Project root does not exist: %s\n' "$project_root" >&2
    exit 2
  }
  target_root=$(CDPATH='' cd -- "$project_root" && pwd -P)
fi

if [ -z "$target_root" ] || [ "$target_root" = / ]; then
  printf 'Refusing unsafe target root: %s\n' "$target_root" >&2
  exit 2
fi

check_target() {
  source_file=$1
  target_file=$2
  if [ -d "$target_file" ]; then
    printf 'Agent definition target is a directory: %s\n' "$target_file" >&2
    exit 1
  fi
  if [ -e "$target_file" ] && ! cmp -s "$source_file" "$target_file" && [ "$force" -ne 1 ]; then
    printf 'Refusing to replace different agent definition: %s\n' "$target_file" >&2
    printf '%s\n' 'Re-run with --force only after reviewing the existing file.' >&2
    exit 1
  fi
}

install_target() {
  source_file=$1
  target_file=$2
  target_dir=$(dirname -- "$target_file")
  mkdir -p -- "$target_dir"
  if [ -e "$target_file" ] && cmp -s "$source_file" "$target_file"; then
    printf 'unchanged %s\n' "$target_file"
    return
  fi
  temporary_file=$(mktemp "$target_dir/.fleet-review-agent.XXXXXX")
  if ! cp -- "$source_file" "$temporary_file"; then
    rm -f -- "$temporary_file"
    exit 1
  fi
  chmod 0644 "$temporary_file"
  if ! mv -f -- "$temporary_file" "$target_file"; then
    rm -f -- "$temporary_file"
    exit 1
  fi
  printf 'installed %s\n' "$target_file"
}

codex_best_source="$agents_dir/codex/fleet_best_practices_reviewer.toml"
codex_senior_source="$agents_dir/codex/fleet_senior_code_reviewer.toml"
claude_best_source="$agents_dir/claude/fleet-best-practices-reviewer.md"
claude_senior_source="$agents_dir/claude/fleet-senior-code-reviewer.md"

codex_target_dir="$target_root/.codex/agents"
claude_target_dir="$target_root/.claude/agents"

if [ "$host" = codex ] || [ "$host" = all ]; then
  check_target "$codex_best_source" "$codex_target_dir/fleet_best_practices_reviewer.toml"
  check_target "$codex_senior_source" "$codex_target_dir/fleet_senior_code_reviewer.toml"
fi
if [ "$host" = claude ] || [ "$host" = all ]; then
  check_target "$claude_best_source" "$claude_target_dir/fleet-best-practices-reviewer.md"
  check_target "$claude_senior_source" "$claude_target_dir/fleet-senior-code-reviewer.md"
fi

if [ "$host" = codex ] || [ "$host" = all ]; then
  install_target "$codex_best_source" "$codex_target_dir/fleet_best_practices_reviewer.toml"
  install_target "$codex_senior_source" "$codex_target_dir/fleet_senior_code_reviewer.toml"
fi
if [ "$host" = claude ] || [ "$host" = all ]; then
  install_target "$claude_best_source" "$claude_target_dir/fleet-best-practices-reviewer.md"
  install_target "$claude_senior_source" "$claude_target_dir/fleet-senior-code-reviewer.md"
fi
