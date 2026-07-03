# Git

## Before Every Task
- Unless the project's own instructions say otherwise, work in a
  git worktree. Never modify the main checkout directly.
- After entering the worktree, fetch and rebase onto origin/main:
  `git fetch origin main && git rebase origin/main`
- Use the worktree as your working directory for all subsequent
  operations — file reads, writes, and shell commands.
- Branch names follow `<author>/<description>` convention.

## Commit Messages
- Single sentence summary (max 50 chars).
- Body: a few paragraphs explaining the change and your testing,
  word-wrapped at 72 columns.
- Provide the commit message for review before committing.
- Never launch an interactive editor. Use `GIT_EDITOR=true` to
  suppress editor prompts during rebase, cherry-pick, or merge
  conflict resolution.

## Pull Requests
- When creating a PR, follow the repo's PR template if one exists.

## Git Safety
- Never push to a remote without explicit user confirmation.
  Commit locally, show what will be pushed, and wait for a
  go-ahead.
- Commit before git surgery. Staged-but-uncommitted changes are
  not recoverable after `git reset --hard`. Always commit (even
  WIP) before rebase or reset.
- After any rebase, cherry-pick, or reset, run
  `git diff origin/main..HEAD` and audit every hunk — not just
  the files you intended to change. A clean-looking branch can
  silently revert changes that landed on main since you branched.
