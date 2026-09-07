---
name: fleet-campaign
description: Coordinate a Herdr-managed multi-agent engineering campaign with frozen acceptance gates, single-writer implementation lanes, measurement, and a mandatory Code Review Pass at each lane boundary. Use when orchestrating sustained parallel project work or working in an assigned campaign role. Requires a Herdr-managed session; not for isolated tasks or merely inspecting this skill.
---

# Fleet Campaign

Run evidence-gated increments toward an agreed outcome through Herdr. This skill
incorporates the required Herdr and Code Review Pass playbooks under `embedded/`;
users do not need to install those skills separately. The Herdr CLI and an active
Herdr-managed session are runtime prerequisites.

Before any campaign action, read
[embedded/herdr/PLAYBOOK.md](embedded/herdr/PLAYBOOK.md)
completely and verify `HERDR_ENV=1`. Invoking Fleet Campaign selects Herdr as the
requested coordination mechanism. If the check fails, report that Fleet Campaign
cannot run outside Herdr and stop; do not substitute another transport or pretend
messages were delivered. Creating or reading this skill does not start a campaign.

## Enter the assigned role

Read the project's applicable instructions, the current register, and the assigned
brief before acting. Reuse an existing campaign and coordinator; do not create a
competing register or assume leadership of a lane you were asked to review.

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
3. Record disjoint ownership, dependencies, review owners, evidence paths, and
   build/measurement concurrency limits in the existing action register. Use
   [references/register-template.md](references/register-template.md) if new.
4. Resolve each implementation lane to an approved worktree path and an isolated
   state root before dispatch; every locally built binary runs against that root,
   never the machine's shared store. Attribute a branch, PR, or task to the
   checkout that holds it (`git worktree list`): a label, branch name, pane, or
   message header is not a substitute for the checkout that owns the lane. Do not
   start the lane in the coordinator's working directory.
5. Delegate through Herdr only bounded tasks that can run independently alongside
   useful work.
   Read [references/kickoff-briefs.md](references/kickoff-briefs.md) when assigning
   or accepting a role; fill the relevant brief with real paths and commands.
6. Use the current Herdr session as the authoritative coordination channel. Read
   [references/coordination.md](references/coordination.md) before starting agents,
   sending fleet messages, sequencing integration, or rotating a session.

Durable artifacts belong in an approved project workspace, not a disposable
temporary directory or terminal history. Keep one authority for each campaign
fact: the register owns status and rulings; evidence files own observations.

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

Every implementation lane follows this loop. Record each transition and its
evidence in the action register; implementation and local green tests are not the
end of a lane.

1. **ACKED:** Freeze the lane's design, file territory, acceptance cases,
   must-red control, source identity, approved worktree path and isolated state
   root with its exact environment/flag binding, Herdr agent name/pane and verified
   pane cwd, and authority. Record this runtime binding before implementation.
2. **IMPLEMENTING:** Dispatch the brief through Herdr. The single lane writer
   captures the red, implements the complete increment, and produces green
   evidence at the final local revision.
3. **READY-FOR-REVIEW:** Quiesce the writer and freeze the exact diff/revision plus
   its witnesses. Do not push or integrate it yet.
4. **REVIEWING:** Read
   [embedded/code-review-pass/PLAYBOOK.md](embedded/code-review-pass/PLAYBOOK.md)
   completely and run its design and correctness lenses against the frozen target.
   Dispatch separate read-only reviewer agents through Herdr when the campaign has
   the authorized capacity. Keep their conclusions independent until both return.
5. **REMEDIATING:** The coordinator consolidates one finding ledger and routes
   every confirmed in-scope finding, including nits, back to the original lane
   writer. A finding may close only as fixed in the same increment, disproved
   with code-cited evidence, or escalated as a ruling that changes the agreed
   design; deferral is not a closing state.
6. **RE-REVIEWING:** Re-run affected tests and the proportionate review required
   by Code Review Pass. Any behavior-changing remediation re-enters both lenses;
   the reviewers inspect the resulting final diff rather than the obsolete one.
7. **DONE:** Mark the lane complete only when both lenses clear the final revision,
   required witnesses are green, the finding ledger has no unresolved item, and
   the coordinator records the review evidence. Integration still needs its own
   authorization.

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

On each Herdr report: reconcile evidence against the gate; answer every open
decision; record the ruling and the riders that name its unsafe direction; route
the next useful independent task; tell the user what changed in plain language.
Correct a disproven ruling visibly and within the hour, in the register and on
the wire, to every party that held the premise, and credit the evidence.
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
  result artifact and wait if the contract requires acceptance before continuing.
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
