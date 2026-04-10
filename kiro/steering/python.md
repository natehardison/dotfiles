# Python

- Use Python 3.12+ for scripts.
- Use `uv` for running and managing dependencies, even for one-off
  scripts. Prefer PEP 723 inline metadata for standalone scripts.
- In repos with a `uv.lock`, use `uv run` to run tools (e.g.
  `uv run ruff check`). This uses the pinned versions.
- For standalone scripts or repos without `uv.lock`, use `uvx`
  (e.g. `uvx ruff check`).
- Run ruff check and ruff format before committing.
- Run mypy --strict before committing. For PEP 723 scripts, run
  mypy inside the script's dependency environment — `uvx mypy`
  won't have the script's deps and reports false errors. Write a
  small wrapper script that declares the same deps plus mypy,
  then calls `mypy --strict` via subprocess.
