# Code Review Pass

Review, consolidate, remediate, verify. Keep every distinct finding visible, but
verify it before changing code. Respect the user's target, write scope, resource
limits and integration permissions. Do not infer permission to commit, stage,
push, post comments, create worktrees or provision runners.

When Fleet Campaign invokes this incorporated playbook, its coordinator owns the
finding ledger and routes approved remediation to the original implementation
lane. Reviewers remain read-only; they do not fix their own findings.

## 1. Freeze the target

State the target: PR, commit, merge-base range, staged changes, or current working
tree. Default to the working tree only when no other target was supplied. Read
applicable project instructions and inspect existing changes before writes.

When evidence-file writes are permitted, use
[`scripts/collect-changes.sh`](scripts/collect-changes.sh) from this incorporated
skill, with an approved durable output directory outside the repository or under
an already-ignored directory. Resolve the installed Fleet Campaign directory and
invoke the helper from its incorporated location:

```sh
review_pass_dir="<fleet-campaign-skill-dir>/embedded/code-review-pass"
bash "$review_pass_dir/scripts/collect-changes.sh" --output-dir "$REVIEW_OUTPUT" working
bash "$review_pass_dir/scripts/collect-changes.sh" --output-dir "$REVIEW_OUTPUT" staged
bash "$review_pass_dir/scripts/collect-changes.sh" --output-dir "$REVIEW_OUTPUT" commit <sha>
bash "$review_pass_dir/scripts/collect-changes.sh" --output-dir "$REVIEW_OUTPUT" range <base>..<head>
bash "$review_pass_dir/scripts/collect-changes.sh" --output-dir "$REVIEW_OUTPUT" pr <number-or-url>
```

The helper uses Git, plus `gh` only for GitHub PRs. It captures a diff and target
identity without changing the index, branches or checkout. If the helper is
unavailable or artifact writes are not permitted, use equivalent read-only host
tools and report the same identities and limitations without creating files. No
changes means stop; collection failure does not mean a clean review.

Inspect relevant complete files, callers and contracts at the reviewed revision.
A historical/PR diff does not prove the current checkout contains those bytes.
Read immutable blobs or use an already-authorized matching checkout; ask before
switching the user's tree. Refresh the snapshot if its target changes.

## 2. Run the two lenses

This playbook embeds two named custom reviewers in host-native formats:

- `fleet-best-practices-reviewer` for Claude and
  `fleet_best_practices_reviewer` for Codex: design, duplicated knowledge,
  ownership boundaries, clarity and project idioms.
- `fleet-senior-code-reviewer` for Claude and
  `fleet_senior_code_reviewer` for Codex: correctness, regressions, contracts,
  concurrency, persistence and production risks.

Read [agents/README.md](agents/README.md), then read the two definitions for the
selected host completely before dispatch. They are self-contained custom-agent
configurations, not abbreviated reviewer notes. Register them in the reviewed
project only when the campaign has authority to write project agent
configuration. Native registration is optional: when it is unavailable, use the
matching Claude Markdown definition as the complete portable role prompt.

When Fleet Campaign has authorized reviewer capacity, use Herdr to dispatch two
separate read-only review agents. Native custom-agent selection configures the
reviewer role; Herdr remains the required launcher, message transport and
lifecycle authority. Pass each reviewer the exact root/revision/diff, relevant
instructions, evidence gaps, and a read-only assignment. Do not share the other
lens's conclusions before both return. Inherit the user's model choices; no
particular model, vendor, or graph service is required.

If the campaign lacks two authorized reviewer slots, perform both lenses
sequentially and label them as one agent's two passes, not independent reviews.
Never skip a lens. Restrict reviewer tools to read-only operations where the host
supports it; the coordinator owns the ledger and routes approved remediation.
Reviewers do not recursively launch teams.

## 3. Consolidate and rule

Keep one finding ledger, deduplicated by mechanism and location, ordered by
severity: blocker, high, medium, low, nit. For each entry record:

```text
ID · severity · category · file:line
Problem: concrete defect or violated project convention, with evidence
Consequence: failure scenario or maintenance cost; confidence/unknowns
Remedy: principled correction and required scope
Disposition: confirmed / fixed / rejected-with-reason / needs-decision
Verification: regression control or other relevant check
```

The coordinator routes every confirmed in-scope finding, including nits, to the
original implementation lane. Preserve the lane's ownership and authority
boundaries; never let a reviewer become a second writer.

## 4. Remediate and re-review

The implementation lane verifies each finding before changing code, implements
the principled in-scope correction, and reruns the affected regression controls.
Remedies that exceed the lane's approved design or ownership become
`RULING NEEDED`; do not silently widen the task.

Material changes after review invalidate affected witnesses. A behavior-changing
remediation re-enters both review lenses. Keep every finding in the ledger with
its final disposition rather than deleting disproved or fixed entries.

Report remaining risks and exact verification results. State whether reviews were
independent. Leave changes unstaged/uncommitted unless separately authorized; a
clean review does not mean the Git working tree has no changes.

For maintaining this incorporated playbook, use
[references/validation-cases.md](references/validation-cases.md). No
client-specific trigger detector or automatic launch of paid agents is required.
