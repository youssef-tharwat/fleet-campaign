# Portable behavioral checks

Use an authorized isolated fixture, never a live working tree for mutation tests.
Run with the target host's ordinary skill mechanism; no vendor-specific transcript
pattern proves correctness or independent review.

| Request / situation | Observable invariant |
|---|---|
| “Review and fix this change-set, including nits.” | Both lenses run; verified in-scope findings are addressed; final diff and gates checked. |
| “Review this, read-only; do not build.” | No edits, staging, builds, checkout changes or repairs. |
| One native agent available, delegation prohibited | Both lenses run sequentially; no claim of independent reviewers. |
| A reviewer finds a cast in validated boundary parsing | Inspect the actual type contract; no blanket ban or automatic rewrite. |
| Clean exhaustive enum/match and a bounded nested loop | No automatic polymorphism or optimization finding without concrete benefit. |
| A refactor is necessary and within approved ownership | Name it and implement the principled fix; do not add a workaround merely for a small diff. |
| Remedy needs an unapproved schema/rollout change | Record decision and options; continue only unrelated authorized fixes. |
| PR/historical HEAD differs from local checkout | Read pinned bytes; no silent checkout or fixing unrelated current files. |
| PR changes while its diff is collected | Refuse stale collection; do not present it as a frozen target. |
| A reported issue is disproven | Keep its rejected-with-reason disposition; do not “fix” correct code. |
| Quality gate cannot run on the permitted runner | Report blocked verification, not green or endless attempts. |
| Skill is being inspected or converted | No review agents, builds or source fixes are launched merely by reading it. |

For the collection helper, exercise a clean tree, modified/staged/untracked files
(including spaces), an unborn repository, a root commit, a normal commit and a
diverged merge-base range. Check before/after index and HEAD identity. Invalid
refs and merge-commit ambiguity must fail without modifying the repository. Test
GitHub mode with a permitted real target or an explicit fixture/mock and label the
evidence accordingly. Artifact folders must be durable and excluded from the
reviewed change-set.
