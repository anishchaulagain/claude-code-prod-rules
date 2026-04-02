# Git rules

## Branch naming
`<type>/<ticket-id>-<short-description>`
Examples:
- `feat/ENG-1234-add-rate-limiting`
- `fix/ENG-5678-null-pointer-on-logout`
- `chore/ENG-9012-upgrade-typescript-5`

## Commit messages — Conventional Commits
```
<type>(<scope>): <imperative description>

[optional body — explain WHY not WHAT]

[optional footer — BREAKING CHANGE, closes #ticket]
```
Types: `feat` | `fix` | `refactor` | `test` | `chore` | `docs` | `perf` | `ci`

## Commit hygiene
- One logical change per commit.
- Commits on a feature branch should be squashed before merge (unless history is meaningful).
- PR size: aim for <400 lines changed. If larger, break it up or add a clear reason in the PR body.

## Never do
- `git push --force` on shared branches
- Commits with message "WIP", "fix", "asdf", or similar
- Committing directly to `main` or `develop`