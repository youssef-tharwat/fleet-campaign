# Fleet Campaign

An agent skill for coordinating sustained multi-agent engineering work through
Herdr, with frozen acceptance gates, explicitly owned implementation lanes,
measured evidence, a mandatory Code Review Pass, and durable handovers.

The package incorporates the complete Herdr and Code Review Pass playbooks plus
native Codex and Claude definitions for the two review agents, so one installation
contains the coordination and review procedures it needs. The Herdr CLI and a
Herdr-managed session (`HERDR_ENV=1`) are runtime prerequisites.

Campaigns run on a hybrid protocol:
- **Delivery:** Herdr prompts carry briefs, ruling notices and pings.
- **Register:** [Agent Mail](https://github.com/youssef-tharwat/agent-mail)
  **tasks**, one per ticket or PR, written only by the coordinator. Mail messages
  and lane bindings are not used.
- **Lane reports:** one LEAD-TOKEN block, the last output in the lane's pane.
- **Review rulings:** comments on the PR.
- **Heavy evidence:** kept only when needed, and deleted when the PR merges.

The integration examples were checked against the Agent Mail 0.15.0 help; load
the guide from the installed binary with `agent-mail --skill`.

## Install

Install with the open [`skills`](https://github.com/vercel-labs/skills) CLI:

```bash
npx skills add youssef-tharwat/fleet-campaign
```

To install only this skill for a specific agent:

```bash
npx skills add youssef-tharwat/fleet-campaign --skill fleet-campaign --agent codex
```

For a new local campaign, install the Agent Mail plugin and its small agent
skill separately. Only the coordinator needs a Mail identity; lanes need none:

```sh
herdr plugin install youssef-tharwat/agent-mail
npx skills add youssef-tharwat/agent-mail --skill agent-mail -g
```

## Use

Invoke `fleet-campaign` from a Herdr-managed pane when coordinating a sustained
parallel engineering effort or working in an assigned campaign role. It is
intentionally not for isolated implementation tasks or casual inspection.

Every implementation lane follows the same completion loop:

1. Freeze and acknowledge the lane contract.
2. Implement and capture meaningful red/green evidence.
3. Report a `READY-FOR-REVIEW` LEAD-TOKEN block in the lane's pane and quiesce.
4. Run the incorporated Code Review Pass through independent design and
   correctness lenses. Herdr launches the reviewers, and each reports in its own
   pane.
5. Post confirmed findings as a ruling comment on the PR, return them to the lane
   writer through Herdr, verify remediation, and re-run affected lenses.
6. Record Mail `accepted` only after both lenses clear the final revision and
   the lane's delivery gates pass, including an authorized pushed branch and PR
   for shipping work.

Mail tasks hold current coordination state and decisions; the coordinator is
their only writer. Files remain useful for larger frozen contracts and for heavy
evidence until merge. See the
[register contract](references/register-template.md),
[delivery and report contract](references/coordination.md), and
[how Fleet uses Agent Mail](references/agent-mail-gaps.md).

The entry point is [`SKILL.md`](SKILL.md). Supporting templates and protocols
live in [`references/`](references/).

## Repository layout

```text
.
├── SKILL.md
├── agents/
│   └── openai.yaml
├── embedded/
│   ├── code-review-pass/
│   │   ├── PLAYBOOK.md
│   │   ├── agents/
│   │   │   ├── codex/
│   │   │   └── claude/
│   │   ├── references/
│   │   └── scripts/
│   └── herdr/
│       └── PLAYBOOK.md
└── references/
    ├── agent-mail-gaps.md
    ├── coordination.md
    ├── handover-template.md
    ├── kickoff-briefs.md
    ├── measurement-protocol.md
    └── register-template.md
```

Once installed through the CLI, the skill becomes eligible for discovery on
[`skills.sh`](https://skills.sh/).

The `skills` CLI keeps custom-agent files inside the installed skill; current
Codex and Claude releases discover custom agents only from their own agent
directories. With permission to add project configuration, register the embedded
reviewers from the target repository before starting their Herdr panes:

```bash
fleet_skill_dir="<installed-fleet-campaign-directory>"
bash "$fleet_skill_dir/embedded/code-review-pass/scripts/register-agents.sh" \
  --host all --project-root "$PWD"
```

Registration is idempotent and preserves conflicting local definitions unless
`--force` is explicitly supplied. See
[`embedded/code-review-pass/agents/README.md`](embedded/code-review-pass/agents/README.md)
for native names and Herdr dispatch patterns.
