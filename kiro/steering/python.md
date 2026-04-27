# Python

- Use Python 3.12+ for scripts.
- Use `uv` for running and managing dependencies, even for one-off
  scripts. Prefer PEP 723 inline metadata for standalone scripts.
- In repos with a `uv.lock`, use `uv run` to run tools (e.g.
  `uv run ruff check`). This uses the pinned versions.
- For standalone scripts or repos without `uv.lock`, use `uvx`
  (e.g. `uvx ruff check`).
- No deferred imports. Put all imports at the top of the module.
  Deferred imports hide dependencies, break tooling (mypy,
  refactoring), and make load-order bugs hard to diagnose. If a
  module is expensive to import, that's a design problem in the
  dependency, not something to paper over with lazy loading.
- Never import or test private functions (names starting with `_`).
  Private functions are implementation details — tests should
  exercise the public API that calls them. Importing `_helper`
  in a test couples the test to internal structure and makes
  refactoring painful.
- Run ruff check and ruff format before committing.
- Run mypy --strict before committing. For PEP 723 scripts, run
  mypy inside the script's dependency environment — `uvx mypy`
  won't have the script's deps and reports false errors. Write a
  small wrapper script that declares the same deps plus mypy,
  then calls `mypy --strict` via subprocess.
