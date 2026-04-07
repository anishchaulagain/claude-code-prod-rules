# Testing rules

## Test pyramid (target ratios)
- **Unit tests**: 90% — fast, isolated, mock external deps
- **Integration tests**: 5% — test across boundaries (DB, API, service)
- **E2E tests**: 5% — critical user journeys only

## Coverage thresholds (enforced in CI)
- Statements: ≥90%
- Branches: ≥85%
- Functions: ≥90%

## File & Folder conventions
- **Unit tests**: Colocate with source files. `src/user.ts` -> `src/user.test.ts` (or `.spec.ts`).
- **Integration tests**: Place in `tests/integration/`. Name files `[feature].integration.test.ts`.
- **E2E tests**: Place in `tests/e2e/`. Name files `[feature].e2e.test.ts`.
- **Support files**: Place factories in `tests/factories/` and global mocks in `tests/mocks/`.

## Test description naming
```
describe('<ModuleName>', () => {
  describe('<methodName>', () => {
    it('should <expected behavior> when <condition>', () => { ... })
  })
})
```

## Rules
- Tests must be deterministic. No `Date.now()`, `Math.random()`, or network calls without mocking.
- Each test has exactly one assertion focus. Multiple `expect()` calls are fine when they test the same concept.
- Use `beforeEach` for setup, not `beforeAll` (avoids state bleed).
- Mock at the boundary (module interface), not deep inside implementation.
- Factories over fixtures for test data — keep them in `tests/factories/`.
- A test that always passes is worse than no test. Assert on the thing that can break.

## Test timeouts
- Unit tests: 5s max per test (default in CI config).
- Integration tests: 30s max per test.
- E2E tests: 60s max per test.
- If a test needs more time, justify with a comment — don't just raise the timeout.

## Snapshot testing policy
- Snapshots are allowed **only** for serializable output (JSON responses, rendered component trees).
- **Never** snapshot entire HTML pages — too brittle, too noisy on diffs.
- Every snapshot must be reviewed when updated. Run `--updateSnapshot` intentionally, not reflexively.
- If a snapshot breaks on every change, replace it with explicit assertions.

## Flaky test protocol
- A test that fails intermittently is **worse than no test** — it erodes trust.
- On first observation: annotate with `// FLAKY: <ticket-id>` and create a ticket.
- Quarantine: move to a `tests/__quarantine__/` directory within 24 hours.
- Fix or delete within 1 sprint. Quarantined tests do not run in CI.
- Never retry flaky tests as a fix. Find the root cause (timing, shared state, external dep).

## Test data management
- Use factories (`tests/factories/`) to create test data. Never inline magic values.
- Integration tests must clean up after themselves (use transactions or truncation).
- Never rely on database seed data — tests must set up their own state.
- Use deterministic IDs in factories (e.g., UUIDs from a seed) for reproducibility.

## Mocking boundaries

### What to mock
- External HTTP APIs → use `msw` or `nock`
- Database → mock the repository layer, not the ORM itself
- File system → mock `fs` operations at the service boundary
- Time → use `vi.useFakeTimers()` / `jest.useFakeTimers()`
- Environment variables → set in `beforeEach`, restore in `afterEach`

### What NOT to mock
- The module you're testing (defeats the purpose)
- Simple pure functions (just call them)
- Type definitions or interfaces

## CI-specific behavior
- Always run tests with `--ci` flag (disables interactive watch mode).
- Enable parallel test execution where possible (`--pool=threads` in Vitest).
- Generate coverage reports in CI (Cobertura/LCOV format for PR comments).
- Fail the pipeline if coverage drops below thresholds.
- Cache `node_modules` to speed up CI test runs.

## Contract / API testing
- For services that expose REST APIs: validate response schemas against OpenAPI spec.
- For inter-service communication: use consumer-driven contract tests (Pact or equivalent).
- Contract tests run in the provider's CI pipeline, not just the consumer's.

## Performance testing
- Critical endpoints must have baseline response time assertions in integration tests.
- Use `autocannon` or `k6` for load testing before major releases.
- Performance test results are tracked over time — regression is a test failure.

## What NOT to do in tests
- ❌ Test implementation details (private methods, internal state)
- ❌ Use `sleep()` / `setTimeout()` for async waiting — use `waitFor()` or polling utilities
- ❌ Write tests that depend on execution order
- ❌ Copy-paste test setups — extract to factories and helpers
- ❌ Assert on error messages from third-party libraries (they change on upgrades)
- ❌ Leave `describe.only` / `it.only` / `.skip` in committed code