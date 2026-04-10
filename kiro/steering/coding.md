# Coding

- Do NOT use Python for JSON parsing when `jq` would suffice.
  Reserve Python for complex transformations that need error
  handling or multi-step logic.
- Use scripts for mechanical file transformations (renumbering,
  bulk renames, path updates) instead of generating full file
  content inline. A 3-line Python script beats rewriting a
  500-line file and risking a timeout.
- Never reconstruct markdown via sed pipelines. `grep -v '^$'`
  strips blank lines and destroys formatting. Use targeted
  str_replace on the original file.
