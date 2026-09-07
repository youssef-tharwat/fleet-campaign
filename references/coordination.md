# Herdr coordination and fleet messages

Herdr is Fleet Campaign's required coordination transport. Read
[the incorporated Herdr playbook](../embedded/herdr/PLAYBOOK.md) completely before the
first control command, verify `HERDR_ENV=1`, and confirm `herdr` is available in
`PATH`. If either prerequisite is absent, stop the campaign before dispatch; do
not substitute native delegation, terminal automation, or undelivered briefs.

Before dispatch, establish the target's actual ID/name, role, working directory,
write territory, tool access, model policy, and lifecycle. Capture returned handles;
do not guess IDs from layout or presume shared context. Disjoint files, not
separate pane names, establish safe parallel writing. Never launch a duplicate
owner for a territory whose prior writer may still be active.

## Implementation lane panes

Fleet Campaign overrides Herdr's general same-directory default for implementation
lanes. Resolve the lane from `git worktree list`, obtain the required authority to
create or use that worktree, and bind the brief to its absolute path and isolated
state root before creating the pane. Then create the background pane in that exact
checkout:

```sh
lane_worktree="<approved-absolute-worktree-path>"
herdr pane split --current --direction right --cwd "$lane_worktree" --no-focus
```

Choose `down` instead when the caller geometry requires it. Parse the returned pane
ID, verify its cwd, and only then use `herdr agent start`. If the worktree or state
root is unresolved, emit `RULING NEEDED` and do not dispatch the implementation
lane. Measurement and reviewer panes remain read-only and follow their assigned
source identity.

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
question, gives numbered decisions with riders that name the unsafe direction
("drop the check" is never a whole ruling: say where the check moves and what
red pins it), and names the disposition of every open thread. Acknowledgment of
evidence is not an implementation or push grant.

## Herdr control

Inspect the current CLI help; use explicit live agent names or returned pane IDs,
never the UI-focused pane by default. Preserve user focus when creating approved
background panes. Revalidate identities after reorganization; do not assume names,
IDs, or sessions survived unchanged.

Send file contents as data, not executable shell text. For example, in a shell
supporting this syntax, with `recipient` and `brief_path` explicitly resolved:

```sh
herdr agent prompt "$recipient" "$(< "$brief_path")"
```

Do not use `eval` or interpolate a report into a newly constructed shell program.
Verify delivery using the tool's acknowledgment and lifecycle; if a wait times
out, inspect the target before resending. Timeout is not proof of non-delivery.
Polling or waiting must respect the host's communication and timeout limits.

## Integration order and merge queue

The coordinator sequences integration; `READY-FOR-REVIEW` is not a submission.
Submit a change to the merge queue only after its Code Review Pass clears, and
never as its author: authors do not self-enqueue and do not push while their
change is testing, because a mid-test push restarts the batch for everyone. When
the queue looks slow, measure runner capacity before blaming the process.

- A hotspot rewrite goes first. When one PR rewrites a file every other open PR
  edits (a shared changelog, a lockfile), land it ahead of them, hold the rest,
  and let each convert on its next rebase; otherwise the rewrite rebases once per
  open PR.
- Trust-set changes land before the code that needs them. A rotated
  reusable-workflow pin, runner-group admission, or identity-federation
  condition is admitted in the live trust set first; a PR that depends on it
  wedges the queue if it enters earlier.
- A required-check change invalidates every open PR's last run. Refresh each
  merge ref with a rebase push or the host's update-branch action; a re-run
  reuses the old merge commit and proves nothing.
- Retarget stacked children before a parent squashes. A squash-merged parent
  closes an unretargeted child, and a closed PR cannot be retargeted.
- A batch tested on a stale base is not a code red. After a dependency or pin
  rotation lands, re-run the coherence guard on both trees, cancel the doomed
  run, and resubmit from the current base; waiting out a doomed run is the
  expensive choice.
- A per-PR artifact that needs the PR number reserves it with a draft: open the
  draft, add the artifact, then mark it ready. Never guess a number.

## Rotation and cleanup

Use the host's supported handover/reset mechanism only after the handover file
is complete and the coordinator/user authorizes the transition. Confirm the old
writer stopped before a replacement takes ownership. A context reset need not
reload tools; if tool configuration changed, verify actual tool availability
after the appropriate process/session restart. Never reset unrelated agents.

Record live jobs and claims across rotation, attributing each by its claim line
rather than by resemblance; creation time and address both lie. Release owned
resources promptly when their work completes and on their deadline regardless,
never idling a paid one while an approval is pending — resume on a fresh handle.
If cleanup fails, retain the exact handle and report the outstanding
cost/authority instead of claiming the resource is gone.
