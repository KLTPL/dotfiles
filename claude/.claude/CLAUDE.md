# Developer & Project Guidelines

## Git & Version Control

- **Commit Formatting:** Follow Conventional Commits format (`type(scope): subject`).
- **Commit body**: Keep the body section of a commit concise, list all the changes but without explaining how every change is implemented, unless there is something unusual about the implementation.
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
- **Language**: always write code and comments in English if not specified otherwise.

## Testing & Verification

- **Test Integrity:** When a test fails, treat production code as incorrect until proven otherwise. Never weaken assertions, loosen test matchers, or skip tests to make a suite pass.
- **Root-Cause Analysis:** Diagnose why a test failed before making edits. If a test assertion is legitimately obsolete due to requirement changes, explain why before altering the test logic.
- **Self-Verification:** Run the project's local test and lint checks after modifications to verify logic before handing back work.

## Claude Code Skills

- **Own skills:** Store custom skills as folders in `~/dotfiles/claude/.claude/skills/`, and add a relative-path entry for each (with `"skills": ["./"]`) to `~/dotfiles/.claude-plugin/marketplace.json` so other machines can install it. Don't add these entries to `enabledPlugins`; on my own machines the skills load from the stowed folder.
- **Third-party skills:** Install other people's skills as plugins, never with `npx skills add`. If the repo publishes a plugin marketplace, add it to `extraKnownMarketplaces` and `enabledPlugins` in `~/dotfiles/claude/.claude/settings.json`. Otherwise, add a `git-subdir` entry for the skill folder (with `"skills": ["./"]`) to `~/dotfiles/.claude-plugin/marketplace.json`, then run `claude plugin marketplace update kltpl-skills` and `claude plugin install <name>@kltpl-skills`.
- **Settings check:** `claude plugin` commands rewrite `settings.json`; afterwards confirm the `kltpl-skills` marketplace entry still has `"autoUpdate": true`.
