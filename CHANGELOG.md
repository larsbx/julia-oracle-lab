# Changelog

## 0.1.0 — unreleased

- Established authority-safe outcomes: `agrees`, `disagrees`, `inconclusive`, and `oracle_error`.
- Added mandatory domain-claim and authoritative-checker bindings.
- Added a closed oracle registry schema and runtime fail-closed validation.
- Implemented canonical BigInt byte encoding bound to `finite-math-kernels`.
- Added authoritative golden vectors and a planted one-bit disagreement fixture.
- Documented legacy NLAP migration provenance without making the migrating name a durable identity.
- Added Woodpecker CI and Git-based Julia installation instructions.

The release remains untagged until Julia 1.11 tests, authoritative Mojo replay, licensing, and Forgejo reconciliation are complete.
