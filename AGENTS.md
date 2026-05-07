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

After any change that affects installed files, run `make` and
verify no broken symlinks:
```bash
make
find ~/.claude ~/.kiro ~/.config ~/.ssh ~/.vim ~/bin -type l ! -exec test -e {} \; -print 2>/dev/null
```
Empty output means all symlinks resolve.
