#!/bin/bash
set -e

echo "▶ Type checking..."
npx tsc --noEmit

echo "▶ Linting..."
npx eslint . --max-warnings=0

echo "▶ Formatting check..."
npx prettier --check .

echo "▶ Unit tests..."
npx vitest run --coverage

echo "✓ All checks passed. Safe to commit."
