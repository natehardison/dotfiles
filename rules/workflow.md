# Workflow

## File Safety
- Never read dotfiles or dotfile directories in `~/` (e.g.
  `~/.ssh`, `~/.aws`, `~/.gnupg`, `~/.netrc`, `~/.config`)
  without explicit human approval. They may contain credentials
  or private information.

## GitHub
- Use the `gh` CLI to fetch issues, PRs, and other GitHub data,
  even when the user pastes an HTTP link. Parse the owner, repo,
  and number from the URL and call `gh` directly — don't fetch
  the web page.

## Knowledge Capture
- Before declaring any task complete, review what you figured out the
  hard way: workarounds, tool quirks, undocumented behavior, failed
  approaches. Do this BEFORE asking the user "want me to push/PR/merge?"
- If any of that knowledge would save a future agent time, propose
  updating the relevant rule, convention, or project docs.
- For observations that don't fit the current task (bugs found,
  API quirks, codebase facts), capture them for later triage.
  See private steering for the specific workflow.
- Don't silently absorb lessons — surface them to the user as a
  suggested update.

## External Comments
- When posting comments to GitHub PRs, Jira tickets, Slack, or
  any external system, include a footer indicating the comment
  was agent-assisted.

## Amazon Q Bot Reviews
- First round usually finds real issues. Fix them.
- Subsequent rounds get speculative — Q invents scenarios that
  can't happen (concurrent access that's already blocked, signals
  that can't fail). Assess critically after round 2.
- Reply with rationale when dismissing. Don't just ignore.
