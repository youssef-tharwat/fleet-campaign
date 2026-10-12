---
name: fleet-campaign
description: Coordinate a Herdr-managed multi-agent engineering campaign with frozen acceptance gates, single-writer lanes, a coordinator-written Agent Mail task register, pane LEAD-TOKEN reports, PR-comment rulings, and a Code Review Pass at each lane boundary. Use for sustained parallel project work or an assigned campaign role. Requires Herdr; new local campaigns also require Agent Mail for the coordinator's register. Not for isolated tasks or merely inspecting this skill.
---

# Fleet Campaign

Run evidence-gated increments toward an agreed outcome through Herdr. This skill
incorporates the required Herdr and Code Review Pass playbooks under `embedded/`;
users do not need to install those skills separately. The Herdr CLI and an active
Herdr-managed session are runtime prerequisites. New local campaigns also use
Agent Mail **tasks** as the coordinator's work register; they do not use Agent
Mail messages.

Before any campaign action, read
[embedded/herdr/PLAYBOOK.md](embedded/herdr/PLAYBOOK.md)
completely and verify `HERDR_ENV=1`. Invoking Fleet Campaign selects Herdr as the
requested coordination mechanism. If the check fails, report that Fleet Campaign
cannot run outside Herdr and stop; do not substitute another transport or pretend
messages were delivered. Creating or reading this skill does not start a campaign.

The campaign runs on a hybrid protocol. Each need has exactly one home:

| Need | Home | Rule |
|---|---|---|
| Delivery (assignments, rulings, pings) | `herdr agent prompt <lane> ...` | The coordinator delivers. A lane watcher flags idle lanes for the coordinator to read. |
| State / register | Agent Mail **tasks**, one per ticket or PR (plus a campaign task) | The coordinator is the only writer. Lanes neither send nor read mail and need no Mail binding. |
| Lane report | One LEAD-TOKEN block, the last output in the lane's own pane | No report file. The coordinator reads the pane and copies the outcome into the task. |
| Review ruling | A comment on the PR (`gh pr comment`) by the coordinator | Durable and next to the code. No ruling files. |
| Heavy evidence (eval logs, raw runs, large designs) | `<campaign-root>/evidence/<PR-or-ticket>/`, only when needed | Deleted when the PR merges; one line stays in the task. |

For a new local campaign, the coordinator loads the installed `$agent-mail` skill
(its operating guide comes from `agent-mail --skill`) and reads
[the task register contract](references/register-template.md), then sets up a
distinct group for its own identity before dispatch. Diagnose missing
prerequisites through Mail's installed guide; report any unresolved setup
blocker. The examples were checked against the Agent Mail 0.15.0 help; check the
installed guide/help for changes. An existing campaign keeps its current register
and channel until its coordinator explicitly migrates it; do not run two
authoritative registers. Herdr owns live agent sessions and delivery; Agent Mail
tasks own durable state; the forge owns review rulings; Fleet owns review gates
and acceptance decisions.

## Enter the assigned role

Read the project's applicable instructions and assigned brief. A lane reads the
brief the coordinator delivered through Herdr and any ruling comment it names on
the PR; it does not read the Mail register. The coordinator recovers its register
from Agent Mail (`agent-mail context`, then the tasks); an unmigrated campaign
reads its existing register. Reuse the coordinator and do not create a competing
register or claim another lane.

| Role | Responsibility | Boundary |
|---|---|---|
| Coordinator / design owner | Gates, sequencing, rulings, ownership, register, integration decisions | Does not concurrently implement in a lane; integration still requires the user's authority |
| Implementation lane | One approved increment in an explicitly owned file territory | One writer per worktree/branch; no edits to another lane's files |
| Measurement / design agent | Protocols, measured evidence, proposed designs, acceptance fixtures | Code checkouts read-only unless separately granted implementation scope; write only assigned artifacts |
| Code Review Pass reviewer | One independent design or correctness lens over the frozen final diff and witnesses | No edits, staging, checkout, push, or automatic repair of the reviewed tree |

For a planning-only request, stop at the plan. Without authorization to start
Herdr agents, offer a plan with the same evidence gates; do not launch a fleet or
pretend independent review occurred. Respect user/host model choices and resource
budgets instead of prescribing vendors or a fixed fleet size.

## Establish the contract

1. Freeze measurable done/release gates, non-goals, correctness invariants, source
   identity, and what would require a new ruling. Name the next deliverable.
2. Resolve authority separately for writing files, creating worktrees, running
   workloads, provisioning runners, committing, pushing, opening PRs, and merging.
   An assignment or `GO` only authorizes the scope it actually names.
3. For a new local campaign, the coordinator creates one Agent Mail group, a
   campaign task and one task per ticket or PR, and is the only writer of all of
   them. Keep the lane, lifecycle state, next action, PR, accepted revision and
   evidence references there; checkpoints hold the coordinator's continuation
   plans. Briefs travel by Herdr prompt, reports by pane LEAD-TOKEN block,
   rulings by PR comment. Keep heavy evidence in the campaign's evidence
   directory only when needed. Follow the storage boundaries and phase mapping in
   [references/register-template.md](references/register-template.md).
4. Resolve each implementation lane to an approved worktree path and an isolated
   state root before dispatch; every locally built binary runs against that root,
   never the machine's shared store. Attribute a branch, PR, or task to the
   checkout that holds it (`git worktree list`): a label, branch name, pane, or
   message header is not a substitute for the checkout that owns the lane. Do not
   start the lane in the coordinator's working directory.
5. Treat live lane ownership as durable across lifecycle states: `idle` or `done`
   means ready for input, not unowned. Do not replace an existing lane's brief or
   repurpose its agent for unrelated work unless the user or lane owner explicitly
   authorizes reassignment. A request to deploy new lanes creates new panes and
   new agents; it does not mean filling apparently idle existing panes.
   For a shipping code lane, `done` is not a local-code state. Unless the brief
   explicitly ends in a non-shipping experiment, evidence-only result, park, or
   abandonment, terminal delivery requires the final gates and review, a pushed
   branch, an opened PR, and the PR URL delivered to the coordinator. A local
   commit, clean worktree, or READY label is still in progress.
6. Use Herdr to start and identify agents and to deliver every assignment and
   ruling notice. Lanes get no Mail binding. Read
   [references/kickoff-briefs.md](references/kickoff-briefs.md) when assigning or
   accepting a role; fill the brief with real paths and commands.
7. Read [references/coordination.md](references/coordination.md) before starting
   agents, delivering a brief or ruling, sequencing integration, or rotating a
   session. A Herdr lifecycle state is not a report: only a LEAD-TOKEN block in
   the lane's pane is.

The Mail task register owns current campaign and ticket/PR state, decisions with
their reasons, and the coordinator's continuation checkpoints. PR comments own
review rulings and the finding ledger. Do not require a status, ruling,
finding-ledger, report or handover file. An unmigrated campaign keeps its
authority until an explicit cutover. Agent Mail capabilities, and why the
campaign does not use its messages, are in
[references/agent-mail-gaps.md](references/agent-mail-gaps.md).

## Evidence before implementation

- Ground the mechanism in current code and exact file:line citations. Where a
  graph is available, verify its repository, generation, and relevant coverage;
  inspect source for gaps. An index's build SHA does not prove indexed working
  bytes were committed. Never stage files or reindex a read-only checkout merely
  to improve graph coverage.
- For performance work, read
  [references/measurement-protocol.md](references/measurement-protocol.md).
  Agree the protocol before costly runs. Keep production-path measurements apart
  from diagnostic replays that change caching, retention, or instrumentation.
- Before a non-trivial implementation, submit a design note containing the
  evidenced mechanism; intended design; dangerous failure direction and guards;
  ownership/concurrency boundaries; regression controls; schema/compatibility
  consequences; the correction path for any record the design freezes
  (immutability without one is a defect); and measurable acceptance criteria.
  Obtain the required ack.
- Preserve a principled fix when it needs a refactor. Name the refactor and its
  boundaries in the design and review handoff. Split work into complete
  increments; do not preserve a defective design just to minimize the diff.

## Required lane engineering loop

Every implementation lane follows this loop. The coordinator, as the register's
only writer, records each decision, reason and evidence reference in the
versioned ticket/PR task. Fleet's uppercase phases below map to Mail's lowercase
states as specified in the register contract; they are not accepted `--state`
values. Lanes report progress only through LEAD-TOKEN blocks in their own pane.
An unmigrated campaign uses its existing register.
Implementation and local green tests are not the end of a lane.

1. **ACKED:** Freeze the lane's design, file territory, acceptance cases,
   must-red control, source identity, approved worktree path and isolated state
   root with its exact environment/flag binding, Herdr agent name/pane and verified
   pane cwd, and authority. Record this runtime binding before implementation.
2. **IMPLEMENTING:** Start the agent through Herdr and deliver the brief with
   `herdr agent prompt`. The single lane writer captures the red, implements the
   complete increment, and produces green evidence at the final local revision.
3. **READY-FOR-REVIEW:** The lane ends with a `READY-FOR-REVIEW` LEAD-TOKEN block
   in its pane. Quiesce the writer and freeze the exact diff/revision plus its
   witnesses. Do not push or integrate it until a ruling grants that.
4. **REVIEWING:** Read
   [embedded/code-review-pass/PLAYBOOK.md](embedded/code-review-pass/PLAYBOOK.md)
   and its [embedded named-agent contract](embedded/code-review-pass/agents/README.md)
   completely and run its design and correctness lenses against the frozen target.
   The incorporated package contains native Codex and Claude definitions for both
   reviewers. Register them only with authority to modify project agent config,
   then dispatch separate read-only reviewer agents through Herdr when the campaign
   has the authorized capacity. Each reviewer reports in a LEAD-TOKEN block in its
   own pane. Herdr remains the launcher, delivery and lifecycle authority whether
   the roles are natively registered or prompt-loaded.
   Keep their conclusions independent until both return.
5. **REMEDIATING:** The coordinator consolidates confirmed findings, with stable
   per-round IDs, into one ruling comment on the PR; the PR's ruling comments are
   the single finding ledger (the existing ledger until migration). It notes the
   round and open IDs in the PR task, then prompts the original lane writer with
   the comment's URL. Every confirmed in-scope finding, including nits, goes back
   to that writer. A finding may close only as fixed in the same increment, disproved
   with code-cited evidence, or escalated as a ruling that changes the agreed
   design; deferral is not a closing state.
6. **RE-REVIEWING:** Re-run affected tests and the proportionate review required
   by Code Review Pass. Any behavior-changing remediation re-enters both lenses;
   the reviewers inspect the resulting final diff rather than the obsolete one.
7. **DONE:** The coordinator records Mail `accepted` only when both lenses clear
   the final revision, required witnesses are green, and no finding remains open.
   For a shipping lane, also verify the authorized pushed head and delivered PR URL
   before closing the task. A non-shipping outcome uses its explicit completion
   gate. Record the accepted revision and review/delivery evidence. Mail `done`
   alone is not Fleet acceptance. Integration still needs its own authorization.
   When the PR merges, delete its heavy-evidence directory and leave one line
   naming what it proved in the task.

## Execute, witness, review

For a behavior change, witness a meaningful regression control failing on the
actual pre-fix shape and passing after the fix. Preserve the actual failure,
command, inputs, and source identity. An environmental failure is not a product
regression witness, and a control that cannot red on the pre-fix shape is
replaced, never kept as decoration. If a meaningful red is unavailable, disclose
the gap and obtain a ruling rather than manufacture a failure or silently weaken
the gate.

Use the project's test/build recipes and derive scope from what the final diff
can break. Record exact flags, features, environment, revision, and result.
Announce `BUILD:` and start only when authorization and the applicable slot or
runner are available. Do not convert announce-and-run into bypassing a resource
guard, and never self-authorize a hook or gate bypass, throwaway commits
included; disclose and ledger a slip. Use only the runner/lease whose claim line
names your checkout, archive its evidence and any failed-stage originals, then
release it on its deadline whether or not the work finished; never idle a paid
resource waiting for an approval.

Develop against the running assembled product, not only the unit suite. Where the
project builds a binary or service, iterate on a debug/dev build on the shared
runner or lease — never the local workstation, which competes for memory and
disk — with debug assertions ON so invariants fire at the point of violation, run
against real inputs in an isolated state root, and read the actual stdout /
stderr / exit-code / wire surface the unit tests cannot see across the process
boundary. Unit-green is necessary, not sufficient: the assembly, wiring,
lifecycle, exit-code, and telemetry defects live in the assembled binary, so the
inner development loop must exercise it, not defer that to a post-merge or
post-release check. The dev build runs as automation — isolated state, product
telemetry off — so iterating never pollutes analytics or a developer's real
state. Codify that same environment into a pre-release gate afterward; it is the
loop first, the gate second.

The mandatory Code Review Pass verifies code, must-red controls, measured payoff,
and acceptance cases, not just comments or passing CI. A safety claim that holds
only for the inputs a probe could construct is a partial probe, not proof.
Material changes after review invalidate affected witnesses and require
proportionate re-review: a diff-only re-glance when the fold is exactly what was
ruled, both lenses again when it changes behavior. Follow the repository's
integration/stacking rules and the merge-queue order in
[references/coordination.md](references/coordination.md): the coordinator
submits, and an author never self-enqueues or pushes while the change is
testing. This skill does not grant commits, pushes, merges, or history
rewriting. In shared repositories, stage explicit owned paths and inspect the
staged diff; never sweep another agent's work into a commit.

## Coordinator event loop and stops

At startup or recovery, the coordinator calls `agent-mail context` for its group
and reads the open tasks. When the lane watcher flags an idle lane, read that
pane's last LEAD-TOKEN block (`herdr agent read`), verify its claims against the
worktree, PR and CI, and record the decision with the observed task version and a
reason. In an unmigrated campaign, use its register and channel. Do not poll
panes or the register every turn.

When yielding unfinished work, the coordinator records its next step,
dependency/approval hold and review time in a task checkpoint. A watcher alone
does not process events or grant authority. See
[the handover procedure](references/handover-template.md).

Herdr `idle`, `done`, or `blocked` with no LEAD-TOKEN block as the pane's last
output is an exception to investigate, not proof of delivery or an unowned lane.
Prompt the same owner to finish its block.

After a restart, compaction, or suspected transport failure, the coordinator
recovers from the task register before new dispatch, then reconciles open work,
worktrees, PRs and paid resources against it. Read every pane whose state or
identity is uncertain; inventory every pane when the register and live state
contradict each other. Do not keep a second unread-result file. If a lane session
stops mid-report, resume its existing ownership and obtain its LEAD-TOKEN block
before reassigning or closing the pane.

Do not report a lane as deployed merely because a brief was written or a prompt
command returned: capture the new pane/agent handles, verify cwd and ownership,
and observe the prompted agent transition to `working`. When friction in one lane
reveals a defect in the shared tool or platform, preserve the original lane's
scope and route the defect to its own product lane; do not disguise it as an
agent-discipline correction or make the consuming lane own the tool fix.
Correct a disproven ruling visibly and within the hour: post the superseding
ruling as a new PR comment that names the one it replaces, record it in the task
with a reason, update any affected frozen contract, and prompt every party that
held the premise. An unmigrated campaign uses its ruling artifact and existing
register. Credit the evidence.
Reproduce a reported defect on the reporter's exact state, read-only, before
delegating it; a non-reproduction elsewhere is a STOP that names the
confounders, not a fix. Prioritize measured distance to a gate, expected payoff,
dependencies, risk, and cost; ask about preemption when priorities conflict.

Keep authorized gate-advancing work moving, but do not invent filler work,
duplicate investigations, or exceed budgets merely to occupy every slot.
Checkpoints are FYI-and-continue only while the next step remains authorized.

- `STOP-ON-SURPRISE`: evidence contradicts the contract. Preserve the witness;
  pause affected work. Do not silently change inputs, gates, or implementation.
- `READY-FOR-REVIEW`: hand off the named design, protocol, implementation, or
  result in a pane LEAD-TOKEN block and wait if the contract requires acceptance
  before continuing.
- `RULING NEEDED`: name the unresolved decision. Present defensible alternatives
  and a recommendation when there is a real choice; do not invent two options.
- Also stop for a user pause, missing authority (an automated approval boundary
  met inside a lane belongs to the human), a safety/resource limit, or a genuine
  blocker. These boundaries override throughput or continuity goals.

Before a session reset or owner transfer, read and fill
  [references/handover-template.md](references/handover-template.md).
Close only when the agreed gate is satisfied **and** every implementation lane's
final Code Review Pass is clear. The sole alternative is that the user explicitly
ends the assignment. Report residual gaps, artifact locations, integration state,
and resource cleanup. Measurement completion is not implementation completion.
