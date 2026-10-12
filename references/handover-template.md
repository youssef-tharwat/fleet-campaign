# Durable handover

Before a reset or owner transfer, persist the next step where the protocol keeps
it.
- **A lane** hands over in a `HANDOVER READY` LEAD-TOKEN block, the last output in
  its own pane.
- **The coordinator** copies the essentials into the ticket/PR task and its
  checkpoint, and keeps its own continuation in task checkpoints.

A separate handover file is needed only for heavy material, in the campaign's
evidence directory for that PR or ticket. An unmigrated campaign uses its
existing register and channel.

## Content

Include changed or otherwise unrecoverable facts; link existing contracts and
evidence instead of copying them:

- **Identity:** campaign and ticket/PR task, owner, role, repository/worktree,
  branch/revision, allowed file territory and runtime/state-root binding.
- **Actual state:** committed, dirty and untracked work; overlapping edits;
  frozen review target, the ruling comments and open finding IDs, accepted
  revision and PR state.
- **Decision basis:** governing contract, latest rulings (PR comment URLs),
  evidence locations and limitations, explicit holds and missing permissions.
- **Next action:** bounded deliverable, acceptance criteria, first safe step,
  dependency or decision, and when it should be checked again.
- **Live resources:** jobs/session handles, exact lease claim, release deadline,
  budget and who must cancel or release them. A task checkpoint does not release
  a runner; retain its real expiry/cleanup mechanism.
- **Resume checks:** read-only source/resource verification, relevant tool and
  graph limitations, and any operation that must remain paused.

Never include credentials. Preserve raw witnesses in the evidence directory and
name the exact location so a successor need not repeat expensive work.

## A lane hands over

End the pane with one block:

```text
HANDOVER READY — <what is left>
FROM: <lane> / <ticket or PR>
STATE: <worktree> @ <sha> (pushed? dirty?), CI/local evidence status
BODY: numbered identity, actual state, decision basis, next action, live
      resources and resume checks, tagged [measured] [code-cited] [hypothesis]
DISPOSITION: HOLDING on <reset or transfer>
EVIDENCE: <heavy-evidence path, if any>
```

Do not reset yourself; the coordinator authorizes the transition.

## The coordinator records it

1. Read the block and verify it against the worktree, PR and resources.
2. Fetch `task show ID` and update the task with the observed version, a reason
   naming the handover, and the next action.
3. For unfinished coordinator work, checkpoint the task:

   ```sh
   agent-mail --group CAMPAIGN task checkpoint TASK_ID \
     --version TASK_VERSION --key HANDOVER_KEY --file -
   ```

   Supply JSON on stdin with `next_step`, a future UTC Unix `next_check_at`, and
   optional `waiting` and `evidence`, as the installed help describes. Use
   `waiting` for one actual dependency: a same-group task, or an external
   responsible person/role and reason. A human approval hold remains a hold when
   its timer expires.
4. Do not checkpoint after every tool call. A checkpoint neither transfers
   ownership nor accepts work, and a watcher alone does not wake a model.

## Same lane after a reset

After the reset, the coordinator prompts the same lane through Herdr with its
task's next action and the handover block (pasted as data, or the evidence path).
The lane verifies source and resources before continuing.

## Different owner or runtime session

The coordinator confirms the old writer stopped, starts or verifies the
successor's Herdr session and cwd, and prompts it with the handover and the
ruling comment URLs it needs. The coordinator then records the new lane in the
task, with the observed version and a reason. The lane needs no Mail identity, so
nothing transfers in Mail: the coordinator remains the task's writer. Moving the
coordinator role itself to another identity needs an explicit, verified writer
transfer (`task transfer-writer` in 0.15.0); never borrow the old identity.

Resume instruction:

```text
Read the handover block and the ruling comments it names, then the governing
contract. Verify source/resources and the next authorized action. Continue
remaining work. Report contradictions in a LEAD-TOKEN block before mutating
state; preserve holds and completed evidence.
```
