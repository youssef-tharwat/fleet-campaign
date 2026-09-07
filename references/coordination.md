# Coordination adapters and fleet messages

Choose one authoritative channel already available for the campaign. Prefer native
agent delegation/messaging when it supplies the required isolation and identity.
Use Herdr for an authorized Herdr-managed fleet. Without an available channel,
write durable briefs for the user or coordinator; do not invent sent messages,
running agents, or independent review.

Before dispatch, establish the target's actual ID/name, role, working directory,
write territory, tool access, model policy, and lifecycle. Capture returned handles;
do not guess IDs from layout or presume shared context. Disjoint files, not
separate pane names, establish safe parallel writing. Never launch a duplicate
owner for a territory whose prior writer may still be active.

## Message contract

Write designs, rulings, handovers, and measured reports to their approved durable
files before messaging. Transport may carry a concise summary and links or exact
file contents. Use one message for one purpose; disclose evidence class and state.

```text
LEAD-TOKEN — outcome headline
FROM: agent name / role / campaign item
STATE: relevant root + revision, dirty state, workload or review status
BODY: numbered claims [measured: run/protocol] [code-cited: file:line]
      [historical: source] [hypothesis]
DISPOSITION: CONTINUING with next authorized step | HOLDING on named trigger
FILES: durable paths
```

Use `BUILD:`, `MILESTONE`, `STOP-ON-SURPRISE`, `RULING NEEDED`,
`READY-FOR-REVIEW`, `HANDOVER READY`, or `ALARM` as appropriate. State unavailable
fields rather than inventing provenance. A coordinator's reply identifies the
question, gives numbered decisions/riders, and names the disposition of every
open thread. Acknowledgment of evidence is not an implementation or push grant.

## Herdr, when available and authorized

Read the installed Herdr skill if available, and check `HERDR_ENV=1` before any
control command. Inspect the current CLI help; use explicit live agent names or
returned pane IDs, never the UI-focused pane by default. Preserve user focus when
creating approved background panes. Revalidate identities after reorganization;
do not assume names, IDs, or sessions survived unchanged.

Send file contents as data, not executable shell text. For example, in a shell
supporting this syntax, with `recipient` and `brief_path` explicitly resolved:

```sh
herdr agent prompt "$recipient" "$(< "$brief_path")"
```

Do not use `eval` or interpolate a report into a newly constructed shell program.
Verify delivery using the tool's acknowledgment and lifecycle; if a wait times
out, inspect the target before resending. Timeout is not proof of non-delivery.
Polling or waiting must respect the host's communication and timeout limits.

## Rotation and cleanup

Use the host's supported handover/reset mechanism only after the handover file
is complete and the coordinator/user authorizes the transition. Confirm the old
writer stopped before a replacement takes ownership. A context reset need not
reload tools; if tool configuration changed, verify actual tool availability
after the appropriate process/session restart. Never reset unrelated agents.

Record live jobs and claims across rotation. Release completed owned resources
promptly; if cleanup fails, retain the exact handle and report the outstanding
cost/authority instead of claiming the resource is gone.
