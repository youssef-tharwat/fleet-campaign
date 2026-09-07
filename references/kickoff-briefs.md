# Role briefs

Fill the relevant brief before dispatch. Link durable contracts instead of
retyping them into every message. A delegated agent must be told it is not alone
and must not revert or overwrite others' edits. Do not assume it inherits tools,
permissions, repository context, or the coordinator's conversation.

## Shared contract fields

```text
Campaign / item / role:
Coordinator and reporting channel:
Deliverable and measurable done condition:
Read first: project instructions, goal, register, acknowledged design/protocol:
Source: repository root, branch/commit, dirty/untracked state, relevant hashes:
Owns: exact files/modules or artifact paths:
Read-only / prohibited paths and operations:
Authorized commands, runner, resource limits, and budget:
Commit / push / PR / merge permissions (state each separately):
Dependencies, binding riders, and next review/ack boundary:
Evidence already collected, coverage gaps, and unresolved questions:
```

All roles: preserve unexpected state, report discrepancies rather than patching
around them, and distinguish measured facts, source evidence, and hypotheses.
Continue through ordinary checkpoints only within the approved contract. Stop at
surprise, the assigned review/ack handoff, a genuine ruling/blocker, or any
authority/safety/resource boundary. Report completion and blockers actively to
the coordinator; a file left in your own pane is not a delivered report.

## Implementation lane

Work only in the assigned worktree/branch and file territory. Other agents are
working nearby; accommodate their changes without reverting them. Confirm the
design matches the source before implementing. Record the regression control
red first, implement the complete increment, then obtain green evidence at the
final revision. Name intentional refactors and migration consequences.

Deliver `READY-FOR-REVIEW` with the diff/revisions, red/green transcripts, command
flags, scope derivation, measured payoff where applicable, and known gaps. Do
not push merely because implementation or local tests finished.

## Measurement / design agent

Code checkouts remain read-only. Write only named protocol, design, fixture, or
evidence artifacts; changing engine instrumentation needs a separate grant.
Run approved workloads only in the specified environment. A measurement-only
assignment does not authorize designing or implementing fixes.

Hand off the protocol first when ack is required. After execution, deliver raw
artifacts and stamped results, candidate causes supported/contradicted/unresolved,
capture limitations, and runner cleanup. Do not turn proxy observations into
claims about an unmeasured production system.

## Independent reviewer

Inspect the assigned final revision/diff and the agreed headline risk. Use
read-only source and object-database operations. Check acceptance cases,
concurrency/failure interleavings when material, meaningful red controls, and
whether the witnesses cover the final change. Disclose missing graph/source/test
coverage. Do not change the tree or run stateful checks without permission.

Report ranked actionable findings with file:line, affected behavior, evidence,
and an acceptance-case gap. Existing rulings are context, not a reason to conceal
contradictory evidence. Distinguish unverified hypotheses from established defects.
