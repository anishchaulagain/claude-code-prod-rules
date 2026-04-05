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