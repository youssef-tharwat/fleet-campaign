---
name: fleet-campaign
description: Coordinate a multi-agent engineering campaign with frozen acceptance gates, single-writer implementation lanes, measurement, independent review, and a durable action register. Use when orchestrating sustained parallel project work or working in an assigned campaign role; not for isolated tasks or merely inspecting this skill.
---

# Fleet Campaign

Run evidence-gated increments toward an agreed outcome. This skill is agent-,
model-, language-, and transport-neutral. Use available, authorized capabilities;
do not assume a particular agent CLI, graph server, build runner, or Git workflow.
Creating or reading this skill does not start a campaign.

## Enter the assigned role

Read the project's applicable instructions, the current register, and the assigned
brief before acting. Reuse an existing campaign and coordinator; do not create a
competing register or assume leadership of a lane you were asked to review.

| Role | Responsibility | Boundary |
|---|---|---|
| Coordinator / design owner | Gates, sequencing, rulings, ownership, register, integration decisions | Does not concurrently implement in a lane; integration still requires the user's authority |
| Implementation lane | One approved increment in an explicitly owned file territory | One writer per worktree/branch; no edits to another lane's files |
| Measurement / design agent | Protocols, measured evidence, proposed designs, acceptance fixtures | Code checkouts read-only unless separately granted implementation scope; write only assigned artifacts |
| Reviewer | Independent check of the final diff, risks, and witnesses | No edits, staging, checkout, push, or automatic repair of the reviewed tree |

For a planning-only request, stop at the plan. Without parallel-agent capability
or permission, offer a sequential execution plan with the same evidence gates;
do not pretend independent review occurred. Respect user/host model choices and
resource budgets instead of prescribing vendors or a fixed fleet size.

## Establish the contract

1. Freeze measurable done/release gates, non-goals, correctness invariants, source
   identity, and what would require a new ruling. Name the next deliverable.
2. Resolve authority separately for writing files, creating worktrees, running
   workloads, provisioning runners, committing, pushing, opening PRs, and merging.
   An assignment or `GO` only authorizes the scope it actually names.
3. Record disjoint ownership, dependencies, review owners, evidence paths, and
   build/measurement concurrency limits in the existing action register. Use
   [references/register-template.md](references/register-template.md) if new.
4. Delegate only bounded tasks that can run independently alongside useful work.
   Read [references/kickoff-briefs.md](references/kickoff-briefs.md) when assigning
   or accepting a role; fill the relevant brief with real paths and commands.
5. Select the existing, authorized coordination channel. Read
   [references/coordination.md](references/coordination.md) before starting agents,
   sending fleet messages, or rotating a session. Herdr is an optional adapter.

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
  consequences; and measurable acceptance criteria. Obtain the required ack.
- Preserve a principled fix when it needs a refactor. Name the refactor and its
  boundaries in the design and review handoff. Split work into complete
  increments; do not preserve a defective design just to minimize the diff.

## Execute, witness, review

For a behavior change, witness a meaningful regression control failing before
the fix and passing after it. Preserve the actual failure, command, inputs, and
source identity. An environmental failure is not a product regression witness.
If a meaningful red is unavailable, disclose the gap and obtain a ruling rather
than manufacture a failure or silently weaken the gate.

Use the project's test/build recipes and derive scope from what the final diff
can break. Record exact flags, features, environment, revision, and result.
Announce `BUILD:` and start only when authorization and the applicable slot or
runner are available. Do not convert announce-and-run into bypassing a resource
guard. Use only your assigned runner/lease, preserve evidence, then release it.

Review the final local diff before an authorized push. Reviewers verify code,
must-red controls, measured payoff, and acceptance cases, not just comments or
passing CI. Material changes after review invalidate affected witnesses and
require proportionate re-review. Follow the repository's integration/stacking
rules; this skill does not grant commits, pushes, merges, or history rewriting.
In shared repositories, stage explicit owned paths and inspect the staged diff;
never sweep another agent's work into a commit.

## Coordinator event loop and stops

On each report: reconcile evidence against the gate; answer every open decision;
record the ruling and any riders; route the next useful independent task; tell
the user what changed in plain language. Correct disproven rulings visibly and
credit the evidence. Prioritize measured distance to a gate, expected payoff,
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
- Also stop for a user pause, missing authority, a safety/resource limit, or a
  genuine blocker. These boundaries override throughput or continuity goals.

Before a session reset or owner transfer, read and fill
  [references/handover-template.md](references/handover-template.md).
Close only when the agreed gate is satisfied or the user explicitly ends the
assignment. Report residual gaps, artifact locations, integration state, and
resource cleanup. Measurement completion is not implementation completion.
