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

## Revert protocol
When a merge breaks production:
1. **Revert first, investigate later.** Don't try to hotfix forward under pressure — revert the merge commit.
2. Use `git revert -m 1 <merge-commit-sha>` to revert a merge. The `-m 1` specifies the mainline parent.
3. The revert commit message must explain: what was reverted, why, and link to the incident ticket.
4. After reverting, the original branch must be re-merged as a **new PR** (not force-pushed) to preserve history.

## Tags & releases
- Use semantic versioning: `vMAJOR.MINOR.PATCH` (e.g., `v2.1.0`)
- Tag format: `v<version>` — annotated tags only (`git tag -a v1.2.0 -m "Release v1.2.0"`)
- Breaking changes increment MAJOR. New features increment MINOR. Bug fixes increment PATCH.
- Every tag must correspond to a passing CI build on `main`.
- Maintain a `CHANGELOG.md` — update it before tagging.

## Protected branch rules (configure in GitHub/GitLab)
- `main` and `develop` are protected.
- Require at least 1 approving review before merge.
- Require status checks to pass (CI pipeline).
- Require branches to be up-to-date before merge.
- Disable force pushes and branch deletion.
- Require signed commits (if team policy supports it).