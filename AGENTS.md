## Dotfiles

- This is a public GitHub repo. Never put employer-specific URLs,
  org names, credentials, or internal conventions here.
- Commit directly to master — no worktrees, no PRs.

## Multi-agent support

This repo provides shared rules and skills consumed by both
Claude Code and Kiro. Files in `rules/` are symlinked into both
`~/.claude/rules/` and `~/.kiro/steering/`. Keep them
tool-agnostic — no tool-specific framing or features.

Tool-specific content goes in `kiro/steering/` (kiro-only
supplements) or `claude/rules/` (claude-only rules, when needed).

After any change that adds or removes installed files, run
`make check` to verify no broken symlinks.
