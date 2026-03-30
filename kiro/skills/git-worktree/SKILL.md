---
name: git-worktree
description: How to create, use, and clean up git worktrees for task isolation. Use when starting a new task in a git repository.
---

## Overview

Git worktrees let multiple agents work in the same repo simultaneously
by giving each task its own working directory. The main checkout stays
clean and is never used for feature branches.

### Placeholders

- `<repo-name>`: basename of the repo directory (e.g., `my-project`)
- `<author>`: the user's username (e.g., `nateh`)
- `<branch-name>`: short description of the task (e.g., `fix-serial-timeout`)

## Command style

Run each git and shell command as a separate `execute_bash` call.
Use the `working_dir` parameter instead of `cd`. Never chain
commands with `&&` or `;` — it defeats the auto-approval allowlist.

## Steps

1. Create the worktree directory and branch:
   ```bash
   mkdir -p ~/.worktrees/<repo-name>
   git worktree add ~/.worktrees/<repo-name>/<branch-name> -b <author>/<branch-name>
   ```

2. Use the worktree path as your working directory for all subsequent
   operations — file reads, writes, and shell commands.

3. Push the branch, create a PR, and get it reviewed. See the
   `pull-requests` skill if the repo has one.

4. Merge the PR from the worktree. Don't use `--delete-branch` — it
   fails in worktrees because `gh` can't switch to main:
   ```bash
   gh pr merge --squash
   ```

5. Clean up. Run these from the original repo directory (where the
   session started), not the worktree:
   ```bash
   git worktree remove ~/.worktrees/<repo-name>/<branch-name>
   git worktree prune
   git branch -D <author>/<branch-name>
   git pull origin main
   ```

## Maintenance

At session start, prune stale worktrees from branches merged by
humans:
```bash
git worktree prune
```

## Troubleshooting

- **`git branch -d` says branch is not fully merged**: Squash merges
  don't register as merged in git. Confirm the PR was merged first,
  then force delete:
  ```bash
  gh pr list --state merged --head <author>/<branch-name>
  git branch -D <author>/<branch-name>
  ```
