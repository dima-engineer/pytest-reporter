# pytest-reporter

This GitHub action runs python tests using `pytest` and creates a comment for PR with a coverage table.
It supports projects with the most popular python package managers (`pip`, `poetry`, `pipenv`, `uv`)

[![made-with-python](https://img.shields.io/badge/Made%20with-Python-1f425f.svg)](https://www.python.org)

## Python Packages Used

- [`pytest`](https://pypi.org/project/pytest/)
- [`coverage`](https://pypi.org/project/coverage/)

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
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11.4' # Define your project python version
      - id: run-tests
        uses: dima-engineer/pytest-reporter@v3
        with:
          cov-omit-list: tests/*
          cov-threshold-single: 85
          cov-threshold-total: 90
          async-tests: true
          poetry-version: 1.4.2
