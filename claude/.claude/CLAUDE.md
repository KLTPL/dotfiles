# Developer & Project Guidelines

## Git & Version Control

- **Manual Commits Only:** Never run `git commit` or `git push` autonomously. Draft commit messages and summarize file changes for review, leaving execution to the user.
- **Commit Formatting:** Follow Conventional Commits format (`type(scope): subject`).
- **No AI Attribution:** Never include `Co-Authored-By: Claude` or any AI attribution footers in drafted commit messages or pull requests.

## Scope & Operational Boundaries

- **Scope Control:** Modify only files strictly required for the immediate task. Do not perform drive-by refactoring, file cleanups, or styling tweaks outside the requested scope without explicit permission.
- **File System Integrity:** Never rename, move, or delete existing files without prior approval.
- **Safety First:** Never execute destructive operations (`rm -rf`, `DROP TABLE`, `DELETE`, `git push --force`, or unverified migration scripts) without presenting the exact command and receiving explicit confirmation.
- **External Services:** Keep calls to remote APIs or external services read-only unless write actions are explicitly requested.

## Code Standards & Architecture

- **Error Handling:** Avoid generic catch-alls (`return null`, `return []`, log-and-continue) and empty `catch` blocks. Add `try/catch` only when explicit, actionable recovery logic exists. If an error cannot be handled locally, let it propagate; stack traces take precedence over silent degradation.
- **Modularity & File Length:** Keep code modular. If a code file approaches ~300 lines, split it into cohesive modules rather than extending a monolithic file.
- **Dependencies:** Do not add third-party dependencies unless strictly necessary and confirmed with the user.

## Testing & Verification

- **Test Integrity:** When a test fails, treat production code as incorrect until proven otherwise. Never weaken assertions, loosen test matchers, or skip tests to make a suite pass.
- **Root-Cause Analysis:** Diagnose why a test failed before making edits. If a test assertion is legitimately obsolete due to requirement changes, explain why before altering the test logic.
- **Self-Verification:** Run the project's local test and lint checks after modifications to verify logic before handing back work.
