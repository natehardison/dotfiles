# Git

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

## Git Safety
- Never push to a remote without explicit user confirmation.
  Commit locally, show what will be pushed, and wait for a
  go-ahead.
- Commit before git surgery. Staged-but-uncommitted changes are
  not recoverable after `git reset --hard`. Always commit (even
  WIP) before rebase or reset.
- Check `git diff --stat origin/main..HEAD` before any reset to
  understand the full scope of changes on the branch.
