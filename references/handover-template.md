# Durable handover

Write this before resetting a session or transferring an owner. Place it in the
approved campaign storage and link it from the register. Do not retain the only
copy in a terminal or disposable build directory.

1. **Identity and ownership:** campaign/item, assigned role, coordinator/channel,
   repository root, worktree/branch, exact revision, owned and prohibited files.
2. **Actual state:** committed checkpoints, uncommitted and untracked changes,
   other agents' overlapping work, review status, and integration state.
3. **Frozen contract:** goal, design/protocol and register paths; accepted hashes;
   binding rulings/riders; permissions still missing. Separate measured facts
   from assumptions and superseded decisions.
4. **Completed work:** artifacts, raw witnesses, source and binary provenance,
   commands/results, outstanding limitations. Do not ask the successor to rerun
   completed expensive work just to recover context.
5. **Next bounded deliverable:** ordered remaining tasks, acceptance criteria,
   required acknowledgment, and the first safe action. Name what must not resume.
6. **Live resources:** tool/session handles, command or job still running, lease
   claiming root/ID, resource budget, and who owns cancellation/release.
7. **Resume checks:** read-only source/status checks, graph freshness/coverage
   caveats, tool availability, environment needs, relevant build/test policy.
   Never include secret values; name the approved secret-access mechanism.
8. **Disposition:** waiting for reset/transfer, continuing a named operation, or
   blocked on a specific decision. Who confirms the old writer has stopped?

Suggested re-grounding request:

```text
Read the handover file fully and the linked contract before acting. Confirm
your role, actual source/resource state, and the next authorized step. Continue
the remaining work; do not redo finished work. If reality contradicts the
handover, preserve evidence and report the discrepancy before mutating state.
```
