---
name: hs-sw-test-coverage
description: Analyze test coverage gaps and create beads for missing tests
argument-hint: [directory]
---

# /test-coverage — Test Gap Analysis

Analyze the codebase (or `$ARGUMENTS` directory) for test coverage gaps and
create beads for every missing test.

## Discovery

Before creating beads, understand the project's test infrastructure:
1. Detect the test framework(s) in use (pytest, jest, vitest, etc.)
2. Find the test directory conventions (tests/, __tests__/, *.test.*, *.spec.*)
3. Map source files to their corresponding test files

## What to evaluate

1. **Unit tests** — Does every module/function have real unit tests?
   - Minimize mocks. When mocks are necessary, mock at the boundary
     (HTTP client, database driver, file system) — never internal functions.
   - Test real behavior, not implementation details
2. **Integration tests** — Are there e2e integration test scripts?
   - Detailed logging so failures are diagnosable
   - Cover critical user workflows end-to-end
3. **Edge cases** — Are boundary conditions tested?
4. **Existing test quality** — Are mocks hiding real bugs? Are assertions
   meaningful or just checking that code ran without crashing?

## Process

1. Find all source files and their corresponding test files
2. Quantify the gap: "N modules have no tests, M have partial coverage"
3. Prioritize by risk — untested code in critical paths (auth, payments, data
   mutations, API handlers) gets P1. Utilities and helpers get P3.
4. Create beads for each gap using `bd create` with:
   - What to test and why it's risky without tests
   - Specific test scenarios and edge cases to cover
   - Which test framework and patterns to use (match existing conventions)
   - Dependencies on implementation beads if applicable
5. Overlay dependency structure

## Rules

- Every test bead should specify concrete scenarios, not just "add tests for X."
- Match the project's existing test patterns and conventions.
- Use extended thinking for coverage analysis.
