# Role briefs

Fill the relevant brief before dispatch and deliver it with `herdr agent prompt`
(from a file, as [coordination.md](coordination.md) describes). Put heavy material
in the campaign's evidence directory and name the path. Link durable contracts
and PR comments instead of retyping them into every prompt. A delegated agent
must be told it is not alone and must not revert or overwrite others' edits.
Do not assume it inherits tools,
permissions, repository context, or the coordinator's conversation.

## Shared contract fields

```text
Campaign / item / role:
Coordinator and Herdr workspace/tab/pane or agent target:
Deliverable and measurable done condition:
Read first: project instructions, frozen goal, acknowledged design/protocol, ruling comment URLs:
Ticket/PR task ID (for reference; the coordinator alone writes it):
Review round/lens and open finding IDs when applicable:
How to report: one LEAD-TOKEN block as the last pane output; no report file, no mail:
Source: repository root, branch/commit, dirty/untracked state, relevant hashes:
Approved absolute implementation worktree (required for a writing lane):
Herdr agent name + pane ID; verified pane cwd:
Isolated state root; exact environment variable or CLI flag that binds it:
Owns: exact files/modules or artifact paths:
Read-only / prohibited paths and operations:
Authorized commands, runner, resource limits, and budget:
Commit / push / PR / merge permissions (state each separately):
Dependencies, binding riders, and next review/ack boundary:
Evidence already collected, coverage gaps, and unresolved questions:
```

All roles: preserve unexpected state, report discrepancies rather than patching
around them, and distinguish measured facts, source evidence, and hypotheses.
Every change, feature or fix, addresses the root cause or is the proper
mechanism; no hacks, workarounds or rounds of symptom patching. If a review round
finds a new case of a kind already fixed, or your change only works by listing
cases, stop and report that the mechanism is the problem (a design ruling
request) instead of adding another patch. Temporary scaffolding names its
replacement and is removed when that lands.
Continue through ordinary checkpoints only within the approved contract. Stop at
surprise, the assigned review/ack handoff, a genuine ruling/blocker, or any
authority/safety/resource boundary. An automated approval boundary met inside a
lane belongs to the human: keep the design, reshape the patch into small,
each-compiling increments through the same review, and stop for the human's mode
decision when a single-file increment is still refused. Report completion and
blockers in a LEAD-TOKEN block that is the last output in your own pane; the lane
watcher flags you idle and the coordinator reads it. A block buried under later
output, or a report file, is not a delivered report. An unmigrated campaign uses
its existing channel.

## Implementation lane

Work only in the assigned worktree/branch and file territory. Other agents are
working nearby; accommodate their changes without reverting them. Run every
locally built binary against the lane's isolated state root; only the installed
release touches the machine's shared store (a dev build that opens it can rewrite
shared records and lock every other binary out). Confirm the design matches the
source before implementing. Record the regression control red first, implement
the complete increment, then obtain green evidence at the final revision. Name
intentional refactors and migration consequences; a schema or migration change
accepts the previous identity without writing, never rewriting a shared record on
read (a one-way door for every older binary on the machine).

End with a `READY-FOR-REVIEW` block containing the diff/revisions, red/green
evidence, command flags, scope derivation, measured payoff where applicable, and
known gaps. A remediation round answers every ruled finding ID from the PR
comment. Quiesce for the mandatory Code Review Pass. Do not push merely because
implementation or local tests finished: a push needs an explicit grant.

## Measurement / design agent

Code checkouts remain read-only. Write only named protocol, design, fixture, or
evidence artifacts; changing engine instrumentation needs a separate grant.
Run approved workloads only in the specified environment. A measurement-only
assignment does not authorize designing or implementing fixes.

Hand off the protocol first when ack is required. After execution, deliver raw
artifacts and stamped results, candidate causes supported/contradicted/unresolved,
capture limitations, and runner cleanup. Do not turn proxy observations into
claims about an unmeasured production system.

## Code Review Pass reviewer

Read the selected host's assigned design- or correctness-lens definition under
`embedded/code-review-pass/agents/` and the agent runtime contract there. Record
the native custom-agent name or disclose that the role was prompt-loaded. Inspect
the frozen final revision/diff and agreed headline risk using read-only source and
object-database operations. Check acceptance cases, concurrency/failure
interleavings when material, meaningful red controls witnessed on the actual
pre-fix shape (a red derived from a reasoning step is a hypothesis), and whether
the witnesses cover the final change. A probe that skipped the cases it could not
construct proves only that subset: require a total probe or an honest unknown,
never a partial set presented as unanimity. Disclose missing graph/source/test
coverage. Do not change the tree, share the other lens's conclusions, or run
stateful checks without permission.

Report ranked actionable findings in a LEAD-TOKEN block, the last output in your
own pane, with file:line, affected behavior, evidence and an acceptance-case gap.
Leave confirmation, finding IDs and the PR ruling comment to the coordinator.
Existing rulings are context, not a reason to conceal contradictory evidence.
Distinguish unverified hypotheses from established defects.
