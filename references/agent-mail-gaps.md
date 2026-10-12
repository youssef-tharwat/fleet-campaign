# Agent Mail in Fleet: what is used, and what is not

Use this reference when deciding how much of Agent Mail a campaign should use, or
when planning changes to Agent Mail itself. The operating contract is in
[register-template.md](register-template.md).

## What Fleet uses

Only **tasks**, written by the coordinator alone: one per ticket or PR plus a
campaign task. They hold versioned state, decision reasons and history,
next actions, evidence references, and the coordinator's continuation
checkpoints. They replace status tables and file registers.

## What Fleet does not use, and why

| Mail feature | Hybrid replacement | Reason |
|---|---|---|
| Messages (`mail send` / `reply` / `resolve`) for briefs, reports and rulings | Herdr prompts for delivery; LEAD-TOKEN blocks in the lane's pane for reports; PR comments for rulings | Delivery to Herdr lanes depended on each recipient's runtime policy. A send from a Herdr lane persisted but reported delivery `notify_only`, with "Herdr has no idle delivery under notify-only policy; use a native managed launch or explicitly opt into unguarded prompts" (observed 12.10.2026). Coordinators also reported mail from some lanes never reaching them. A persisted message the recipient never sees is worse than a pane block the coordinator reads directly. |
| Lane mailboxes and Herdr pane bindings | None: lanes have no Mail identity | Every binding is setup that can fail or go stale across pane moves and restarts. With messages retired, a lane has nothing to send or receive. |
| Review and finding tasks | One ruling comment per round on the PR, with stable finding IDs | The ruling sits next to the code it rules on, the lane reads it without Mail access, and the forge keeps it after the campaign ends. |

## Capabilities in 0.15.0 not yet adopted

The 0.10.1 gaps this file used to list have all shipped, according to the
installed 0.15.0 help. Fleet has not exercised any of them yet:

| Capability | 0.15.0 command | Possible Fleet use |
|---|---|---|
| [Shared campaign documents](https://github.com/youssef-tharwat/agent-mail/issues/4) | `record create/update/show/history/link` (immutable, group-visible revisions) | Frozen campaign contracts with exact revision references, instead of repository files. |
| [Compact artifact storage](https://github.com/youssef-tharwat/agent-mail/issues/5) | `artifact ingest/fetch/check/link/pin/prune` | Heavy evidence that must outlive the PR, instead of the evidence directory that is deleted on merge. |
| [Task relationships](https://github.com/youssef-tharwat/agent-mail/issues/6) | `task relate`, `task dependencies`, `task tree` | Linking a ticket task to its PR tasks and to the campaign task. |
| [Writer transfer](https://github.com/youssef-tharwat/agent-mail/issues/7) | `task transfer-writer` | Rotating the coordinator role to a new identity. |
| [Complete audit access](https://github.com/youssef-tharwat/agent-mail/issues/8) | `task list` with explicit filters (terminal history), paginated `task history` | Recovering closed tickets beyond the current history window. |

Adopt one only through an explicit protocol change with a cutover, so a campaign
never has two homes for the same record.

## What would bring messages back

Mail messages could replace Herdr prompts again only if both of these hold, and
both are verified on the campaign's actual runtimes:
- delivery to an idle Herdr lane is guaranteed, not `notify_only`;
- a send that is not delivered is reported back to the sender.

Until then, Herdr delivers and the pane is the report.

Keep Fleet phases and review/acceptance rules in this skill. Agent Mail should
provide general durable records and authority primitives that other workflows
can also use.
