# Claude Code Production Rules

An open-source, enterprise-grade configuration setup for [Claude Code](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview). 

By default, AI coding assistants will often take shortcuts, write code without tests, and inconsistently apply error handling or security practices. This repository provides a complete "Principal Engineer" persona and strict rule set that forces Claude Code to write production-ready code every time.

## 🌟 What This Does

When you copy this setup into your project, Claude transforms from a "quick prototyper" into an accountable team member. 

It enforces:
- **Test-Driven Development (TDD) principles:** It will refuse to fix bugs or refactor without writing tests first.
- **Strict Error Handling:** No floating promises, no empty catch blocks, and consistent HTTP error shapes.
- **Security by Default:** Refuses to log secrets, validates DB queries for injection, and implements CSRF/rate limiting.
- **Checklist-Driven Work:** Uses rigorous structured workflows for feature development, bug fixing, and hotfixes.

## 🚀 Quick Start

To use this in your own project, run this from your target project's root directory:

```bash
# Clone the rules as a temporary directory
git clone https://github.com/anishchaulagain/claude-code-prod-rules.git /tmp/rules

# Copy the core infrastructure into your project
cp /tmp/rules/CLAUDE.md ./CLAUDE.md
cp -r /tmp/rules/.claude ./.claude
cp -r /tmp/rules/rules ./rules
cp -r /tmp/rules/agents ./agents
cp -r /tmp/rules/workflows ./workflows
cp -r /tmp/rules/validators ./validators
cp -r /tmp/rules/docs ./docs
cp -r /tmp/rules/templates ./templates

# Remove the temporary directory
rm -rf /tmp/rules
```

Once copied, Claude Code automatically reads `CLAUDE.md` and `.claude/settings.json` the next time you start a session in your project. No additional setup is required. 

See [USAGE.md](./USAGE.md) for full instructions on using global configurations or submodules.

---

## 📖 Practical Example: Fixing a Bug

Here is a real-world example of what it looks like to use this configuration. Imagine you have a bug where users are occasionally seeing a 500 error when clicking "Checkout".

### Without these rules:
You: *"Fix the bug in the checkout controller where it occasionally returns a 500."*
**Claude:** *Finds the issue, guesses a fix, wraps the code in a generic `try/catch`, and commits it directly to `main` without writing a regression test.*

### WITH these rules:
You: *"Follow `workflows/bugfix.md` to fix the checkout 500 error (Ticket: ENG-405)."*

**Here is exactly what Claude will do autonomously:**

#### 1. Claude forces reproduction first
*"Before I change the implementation, I must reproduce the bug as per my instructions."*
Claude researches the checkout flow and writes a failing regression test in `checkout.test.ts` that deliberately triggers the 500.

#### 2. Claude acts as a systematic Debugger
Instead of guessing, Claude uses the `debugger` persona. It analyzes logs, forms hypotheses, and narrows down the root cause.
*"The root cause is that `ProcessPaymentService` occasionally throws a network timeout, which is not being caught by the controller, bubbling up as an unhandled 500."*

#### 3. Claude applies a minimal, safe fix
Claude adds the specific missing error catch, maps it to a safe `PaymentGatewayError` (following `rules/error-handling.md`), and limits the code change to exactly what is needed.

#### 4. Claude self-validates
Claude automatically runs:
```bash
sh validators/pre-commit.sh
```
This runs the typescript compiler, ESLint, formats the file, runs the security audit, and runs the test suite. *The new test now passes.*

#### 5. Claude raises a PR
You type `/pr`. 
Claude automatically grades its own work against the `pr-checklist.md`, ensuring there's no leftover `console.log`s, that tests were added, and no type errors exist. It creates a well-formatted PR description tying the bug back to `ENG-405`. 

**Result: You get a completely tested, style-compliant, and CI-ready fix raised as a formal PR to your `develop` branch, completely autonomously.**

---

## 🛠️ Repository Structure

- `CLAUDE.md` - The entry point. Defines Claude's identity, communication style, and non-negotiable principles.
- `.claude/` - Settings to grant bash command execution permissions and the custom Slash Commands (`/pr`, `/review`, `/ticket`).
- `rules/` - The core "brain" (testing, security, database, Git, API design, performance).
- `workflows/` - Standard Operating Procedures (SOPs) for features, bugfixes, refactoring, etc.
- `agents/` - Specialized personas you can invoke (Planner, Debugger, Test Writer, Reviewer).
- `validators/` - Scripts to execute CI validation before allowing PR actions.
- `docs/` & `templates/` - Boilerplate examples like `.env.example` and ADR documentation.

## 🤝 Contributing
Open source contributions are highly encouraged! Please ensure any new rules added to the `rules/` directory are also appended to the `context_files` array inside `.claude/settings.json`, and run `sh validators/lint-rules.sh` to ensure all links are valid before submitting a PR.
