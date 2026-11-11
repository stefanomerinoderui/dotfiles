# CLAUDE.md — Global context

This file defines how I should work across all Claude Code sessions, regardless of the project.

## Code quality

- Prioritize readable, maintainable code over clever but hard-to-follow solutions.
- Follow the conventions already established in the project (style, naming, folder structure) before imposing my own.
- Avoid code duplication; extract reusable functions or modules when it makes sense.
- Write small functions with a single responsibility.
- Add explicit error handling, don't assume things will just work (validate inputs, handle exceptions, log relevant failures).
- Write or update tests when adding or modifying non-trivial logic.
- Don't leave dead code, stale comments, or unused imports behind.
- Briefly explain the reasoning behind non-obvious changes (in the commit message or as a comment), without over-documenting the obvious.
- Before considering a task done, review the generated diff as if it were my own code review.

## Linters and formatting

- Before finishing any change, run the project's linter and formatter (ESLint, Prettier, Ruff, Flake8, golangci-lint, etc., as appropriate) and fix the issues they report.
- If the project doesn't have a linter configured, suggest an appropriate one for the language instead of skipping the topic.
- Don't disable lint rules just to "make it pass" unless there's an explicit justification, and in that case leave it commented in the code.
- If there's a pre-commit hook or CI pipeline with quality checks, run those same checks locally before saying a change is ready.

## Privileged (root) commands

- Whenever a command requires administrator privileges, always show it prefixed with `sudo` (not `su`, `doas`, or other variants unless I explicitly ask for them).
- Never run `sudo` commands automatically or assume I have an active privileged session: show the command and wait for my confirmation or manual execution.
- For one-off operations triggered from a GUI or that need interactive PolicyKit authentication, `pkexec` can be used instead of `sudo` — in those cases, mention it as a valid alternative, but the default reference command shown in text should still use `sudo`.
- Before suggesting a privileged command, briefly explain why root is needed (installing system packages, modifying files outside the home directory, network changes, service management, etc.).
- If a command can be run without privileges (e.g. with `--user`, inside a venv, or in a directory I own), prefer that option and avoid unnecessary sudo.
- Never combine a privileged command with a destructive action (`rm -rf`, `dd`, disk formatting) in the same step without explicitly flagging the risk before showing it.

## Interaction style

- Be direct and concise in technical explanations; get to the point.
- If a task is ambiguous, assume the most reasonable interpretation, briefly state the assumption, and proceed, instead of asking about minor details.
- Only ask questions when a wrong decision would mean redoing significant work or touching something privileged/root-related without being sure of the context.

## code-mode MCP (`call_tool_chain`)

- Write the `code` argument as plain JavaScript, not TypeScript. Despite its description, `@utcp/code-mode` (verified on 1.2.13) does no transpilation: it wraps the code in an async function and compiles it directly in `isolated-vm`, so any type annotation (`const a: number`, `Record<...>`, `catch (e: any)`, `as T`) fails with a syntax error.
- The code runs inside an async function: use top-level `await` and `return` the result.
- Call tools as `<manual>.<tool>(args)`, with hyphens in the manual name replaced by underscores (e.g. the `truenas-mcp` manual is `truenas_mcp`). Use `list_tools` / `tools_info` to discover names and arguments; the TS interfaces from `tools_info` are documentation only.
- A failed script still returns `"success": true`; the real error is in `logs` as `[ERROR] Code execution failed: ...`. Always check `logs` before trusting the result.
- Error line numbers are offset by +4 because of the wrapper.
- Wrap each tool call in try/catch when batching several calls, so one failure doesn't hide the others.
# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.
