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

| ID | Gate advanced | Increment / non-goals | Owner + file territory | Source identity | Dependencies | State | Evidence / review | Next trigger |
|---|---|---|---|---|---|---|---|---|

Useful states: PROPOSED, MEASURING, DESIGN-REVIEW, ACKED, IMPLEMENTING,
READY-FOR-REVIEW, BLOCKED, PARKED, DONE. Name the actual blocker or resumption
trigger; an idle pane is not proof that an item is done.

Keep a dated ruling record with the question, decision, authority, riders, and
evidence. Append an explicit correction when new evidence falsifies a ruling;
do not rewrite history to imply the corrected fact was known earlier.

DONE records what actually finished: measurement accepted, design accepted,
implementation reviewed, or change integrated, as applicable. For integrated
work, include the final revision/PR and its witnesses. Track remaining design or
implementation work separately. Do not mark a performance goal achieved just
because a measurement run or a patch completed.
