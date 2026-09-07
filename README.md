# Fleet Campaign

An agent skill for coordinating sustained multi-agent engineering work through
frozen acceptance gates, explicitly owned implementation lanes, measured
evidence, independent review, and durable handovers.

The skill is agent-, model-, language-, and transport-neutral. It does not
assume a particular orchestration tool, graph server, build runner, or Git
workflow.

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

Invoke `fleet-campaign` when coordinating a sustained parallel engineering
effort or when working in an assigned campaign role. It is intentionally not
for isolated implementation tasks or casual inspection.

The entry point is [`SKILL.md`](SKILL.md). Supporting templates and protocols
live in [`references/`](references/).

## Repository layout

```text
.
├── SKILL.md
├── agents/
│   └── openai.yaml
└── references/
    ├── coordination.md
    ├── handover-template.md
    ├── kickoff-briefs.md
    ├── measurement-protocol.md
    └── register-template.md
```

Once installed through the CLI, the skill becomes eligible for discovery on
[`skills.sh`](https://skills.sh/).
