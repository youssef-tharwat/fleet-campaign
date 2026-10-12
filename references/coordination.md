# Herdr delivery, pane reports and the task register

Herdr is Fleet Campaign's agent runtime and its only delivery channel. Agent Mail
**tasks**, written only by the coordinator, are the work register for new local
campaigns; Agent Mail messages are not used. Lanes report in their own pane, and
review rulings live on the PR. Read
[the incorporated Herdr playbook](../embedded/herdr/PLAYBOOK.md) completely before the
first control command, verify `HERDR_ENV=1`, and confirm `herdr` is available in
`PATH`. If either prerequisite is absent, stop the campaign before dispatch; do
not substitute native delegation, terminal automation, or undelivered briefs.

Before dispatch, establish the target's actual ID/name, role, working directory,
write territory, tool access, model policy, and lifecycle. Capture returned handles;
do not guess IDs from layout or presume shared context. Disjoint files, not
separate pane names, establish safe parallel writing. Never launch a duplicate
owner for a territory whose prior writer may still be active.

## Lane continuity and new-lane requests

An existing live agent remains the owner of its current lane when Herdr reports
`idle` or `done`. Those are scheduling states, not authority to replace its brief.
Do not send unrelated campaign work to an existing agent unless the user or that
lane's authority explicitly approves reassignment.

When the user asks to deploy, create, or open **new lanes**, create new terminal
topology and new agent identities. Use a new tab when the user asks for one or
when it keeps a new campaign item distinct; otherwise a new sibling pane is
sufficient. Do not satisfy the request by borrowing an idle pane or stopping an
existing lane. After prompting each new agent, verify all of the following before
calling it deployed:

- the returned tab and pane IDs are the newly created ones;
- the agent has a unique new name and the intended cwd;
- the brief names its ownership and non-ownership boundaries;
- `herdr agent get` observes a lifecycle transition to `working`.

If an unrelated brief is accidentally sent to an existing lane, do not kill its
process merely to erase the mistake. Preserve its work, send a correction at the
next supported message boundary, create the intended new lane, and disclose the
misroute. An idle agent having accepted a prompt is not evidence that its previous
ownership disappeared.

When a lane incident exposes a defect in shared tooling (for example, the required
tool is unavailable or its recovery path blocks the lane), keep two facts
separate: the consuming lane's work remains owned there, while the tool defect is
investigated and, if accepted, implemented in a dedicated tool/product lane. The
incident is a regression witness, not a reason to make the consuming lane absorb
an unrelated fix.

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

## Where each record lives

| Need | Home | Rule |
|---|---|---|
| Delivery (assignments, rulings, pings) | `herdr agent prompt <lane> ...` | The coordinator delivers. A lane watcher flags idle lanes. |
| State / register | Agent Mail tasks, one per ticket or PR, plus a campaign task | The coordinator is the only writer. Lanes neither send nor read mail and need no binding. |
| Lane report | One LEAD-TOKEN block, the last output in the lane's pane | No report file. The coordinator copies the outcome into the task. |
| Review ruling | A comment on the PR (`gh pr comment`) by the coordinator | Durable and next to the code. No ruling files. |
| Heavy evidence (eval logs, raw runs, a large design) | `<campaign-root>/evidence/<PR-or-ticket>/`, only when needed | Deleted when the PR merges; one line stays in the task. |

Use [the task register contract](register-template.md) for setup and phase
mapping. Lanes have no Mail identity, so the coordinator owns and writes every
task; the lane, worktree and pane go in the scope and next action.

## Lane report contract

A lane's report is one block, the last output in its own pane. The block is the
durable report: the coordinator reads it there, so do not write a separate report
file, and do not bury the block above later output. One block serves one purpose;
disclose evidence class and state.

```text
LEAD-TOKEN — outcome headline
FROM: <lane> / <ticket or PR>
STATE: <worktree> @ <sha> (pushed? dirty?), CI/local evidence status
BODY: numbered claims tagged [measured: run/protocol] [code-cited: file:line]
      [historical: source] [hypothesis]
DISPOSITION: CONTINUING with <next authorized step> | HOLDING on <named trigger>
EVIDENCE: <heavy-evidence path, if any>
```

Use `READY-FOR-REVIEW`, `RULING NEEDED`, `STOP-ON-SURPRISE`, `MILESTONE`,
`BUILD:`, `HANDOVER READY`, or `ALARM` as the token. State unavailable fields
rather than inventing provenance. A remediation report answers every ruled
finding ID with its outcome and witness. A design note that would not fit a
readable block goes to the evidence directory, and the block names its path.

When the lane watcher flags an idle lane, the coordinator reads the block (for
example `herdr agent read <lane> --source recent-unwrapped --lines 200`),
verifies its claims against the worktree, PR and CI, and records the outcome in
the task with the observed version and a reason. A lane that went idle without a
block as its last output is prompted to finish it; Herdr `idle` or `done` alone is
not a report.

A terminal lane result is delivered when its block names identity, revision,
result, limits, resource disposition and the next owner action. The coordinator
still verifies the worktree, pushed head and PR when the lane is shipping code.
A local commit, clean pane, or Herdr `done` is not terminal delivery. No PR is
required only for an explicitly scoped evidence/design/experiment result, a
ruled park/abandon disposition, or a superseded change; record that reason in
the task.

## Rulings

A review ruling is a comment on the PR, posted by the coordinator with
`gh pr comment`. It identifies the round and frozen head, gives numbered decisions
with stable finding IDs, and carries riders that name the unsafe direction ("drop
the check" is never a whole ruling: say where the check moves and what red pins
it). It also names the disposition of every open thread and what was already
settled. Then the coordinator prompts the lane through Herdr with the comment URL
and records the round, open IDs and URL in the PR task. A ruling before a PR
exists (a design ack, a sequencing decision) is delivered by Herdr prompt and
recorded in the ticket task's update reason; if it is longer than a task reason
can carry, it goes to the evidence directory. Acknowledgment of evidence is not
an implementation, push, merge or eval-dispatch grant: each needs an explicit
grant.

## Herdr control

Inspect the current CLI help; use explicit live agent names or returned pane IDs,
never the UI-focused pane by default. Preserve user focus when creating approved
background panes. Revalidate identities after reorganization; do not assume names,
IDs, or sessions survived unchanged.

Herdr prompts carry every brief, ruling notice and ping. Send prompt contents as
data, not executable shell text. For example, in a shell supporting
this syntax, with `recipient` and `brief_path` explicitly resolved:

```sh
herdr agent prompt "$recipient" "$(< "$brief_path")"
```

Do not use `eval` or interpolate a report into a newly constructed shell program.
Do not place an inline prompt containing backticks, command substitutions, shell
variables, redirects, or glob characters inside a shell command string: the shell
can execute prompt prose before Herdr receives it. Write such a prompt to an
approved file with the file editor, then pass its contents using the quoted
file-read form above. If shell expansion occurs accidentally, disclose the exact
command and effects, check for leftover processes or mutations, and resend from a
file; do not treat the malformed prompt as delivered evidence.
A Herdr prompt acknowledgment proves only prompt submission; the lane's next
LEAD-TOKEN block proves it was handled. Do not prompt a lane while it is working
on a step it was not asked to interrupt. If a wait times out, read the pane before
resending. Timeout is not proof of non-delivery.
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

Use the host's supported handover/reset mechanism after the lane's
`HANDOVER READY` block and the coordinator's task checkpoint are persisted (or
the legacy handover for an unmigrated campaign), within the coordinator/user's
authorized transition. Confirm
the old writer stopped before a replacement takes ownership. A context reset need not
reload tools; if tool configuration changed, verify actual tool availability
after the appropriate process/session restart. Never reset unrelated agents.

Record live jobs and claims across rotation, attributing each by its claim line
rather than by resemblance; creation time and address both lie. Release owned
resources promptly when their work completes and on their deadline regardless,
never idling a paid one while an approval is pending — resume on a fresh handle.
If cleanup fails, retain the exact handle and report the outstanding
cost/authority instead of claiming the resource is gone.
