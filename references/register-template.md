# The campaign register in Agent Mail tasks

The register is a set of Agent Mail **tasks** that only the coordinator writes.
Agent Mail messages, lane mailboxes and lane bindings are not part of the
protocol. Delivery goes through Herdr, lane reports are LEAD-TOKEN blocks in the
lane's pane, and review rulings are PR comments (see
[coordination.md](coordination.md)).

Load `agent-mail --skill` from the installed binary and use its command help. The
examples below were checked against the Agent Mail 0.15.0 help. Fleet defines
acceptance policy; Mail provides versioned tasks, checkpoints and recovery. A
task's creator is its decision writer; here that is always the coordinator.

## Where information belongs

| Information | Authoritative location |
|---|---|
| Campaign goal, gates and current coordination action | A coordinator-owned campaign task, with references to any larger frozen contract |
| Ticket or PR: lane, state, next action, PR URL, accepted revision | One coordinator-owned task per ticket or PR |
| Assignment or brief | A Herdr prompt to the lane; its essentials (worktree, territory, authority) in the task's next action or an update reason |
| Lane report or result | The lane's LEAD-TOKEN block in its own pane; the coordinator copies the outcome into the task |
| Decision and correction | The task update's reason and history, and the current next action |
| Review ruling and the finding ledger | Coordinator comments on the PR, one per round, with stable finding IDs; the task records round, open IDs and the comment URL |
| Coordinator's unfinished work, dependency, approval hold, next review time | A checkpoint on the task |
| Heavy evidence (eval logs, raw runs, a large design) | `<campaign-root>/evidence/<PR-or-ticket>/`, only when needed; deleted when the PR merges, one line kept in the task |

Task scope is bounded and cannot be edited after creation. Freeze a small scope
there; record refinements in versioned next actions and update reasons. A
material change of scope needs an explicitly superseding task and a disposition
for the old one. Do not treat a checkpoint as a new contract.

Task fields are size-bounded. Under 0.10.1, scope was limited to 1,024 UTF-8
bytes, next action to 512, and evidence to 16 references of at most 256 bytes
each; check the installed help for current limits. Link larger material by
repository identity, revision and path, or a PR or comment URL. A reference
does not prove its evidence was verified.

## Set up the campaign

Use a distinct group for a new campaign; verify identity before continuing an
existing one. Only the coordinator needs a Mail identity: initialize the group,
create that identity as the installed guide describes (for example
`agent-mail agent add`), and check it:

```sh
agent-mail init CAMPAIGN
agent-mail --group CAMPAIGN status --check coordinator
```

Lanes are started through Herdr in their assigned worktree and are not bound to
Mail. From the coordinator's identity, create the campaign task and one task per
ticket or PR. The coordinator owns each task too, because a lane has no Mail
identity to notify; name the lane in the scope:

```sh
agent-mail --group CAMPAIGN task create campaign \
  "Campaign goal and acceptance summary; full contract: REPO@REV:PATH" \
  --owner coordinator --next-action "Confirm lane contracts and dispatch approved work"
agent-mail --group CAMPAIGN task create neo-123 \
  "NEO-123 API increment; lane api in WORKTREE; campaign task: campaign" \
  --owner coordinator --next-action "Deliver the brief to lane api through Herdr"
```

Record the approved worktree, isolated state root and binding flag, file
territory, Herdr agent/pane and cwd, dependencies, review owners and authority in
the brief, and their essentials in the task before dispatch.

## Fleet phases and Mail states

Mail accepts only its fixed lowercase lifecycle values. Keep Fleet's more precise
phase in the update reason and current next action; do not pass it as `--state`.

| Fleet phase | Mail state |
|---|---|
| PROPOSED | `open` |
| ACKED | `ready` |
| MEASURING, IMPLEMENTING, REMEDIATING | `active` |
| DESIGN-REVIEW, READY-FOR-REVIEW, REVIEWING, RE-REVIEWING | `review` |
| BLOCKED or a temporary PARKED hold | `blocked`, with a checkpoint naming the dependency/decision |
| Explicit abandonment or supersession | `cancelled`, with the ruling and successor if any |
| Fleet DONE after final acceptance and delivery gates | `accepted`, with the accepted revision and evidence |

Mail `done` means completed without claiming workflow acceptance. It does not
mean Fleet's DONE gate passed. Keep a shipping task open until all of these are
recorded:
- final review;
- required witnesses;
- closed findings;
- authorized push/PR delivery;
- the coordinator's acceptance.

An explicitly scoped non-shipping outcome uses its agreed completion gate. Never
cancel unfinished work just to clear a list.

## Decisions, reviews and findings

Read the current task before deciding. Record the decision with that version and
a reason that names the LEAD-TOKEN block or PR comment it rests on:

```sh
agent-mail --group CAMPAIGN task update neo-123 --version OBSERVED_VERSION \
  --reason "READY-FOR-REVIEW at REV verified (pane block, CI run ID)" \
  --state review --next-action "Await both review lenses on REV" \
  --evidence "https://forge/ORG/REPO/pull/N"
```

Version conflicts require a new read and reconsideration; an uncertain outcome
requires an identical retry. Evidence updates replace the list, so retain
still-required references. A correction names the superseded decision, and every
party that held the premise is prompted.

Each review lens reports in a LEAD-TOKEN block in its own pane, against the frozen
target named in its prompt. The implementation owner stays quiescent during
review. Do not share one lens's conclusions with the other until both return;
Herdr does not enforce that isolation.

The coordinator deduplicates by mechanism and location, then posts one ruling
comment per round on the PR. Each confirmed finding gets a stable ID (for example
`AB1`), with severity, file:line, defect, consequence and remedy. The PR's ruling
comments are the single finding ledger. A later round's comment records each ID
as one of:
- fixed, with its witness;
- disproved with code-cited evidence;
- superseded by an explicit ruling.

A deferred finding stays open and blocks acceptance. The task records the round,
the open IDs and the comment URL. Behavior changes require both lenses again on
the new frozen target. Verify every ID's disposition before `accepted`.

## Recovery and migration

The coordinator uses `agent-mail --group CAMPAIGN context`, then fetches its open
tasks. `task history ID` shows recent decisions, and `task list` with explicit
filters reaches closed tasks. Reconcile the register against panes, worktrees and
PRs before new dispatch. Follow [the handover procedure](handover-template.md)
before a reset or transfer.

An existing register (a file register, or a Mail-message campaign) stays
authoritative until its coordinator performs a cutover:
1. Quiesce status writers.
2. Import current campaign and ticket/PR tasks, with their open finding IDs and
   unresolved obligations.
3. Compare them with the old register.
4. Tell each lane, through Herdr, how it now reports and receives rulings.
5. Record the cutover in the old register, then stop updating it. Preserve it as
   historical evidence.

A Mail-message campaign also stops sending, retires lane bindings, and resolves
or withdraws its open requests. If the cutover cannot be verified, continue the
original authority and explicitly cancel the partial import; never run two live
registers.
