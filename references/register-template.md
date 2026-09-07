# One action register per campaign

Reuse the project's register. If none exists, the coordinator creates one in an
approved durable location before allocating work. Do not fork a second list when
joining or rotating a campaign.

## Header

- Goal/acceptance document and its frozen revision.
- Coordinator and reporting channel.
- Authorized repositories, artifact paths, and standing grants.
- Runner/build-slot policy, measurement limits, and budget.
- Integration/review policy; decisions still reserved for the user.

## Gates

| Gate | Input and environment | Acceptance criterion | Current evidence | Gap |
|---|---|---|---|---|

Use explicit units and populations. For example, first-edit latency and repeat
latency are separate gates; a safety regression test is not a performance result.

## Work items

| ID | Gate advanced | Increment / non-goals | Owner + file territory | Source identity | Runtime binding | Dependencies | State | Evidence / review | Next trigger |
|---|---|---|---|---|---|---|---|---|---|

For every implementation lane, `Runtime binding` records the approved absolute
worktree path, Herdr agent name and pane ID, verified pane cwd, isolated state
root, and the exact environment variable or CLI flag that binds local commands to
that state. Record and verify this binding before moving the item to IMPLEMENTING.
`Evidence / review` names durable paths: witnesses, the finding ledger, and any
failed-stage originals preserved before a runner was released.

Useful states: PROPOSED, MEASURING, DESIGN-REVIEW, ACKED, IMPLEMENTING,
READY-FOR-REVIEW, REVIEWING, REMEDIATING, RE-REVIEWING, BLOCKED, PARKED, DONE.
Name the actual blocker or resumption trigger; an idle pane is not proof that an
item is done. An implementation lane cannot reach DONE until its final Code
Review Pass has no unresolved finding.

Keep a dated ruling record with the question, decision, authority, riders, and
evidence. Stamp every register entry on one clock, UTC. Append an explicit
correction when new evidence falsifies a ruling or a stamp proves wrong; do not
rewrite history to imply the corrected fact was known earlier.

DONE records what actually finished: measurement accepted, design accepted,
implementation reviewed, or change integrated, as applicable. For integrated
work, include the final revision/PR and its witnesses. Track remaining design or
implementation work separately. Do not mark a performance goal achieved just
because a measurement run or a patch completed.
