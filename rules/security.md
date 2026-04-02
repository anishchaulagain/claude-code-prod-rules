# Security rules

## Input validation
- All user-supplied input is validated at the system boundary (API layer, form submission).
- Use a schema validation library (zod, yup, joi) — don't write bespoke validators.
- Never trust `Content-Type` headers alone. Validate the body structure.

## Authentication & authorization
- AuthZ checks happen server-side, never trust client-supplied roles.
- Use short-lived tokens. Refresh token rotation enabled.
- Never log tokens, passwords, or session IDs.

## Secrets
- No secrets in code, config files, or commit history.
- Use a secrets manager (AWS Secrets Manager, Vault, Doppler) in production.
- `.env` files are gitignored. `.env.example` documents keys without values.

## Dependencies
- Run `npm audit` (or equivalent) before every PR.
- Pin dependency versions in `package.json`. Use lockfiles.
- Review changelogs on major version bumps before upgrading.

## OWASP awareness
Actively guard against:
- Injection (SQL, NoSQL, command)
- Broken access control
- Insecure deserialization
- Security misconfiguration
- XSS (escape all user content rendered in HTML)