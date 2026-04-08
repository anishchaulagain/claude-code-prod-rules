# How to Use These Rules in Claude Code

## Method 1: Copy Into Your Project (Recommended)

Copy this entire setup into the root of any project you want Claude Code to follow these standards in.

```bash
# From your target project root
git clone https://github.com/anishchaulagain/claude-code-prod-rules.git /tmp/rules

# Copy the core files
cp /tmp/rules/CLAUDE.md ./CLAUDE.md
cp -r /tmp/rules/.claude ./.claude
cp -r /tmp/rules/rules ./rules
cp -r /tmp/rules/agents ./agents
cp -r /tmp/rules/workflows ./workflows
cp -r /tmp/rules/validators ./validators
cp -r /tmp/rules/docs ./docs
cp -r /tmp/rules/templates ./templates
```

Claude Code automatically reads `CLAUDE.md` from the project root and `.claude/settings.json` on every session start. No configuration needed.

---

## Method 2: Global Rules (~/.claude)

If you want these rules active in **every** project without copying:

```bash
# Set global CLAUDE.md
cp CLAUDE.md ~/.claude/CLAUDE.md

# Set global settings
cp .claude/settings.json ~/.claude/settings.json
```

> ⚠️ **Tradeoff**: Global rules apply everywhere, which may conflict with project-specific needs. Method 1 is better for team projects.

---

## Method 3: Import as Git Submodule

Keep the rules repo synced across multiple projects:

```bash
# From your project root
git submodule add https://github.com/anishchaulagain/claude-code-prod-rules.git .claude-rules

# Then symlink what you need
ln -s .claude-rules/CLAUDE.md ./CLAUDE.md
cp -r .claude-rules/.claude ./.claude
```

---

## How Each Component Gets Used

### `CLAUDE.md` — Loaded Automatically
Claude Code reads this on **every conversation start**. It sets:
- Claude's identity and operating principles
- Code quality non-negotiables
- Pre-task checklist
- References to all rules, workflows, and agents

**You don't invoke this** — it's always active.

---

### `rules/` — Always-On Context
All files listed in `.claude/settings.json` → `context_files` are loaded automatically:

```json
"context_files": [
  "rules/always-on.md",
  "rules/git.md",
  "rules/testing.md",
  "rules/security.md",
  ...
  "rules/stacks/typescript.md" // Dynamically injected based on stack!
]
```

**You don't invoke these** — Claude reads them and follows them in every response. Note that `init.sh` automatically tailors this list to your codebase's tech stack (e.g. injecting `rules/stacks/python.md` instead of TypeScript).

---

### `.claude/commands/` — Slash Commands

These are the most powerful feature. Use them by typing the command in Claude Code:

#### `/pr` — Raise a Pull Request
```
> /pr
```
Claude will:
1. Run `git diff` to understand scope
2. Run pre-commit checks
3. Grade the PR checklist (block on failures)
4. Generate a formatted PR with title, description, checklist

#### `/review` — Self-Review Before Committing
```
> /review
```
Claude will review staged changes against 20+ criteria across correctness, code quality, types, tests, security, and performance. Outputs a pass/fail table.

#### `/ticket` — Generate an Engineering Ticket
```
> /ticket Add rate limiting to public API endpoints
```
Claude generates a full ticket with title, priority, acceptance criteria, estimate, and technical notes.

---

### `agents/` — Specialized Personas

Invoke agents by asking Claude to assume the role:

#### Planner
```
> Act as the planner agent. Break down this feature: "Add user notifications system"
```
Gets you a risk assessment + ordered task list with complexity estimates.

#### Reviewer
```
> Act as the reviewer agent. Review the changes in src/controllers/user.ts
```
Gets you a code review with BLOCKER/MAJOR/MINOR/NIT severity levels.

#### Test Writer
```
> Act as the test writer agent. Write tests for src/services/auth.ts
```
Gets you exhaustive test coverage: happy path → edge cases → error cases → regression.

#### Debugger
```
> Act as the debugger agent. Users are getting 500 errors on /api/orders
```
Gets you a systematic hypothesis-driven investigation instead of random guessing.

---

### `workflows/` — Step-by-Step Processes

Reference workflows when starting a task:

#### Project Onboarding & Initialization
```
> Follow workflows/onboarding.md
```
Claude scans your current codebase, detects the tech stack (React, Python, Postgres, etc.), and automatically rewrites the rules and documentation to fit your project natively.

#### New Feature
```
> Follow workflows/feature.md to implement ENG-1234: Add rate limiting
```
Claude follows the 8-step process: understand → plan → branch → implement → test → commit → PR → done.

#### Bug Fix
```
> Follow workflows/bugfix.md to fix ENG-5678: Null pointer on logout
```
Claude writes a failing test FIRST, then finds root cause, then fixes minimally.

#### Hotfix (Production Emergency)
```
> Follow workflows/hotfix.md — users can't log in, it's P0
```
Claude branches from main, makes minimal fix, expedited PR.

#### Refactor
```
> Follow workflows/refactor.md to extract validation from UserController
```
Claude ensures test coverage exists first, then refactors incrementally.

#### Database Migration
```
> Follow workflows/database-migration.md to add an email_verified column to users
```
Claude checks backward compatibility, writes safe migration, plans backfill.

---

### `validators/` — Quality Gates

#### Pre-commit Hook
Run manually or wire into git hooks:

```bash
# Manual — full check
sh validators/pre-commit.sh

# Manual — staged files only (faster)
sh validators/pre-commit.sh --staged

# As a git hook
cp validators/pre-commit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

Runs: TypeScript check → ESLint → Prettier → security audit → tests (auto-detects Vitest or Jest).

#### Rule File Linter
Validates that all cross-references between CLAUDE.md, settings.json, and rule/agent/workflow files are intact:

```bash
sh validators/lint-rules.sh
```

Run this after adding or renaming any rule, workflow, or agent file.

#### PR Checklist
Used automatically by the `/pr` command. Claude grades each item and blocks if any BLOCKER item fails.

---

### `templates/` — Project Scaffolds

#### `.env.example`
Copy into your project root as a starting point for environment variables:

```bash
cp templates/.env.example .env.example
```

Documents common vars (database, auth, external APIs) without values. Referenced by `rules/always-on.md` and `rules/security.md`.

---

### `docs/` — Project Documentation

#### `docs/architecture.md`
Customize this for your project. Claude reads it every session to understand your system structure, tech stack, and key data flows.

#### `docs/coding-standards.md`
Project-specific naming conventions, import order, function patterns, and domain vocabulary. Supplements the rules in `rules/`.

#### `docs/decisions/` — Architecture Decision Records
When making architectural decisions:

```
> We need to choose between REST and GraphQL for our API. Create an ADR.
```

Claude uses the template in `docs/decisions/000-template.md` to document the decision, alternatives, and consequences.

---

## Quick Reference Card

| What you want | What to type |
|---------------|-------------|
| Start a feature | `Follow workflows/feature.md for TICKET-ID` |
| Fix a bug | `Follow workflows/bugfix.md for TICKET-ID` |
| Production is down | `Follow workflows/hotfix.md — describe the issue` |
| Refactor code | `Follow workflows/refactor.md to refactor X` |
| Schema change | `Follow workflows/database-migration.md to add/change X` |
| Self-review code | `/review` |
| Raise a PR | `/pr` |
| Write a ticket | `/ticket <brief description>` |
| Get a plan | `Act as the planner agent. Plan: <description>` |
| Code review | `Act as the reviewer agent. Review <file>` |
| Write tests | `Act as the test writer agent. Test <file>` |
| Debug an issue | `Act as the debugger agent. <describe symptom>` |
| Architectural decision | `Create an ADR for choosing between X and Y` |
| Run quality checks | `Run sh validators/pre-commit.sh` |
| Validate rule integrity | `Run sh validators/lint-rules.sh` |
