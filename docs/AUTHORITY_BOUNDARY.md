# Authority boundary

Julia Oracle Lab independently recomputes results, generates witnesses, runs differential tests, and hosts research spikes.

## The lab's acceptance boundary: registry admission

The lab owns one acceptance boundary. `validate_registry_entry` and `validate_binding` in `src/JuliaOracleLab.jl` are its single implementation: they accept an oracle into `registry/oracles.toml` only when every critical binding field is present and known, and reject it otherwise. Missing or unknown critical binding data fails closed.

## Oracle results: evidence, never acceptance of another repository's claim

Every durable oracle binds to a domain claim, an authoritative checker repository, and a boundary identifier. For that claim the lab stays outside the checker's trusted boundary, and an oracle result is one of:

- `agrees`
- `disagrees`
- `inconclusive`
- `oracle_error`

The lab never emits `accepted`, `proved`, `authorized`, or a deployment verdict about a domain claim it does not own; a registry entry that claims such authority, or widens the result vocabulary, is rejected at admission. Disagreement creates an investigation obligation; it does not transfer authority to Julia.

Forgejo remains canonical source and merge authority where configured. Woodpecker remains canonical CI. GitHub is a review mirror.
