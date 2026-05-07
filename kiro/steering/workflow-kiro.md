# Workflow (Kiro)

## External Comments
- Footer text: `*Sent from my Kiro*`

## Subagent Delegation
- Subagents load their own steering and skills but not the parent's
  conversation context. Include task-specific state (worktree path,
  coding standards) in the delegation prompt.
- Pass the worktree path as the working directory when delegating to
  subagents. Never let subagents modify files in the main checkout.
- Keep input files under ~400KB per subagent. Larger files risk
  timeouts — split and delegate in parallel instead.
