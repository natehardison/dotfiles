# Workflow

## File Safety
- Never read dotfiles or dotfile directories in `~/` (e.g.
  `~/.ssh`, `~/.aws`, `~/.gnupg`, `~/.netrc`, `~/.config`)
  without explicit human approval. They may contain credentials
  or private information.

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

## External Comments
- When posting comments to GitHub PRs, Jira tickets, Slack, or
  any external system, include a footer line: `*Sent from my Kiro*`.
  This makes it clear the comment was agent-assisted, not
  hand-written.

## Subagent Delegation
- Subagents load their own steering and skills but not the parent's
  conversation context. Include task-specific state (worktree path,
  coding standards) in the delegation prompt.
- Pass the worktree path as the working directory when delegating to
  subagents. Never let subagents modify files in the main checkout.
- Keep input files under ~400KB per subagent. Larger files risk
  timeouts — split and delegate in parallel instead.
