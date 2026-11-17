# pytest-reporter

This GitHub action runs python tests using `pytest` and creates a comment for PR with a coverage table.
It supports projects with the most popular python package managers (`pip`, `poetry`, `pipenv`, `uv`)

[![made-with-python](https://img.shields.io/badge/Made%20with-Python-1f425f.svg)](https://www.python.org)

## Python Packages Used

The latest versions of these packages are installed on every run:

- [`pytest`](https://pypi.org/project/pytest/)
- [`pytest-mock`](https://pypi.org/project/pytest-mock/)
- [`coverage`](https://pypi.org/project/coverage/)
- [`pytest-asyncio`](https://pypi.org/project/pytest-asyncio/) (only when `async-tests` is `true`)

## Optional Inputs

- `requirements-file`
  - requirements filepath for project
  - if left empty will default to `requirements.txt`
  - necessary if you use `pip` python package manager

- `pytest-root-dir`
  - root directory to recursively search for .py files

- `pytest-tests-dir`
  - directory with pytest tests
  - if left empty will identify test(s) dir by default

- `cov-omit-list`
  - list of directories and/or files to ignore
  - if left empty, the omit list from the project config (`.coveragerc` or `pyproject.toml`) will be used

- `cov-threshold-single`
  - fail if any single file coverage is less than threshold

- `cov-threshold-total`
  - fail if the total coverage is less than threshold

- `async-tests`
  - Add support for async tests

- `poetry-version`
  - Poetry version to be used. The latest version is used by default

- `uv-version`
  - UV version to be used. The latest version is used by default
  
## Template workflow file

```yaml
name: pytest-reporter workflow

on: [pull_request]

jobs:
  tests:
    runs-on: ubuntu-latest
    name: Unit tests
    steps:
      - uses: actions/checkout@v7
      - uses: actions/setup-python@v7
        with:
          python-version: '3.14' # Define your project python version
      - id: run-tests
        uses: dima-engineer/pytest-reporter@v4
        with:
          cov-omit-list: tests/*
          cov-threshold-single: 85
          cov-threshold-total: 90
          async-tests: true
          poetry-version: 2.5.1
```
