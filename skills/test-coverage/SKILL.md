---
name: test-coverage
description: Analyze test coverage gaps and create beads for missing tests
argument-hint: [directory]
---

# /test-coverage — Test Gap Analysis

Analyze the codebase (or `$ARGUMENTS` directory) for test coverage gaps and
create beads for every missing test.

## What to evaluate

1. **Unit tests** — Does every module/function have real unit tests?
   - No mocks or fakes unless absolutely necessary (external APIs, databases)
   - Test real behavior, not implementation details
2. **Integration tests** — Are there e2e integration test scripts?
   - Detailed logging so failures are diagnosable
   - Cover critical user workflows end-to-end
3. **Edge cases** — Are boundary conditions tested?

## Process

1. Find all source files and their corresponding test files
2. Identify modules/functions with no tests or weak tests
3. Evaluate existing test quality (mocks hiding real bugs?)
4. Create beads for each gap using `bd create` with:
   - What to test and why
   - Specific test scenarios to cover
   - Dependencies on implementation beads if applicable
5. Overlay dependency structure

## Rules

- Prefer real tests over mocked tests. Mocks should be a last resort.
- Every test bead should specify concrete scenarios, not just "add tests for X."
- Use extended thinking for coverage analysis.
