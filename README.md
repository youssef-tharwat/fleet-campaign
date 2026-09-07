# Fleet Campaign

An agent skill for coordinating sustained multi-agent engineering work through
Herdr, with frozen acceptance gates, explicitly owned implementation lanes,
measured evidence, a mandatory Code Review Pass, and durable handovers.

The package incorporates the complete Herdr and Code Review Pass skill playbooks,
so one installation contains the coordination and review procedures it needs.
The Herdr CLI and a Herdr-managed session (`HERDR_ENV=1`) are runtime
prerequisites.

## Install

Install with the open [`skills`](https://github.com/vercel-labs/skills) CLI:

```bash
npx skills add youssef-tharwat/fleet-campaign
```

To install only this skill for a specific agent:

```bash
npx skills add youssef-tharwat/fleet-campaign --skill fleet-campaign --agent codex
```

## Use

Invoke `fleet-campaign` from a Herdr-managed pane when coordinating a sustained
parallel engineering effort or working in an assigned campaign role. It is
intentionally not for isolated implementation tasks or casual inspection.

Every implementation lane follows the same completion loop:

1. Freeze and acknowledge the lane contract.
2. Implement and capture meaningful red/green evidence.
3. Quiesce the lane at `READY-FOR-REVIEW`.
4. Run the incorporated Code Review Pass through independent design and
   correctness lenses.
5. Return confirmed findings to the lane writer, verify remediation, and re-run
   affected lenses.
6. Mark the lane `DONE` only after both lenses clear the final revision.

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
│   │   ├── references/
│   │   └── scripts/
│   └── herdr/
│       └── PLAYBOOK.md
└── references/
    ├── coordination.md
    ├── handover-template.md
    ├── kickoff-briefs.md
    ├── measurement-protocol.md
    └── register-template.md
```

Once installed through the CLI, the skill becomes eligible for discovery on
[`skills.sh`](https://skills.sh/).
