# Embedded review agents

Code Review Pass ships two real named reviewer definitions for Codex and Claude.
They deliberately omit a fixed model so the campaign inherits the user's model
and budget policy.

| Lens | Codex custom agent | Claude custom agent |
|---|---|---|
| Design and maintainability | `codex/fleet_best_practices_reviewer.toml` | `claude/fleet-best-practices-reviewer.md` |
| Correctness and production risk | `codex/fleet_senior_code_reviewer.toml` | `claude/fleet-senior-code-reviewer.md` |

Codex discovers project agents under `.codex/agents/`; Claude discovers project
agents under `.claude/agents/`. The open `skills` installer installs this entire
directory as part of Fleet Campaign, but it does not promote embedded agent files
into either host's discovery directory. When the campaign has authority to modify
project agent configuration, register the definitions explicitly:

```sh
fleet_skill_dir="<installed-fleet-campaign-directory>"
bash "$fleet_skill_dir/embedded/code-review-pass/scripts/register-agents.sh" \
  --host codex --project-root "$LANE_WORKTREE"
bash "$fleet_skill_dir/embedded/code-review-pass/scripts/register-agents.sh" \
  --host claude --project-root "$LANE_WORKTREE"
```

Use `--host all` to register both formats. The helper is idempotent for identical
files and refuses to replace a different existing definition unless the user
explicitly supplies `--force`. Agent definitions are loaded when a new agent
session starts, so register before creating reviewer panes.

## Herdr dispatch

Herdr is still the required launcher and communication mechanism. Create each
reviewer pane in the exact read-only review checkout, keep focus in the caller,
and parse the returned pane ID before starting the agent.

Claude can run a registered role directly:

```sh
herdr agent start fleet-best-practices-reviewer --kind claude --pane "$PANE_ID" -- \
  --agent fleet-best-practices-reviewer
```

For Codex, start a read-only Codex session through Herdr and instruct that session
to delegate the lens to the registered custom agent, wait for it, and return its
review. Codex custom agents are spawned-session configurations rather than a
top-level CLI selector:

```sh
herdr agent start fleet-best-practices-reviewer --kind codex --pane "$PANE_ID" -- \
  --sandbox read-only
herdr agent prompt fleet-best-practices-reviewer \
  "Delegate this assignment only to custom agent fleet_best_practices_reviewer; wait for it and return its complete review. <frozen assignment>" \
  --wait --timeout 120000
```

Repeat with the senior reviewer in a separate pane. If native registration is not
authorized or supported, start a read-only host agent through Herdr and send the
complete matching Claude Markdown definition followed by the frozen assignment.
That fallback preserves the role contract, but report it as a prompt-loaded role,
not a natively registered custom agent.
