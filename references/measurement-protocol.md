# Stamped measurement protocol

Read this before attributing a performance problem or preparing a campaign
benchmark. Reuse the project's existing fixture builders, profilers, and gates
where they fit. State what each instrument cannot show. Do not add engine
instrumentation or substitute workloads without the required authority.

## Protocol before runs

For every scenario specify:

- **Question and quantity:** what hypothesis or gate the run tests; exact metric,
  units, timing boundary, counted population, and success/refusal criteria.
- **Input:** pinned source/corpus and fixture hashes, exact semantic patch or
  workload, expected changed paths/results, and how trials restore state.
- **Invocation:** exact command, working directory, flags, relevant environment,
  credentials policy, and whether timing includes startup, setup, or a wrapper.
- **Binary provenance:** full source revision, dirty-tree/patch hashes if any,
  binary or artifact digest, actual build profile/features/toolchain/allocator.
  A generic optimized/debug label is not the complete build configuration.
- **Environment:** runner class, architecture, CPU/RAM, applicable container
  limits, competing work/load, disk, and any resource/concurrency restrictions.
- **Cache state:** which caches and stores are warm/cold/absent; exact reset and
  warmup steps; whether filesystem/page caches are controlled or simply observed.
- **Replication:** sample count, ordering, independent trials versus repeats
  nested within a trial, intended distribution summary, and known confounders.
- **Capture and ownership:** raw output, receipts/profiles, exit status, timestamps,
  checksums, evidence location, and who releases the assigned runner on failure.

Freeze the measured source, inputs, and protocol before the run. Record a moving
branch tip separately; do not silently chase it and call unlike runs equivalent.
An implementation witness, in contrast, must cover the final implementation
revision required by the project's review/ship policy.

If a production corpus cannot be used safely, obtain approval for a public or
synthetic proxy. Record scale and topology differences alongside the results,
not only in the protocol. Never copy private corpora, stores, or credentials to
an unapproved runner to make a measurement possible.

## Distinguish different questions

A cold forced rebuild, a warm incremental refresh, a first semantic-edit read,
an identical dirty repeat, and a cross-file cascade are different cells. Choose
the cells needed for the actual gate; a cold benchmark cannot answer what one
legitimate warm refresh costs.

Keep a normal production-path observation separate from a diagnostic replay that
bypasses caching, retains extra data, or enables instrumentation. Each gets its
own provenance and timing. Never attach diagnostic counts to an unprofiled time
as if both came from one invocation. Cross-check paths/counts explicitly when
using one observation to interpret another.

Name counts by quantity: changed inputs, selected candidate events, distinct
candidate files, red/affected closure, promoted files, recomputation events,
replacement scopes, or output entities. Retain identities and round-by-round
witnesses as well as counts. Preserve duplicate events; report distinct unions
additionally. A repository-wide scope is not one file. Missing hit/miss counters
are unavailable, not zero, and cannot be inferred from elapsed time.

## Validate the instrument

Dry-run the adapter and exercise a meaningful failure/refusal path before trusting
its numbers. Require nonempty numeric records, expected units, successful process
exit, and nonempty/intended semantic output. Use the existing load admission
policy; absent required observations fail closed, rather than producing a quiet
machine claim. Load qualification does not certify correctness or release parity.

Record wall and CPU/on-executor time separately. Concurrent/nested spans cannot
be summed as exclusive costs. RSS is not live heap; boundary RSS or an RSS delta
is not a per-phase high-water mark. Instrument retention and allocator behavior
can influence residency. Do not infer a leak or unnecessary retention without
evidence that distinguishes those possibilities. Do not reconcile disagreeing
instruments by silently changing units or choosing the convenient number.

## Archive and report

Archive raw observations with the run, before releasing a disposable runner.
Keep original-byte and compressed-file hashes when compressing large artifacts.
Validate returned bytes, report capture losses, and release only the lease you
own. A retry after partial execution is a new recorded attempt unless the
protocol establishes a safe resume; transport retry must not duplicate a workload.

Separate measured, code-cited, historical, and hypothetical claims. Report all
trials and spread; do not present a handful of trials as a stable tail-latency
estimate. Preserve rejected samples and their reason. For each candidate cause
report supported, contradicted, or unresolved, with its limitations. A successful
measurement handoff neither implements a fix nor proves the release gate passed.
