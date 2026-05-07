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
- Before declaring a task complete, check whether anything you
  learned the hard way should be captured in project docs or
  steering rules. Propose the update — don't silently absorb it.

## External Comments
- When posting comments to GitHub PRs, Jira tickets, Slack, or
  any external system, include a footer indicating the comment
  was agent-assisted. Format: `— Agent-assisted (<agent name>)`

## Automated Bot Reviews
- First round usually finds real issues. Fix them.
- Subsequent rounds get speculative — bots invent scenarios that
  can't happen (concurrent access that's already blocked, signals
  that can't fail). Assess critically after round 2.
- Reply with rationale when dismissing. Don't just ignore.
