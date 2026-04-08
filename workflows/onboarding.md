---
description: Run this immediately after copying the rules into a new project to tailor them to the specific codebase.
---

# Workflow: Project Onboarding & Initialization

## Trigger
Run this workflow manually immediately after copying the `claude-code-prod-rules` into a new codebase.
Example: `Follow workflows/onboarding.md`

## Objective
This workflow instructs Claude to scan the repository structure, infer its technology stack and standards, and statically adapt `docs/architecture.md`, `docs/coding-standards.md`, and any other template files exactly to this codebase.

## Steps (execute autonomously as a single script without constant user prompting)

### 1. Codebase Discovery
- **Scan for stack:** Look at root-level manifest files (`package.json`, `pom.xml`, `requirements.txt`, `go.mod`, `docker-compose.yml`, `tsconfig.json`) to determine the primary languages, frameworks, test runners, and database ORMs used.
- **Scan for structure:** Use `ls` or examine the directory tree to figure out the primary code layout (e.g., `src/`, `lib/`, `app/` versus `pages/`).
- **Scan for conventions:** Pick 3-5 representative source files and tests to observe:
  - Naming conventions (camelCase, snake_case)
  - Architectural patterns (MVC, Service layer, Clean Architecture)
  - Error handling usage
  - Import sorting or paths (e.g. `@/` aliases vs relative)

### 2. Tailor Architecture Doc
- Rewrite `docs/architecture.md`.
- Replace the boilerplate placeholders with the actual discovered tech stack (Frontend, Backend, DB, ORM, Testing).
- Outline the real directory structure found in Step 1.
- Synthesize an educated guess for "Key data flows" and "Database schema" based on the scanned files. 
- *Crucially:* Remove any boilerplate generic text (like "<!-- e.g. Node.js 20 -->").

### 3. Tailor Coding Standards Doc
- Rewrite `docs/coding-standards.md`.
- Replace the boilerplate naming conventions table with the actual conventions observed in Step 1.
- Update the examples under "Function design", "Error creation pattern", and "Service layer pattern" so they accurately reflect the library or framework detected (e.g. if the project is Python/Django, rewrite the Typescript examples to Python!).
- Extract any domain-specific terminology you've seen and pre-fill the "Project-specific vocabulary" table.

### 4. Create `.env.example`
- Scan the code for references to environment variables (e.g., `process.env.XYZ`, `os.getenv("XYZ")`).
- Update `templates/.env.example` (or create if missing) to include these keys with empty values or sample values. Group them logically (e.g., Database, External APIs).

### 5. Final Report
- After rewriting the configuration, output a concise summary to the user:
  - The tech stack detected.
  - Which files were customized (`docs/architecture.md`, `docs/coding-standards.md`, `templates/.env.example`).
  - Next steps (e.g., "The ruleset has been tailored to this Next.js project. You can now type `/pr` or `Follow workflows/feature.md` to begin extending it.").
