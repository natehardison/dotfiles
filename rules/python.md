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
- Run `ruff check --fix` and `ruff format` before committing.
  Let the tools fix formatting and auto-fixable lint issues —
  don't hand-edit code to satisfy the linter unless the fix
  requires judgment.
- Run mypy --strict before committing. For PEP 723 scripts, run
  mypy inside the script's dependency environment — `uvx mypy`
  won't have the script's deps and reports false errors. Write a
  small wrapper script that declares the same deps plus mypy,
  then calls `mypy --strict` via subprocess.
- No `# noqa` or `# type: ignore` without a justification comment
  on the same line. No per-file-ignores for single-function issues
  — use targeted inline comments instead.
- No `import X as X_mod` aliases. Use `from package import module`
  when you need the module object (e.g. for `monkeypatch.setattr`).
- Use `str | None = None` for optional string fields, not
  `str = ""`. Empty string hides the absent case — `None` forces
  callers to handle it explicitly.

## pytest

- Bug fixes: write a failing test that reproduces the bug before
  writing the fix.
- New features with clear interfaces: write tests first to lock
  in the expected behavior before implementing.
- Refactors: run existing tests throughout. Don't write new tests
  for internal restructuring — the public API tests cover it.
- `Mock(return_value=x)` or `Mock(side_effect=fn)` over lambdas.
  Never pass a bare `lambda` where a Mock would work — Mocks
  give you `assert_called_once_with`, call tracking, and clear
  intent.
- `monkeypatch.setattr` over `unittest.mock.patch`. monkeypatch
  is pytest-native, scoped to the test, and doesn't need context
  managers or decorators.
- `@pytest.mark.parametrize` for data-driven tests, not loops
  or repeated test functions.
- Inline before/after fixtures for file mutations: when test data
  is small enough for a readable triple-quoted string, write it
  directly in the test body and assert against the full file
  content after the operation. Use file fixtures in tests/fixtures/
  for larger inputs.
- `@pytest.mark.usefixtures` over unused fixture args: when a test
  needs a fixture's side effect but doesn't reference it in the
  body, use the decorator instead of adding an unused parameter.
- `tmp_path` over `tmpdir`: `tmp_path` returns `pathlib.Path`;
  `tmpdir` returns legacy `py.path.local`.
