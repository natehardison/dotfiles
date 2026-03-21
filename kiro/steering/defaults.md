- Add a `Co-Authored-By: Kiro <noreply@kiro.dev>` trailer to commits.
- When creating a PR, follow the repo's PR template if one exists.

## Worktree Workflow
- **Before delegating any file-modifying work to subagents**, the orchestrator MUST create a worktree first and pass the worktree path as the working directory for all implementation subagents. Never let subagents modify files in the main checkout.
- Never commit feature/fix branches directly in the main checkout.
- Create a worktree for each branch under `~/.worktrees/<repo-name>/`:
  ```
  mkdir -p ~/.worktrees/<repo-name>
  git worktree add ~/.worktrees/<repo-name>/<branch-name> -b <author>/<branch-name>
  ```
- Do all work in the worktree directory. This keeps the main checkout on the default branch and available for other agents.
- Clean up after merging: `git worktree remove ~/.worktrees/<repo-name>/<branch-name>`
- `gh pr merge --delete-branch` fails locally in worktrees because it tries to switch to main, which is already checked out elsewhere. Merge with `gh pr merge --squash --delete-branch` (the remote merge and branch delete succeed), then clean up locally from the main checkout:
  ```
  git worktree remove ~/.worktrees/<repo-name>/<branch-name>
  git worktree prune
  git branch -D <branch-name>
  ```
- At session start, run `git worktree prune` to clean up stale worktrees from branches merged by humans.
- Squash merges don't register as "fully merged" in git. Use `git branch -D` (force) to delete branches after confirming the PR was merged: `gh pr list --state merged --head <branch-name>`.

## Commit Messages
- Single sentence summary (max 50 chars).
- Body: a few paragraphs explaining the change and your testing, word-wrapped at 72 columns.
- After the body, add a line containing only `---`, then `Prompt: {the user's prompt}` (also wrapped at 72 columns). No empty lines before or after the `---` line.
- Provide the commit message for review before committing.
- Never launch an interactive editor. Use `GIT_EDITOR=true` to suppress editor prompts during rebase, cherry-pick, or merge conflict resolution.

## Knowledge Capture
- After submitting a PR, troubleshooting an issue, or completing a research task, review what you had to figure out the hard way: workarounds, tool quirks, undocumented behavior, failed approaches.
- If any of that knowledge would save a future agent time, propose updating the relevant skill, steering rule, or AGENTS.md.
- Don't silently absorb lessons — surface them to the user as a suggested update.

## Test Quality
- Test behavior, not implementation: verify observable outcomes, not internal function calls.
- Don't test private functions directly — test through the public API.
- Each test should answer "what breaks if this test fails?" If the answer is "nothing a user would notice," skip it.
- Prefer realistic inputs over contrived ones.
