# Global Defaults

## Before Every Task
- Create a git worktree before making any changes, if the current
  directory is a git repository. Never modify the main checkout
  directly.
- Use the worktree as your working directory for all subsequent
  operations — file reads, writes, and shell commands.
- Branch names follow `<author>/<description>` convention.
- See the `git-worktree` skill for setup, cleanup, and edge cases.

## Commit Messages
- Single sentence summary (max 50 chars).
- Body: a few paragraphs explaining the change and your testing,
  word-wrapped at 72 columns.
- After the body, add a line containing only `---`, then
  `Prompt: {the user's prompt}` (also wrapped at 72 columns).
  No empty lines before or after the `---` line.
- Add a `Co-Authored-By: Kiro <noreply@kiro.dev>` trailer.
- Provide the commit message for review before committing.
- Never launch an interactive editor. Use `GIT_EDITOR=true` to
  suppress editor prompts during rebase, cherry-pick, or merge
  conflict resolution.

## Pull Requests
- When creating a PR, follow the repo's PR template if one exists.

## Knowledge Capture
- Before declaring any task complete, review what you figured out the
  hard way: workarounds, tool quirks, undocumented behavior, failed
  approaches. Do this BEFORE asking the user "want me to push/PR/merge?"
- If any of that knowledge would save a future agent time, propose
  updating the relevant skill, steering rule, or AGENTS.md.
- For observations that don't fit the current task (bugs found,
  API quirks, codebase facts), capture them for later triage.
  See private steering for the specific workflow.
- Don't silently absorb lessons — surface them to the user as a
  suggested update.

## Subagent Delegation
- Subagents load their own steering and skills but not the parent's
  conversation context. Include task-specific state (worktree path,
  coding standards) in the delegation prompt.
- Pass the worktree path as the working directory when delegating to
  subagents. Never let subagents modify files in the main checkout.
- Keep input files under ~400KB per subagent. Larger files risk
  timeouts — split and delegate in parallel instead.

## Python Scripts
- Use `uv` for running and managing dependencies, even for one-off
  scripts. Prefer PEP 723 inline metadata for standalone scripts.
- In repos with a `uv.lock`, use `uv run` to run tools (e.g.
  `uv run ruff check`). This uses the pinned versions.
- For standalone scripts or repos without `uv.lock`, use `uvx`
  (e.g. `uvx ruff check`).
- Run ruff check and ruff format before committing.
- Run mypy --strict before committing. For PEP 723 scripts, run
  mypy inside the script's dependency environment — `uvx mypy`
  won't have the script's deps and reports false errors. Write a
  small wrapper script that declares the same deps plus mypy,
  then calls `mypy --strict` via subprocess.
- All functions must have type annotations. Use `from __future__
  import annotations` or Python 3.10+ syntax for generics.

## Shell & JSON
- For JSON parsing in shell commands, prefer `jq` over Python
  one-liners. Reserve Python for complex transformations that
  need error handling or multi-step logic.

## Large File Transforms
- Use scripts for mechanical file transformations (renumbering,
  bulk renames, path updates) instead of generating full file
  content inline. A 3-line Python script beats rewriting a
  500-line file and risking a timeout.
- Never reconstruct markdown via sed pipelines. `grep -v '^$'`
  strips blank lines and destroys formatting. Use targeted
  str_replace on the original file.

## Git Safety
- Commit before git surgery. Staged-but-uncommitted changes are
  not recoverable after `git reset --hard`. Always commit (even
  WIP) before rebase or reset.
- Check `git diff --stat origin/main..HEAD` before any reset to
  understand the full scope of changes on the branch.
