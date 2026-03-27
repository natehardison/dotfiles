# Global Defaults

## Dotfiles
- This file lives in natehardison/dotfiles, a public GitHub repo.
  Never put employer-specific URLs, org names, credentials, or
  internal conventions in that repo.
- Steering and skills symlinked from dotfiles must stay generic.
- Commit directly to dotfiles repos — they are exempt from the
  worktree rule below.

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
- Don't silently absorb lessons — surface them to the user as a
  suggested update.

## Subagent Delegation
- Subagents don't inherit steering files or repo context. When
  delegating work, include relevant rules (worktree path, commit
  format, pre-commit checks, coding standards) in the delegation
  prompt.
- Pass the worktree path as the working directory when delegating to
  subagents. Never let subagents modify files in the main checkout.

## Python Scripts
- Use `uv` for running and managing dependencies, even for one-off
  scripts. Prefer PEP 723 inline metadata for standalone scripts.
- In repos with a `uv.lock`, use `uv run` to run tools (e.g.
  `uv run ruff check`). This uses the pinned versions.
- For standalone scripts or repos without `uv.lock`, use `uvx`
  (e.g. `uvx ruff check`).
- Run ruff check and ruff format before committing.
- Run mypy --strict before committing.
- All functions must have type annotations. Use `from __future__
  import annotations` or Python 3.10+ syntax for generics.
