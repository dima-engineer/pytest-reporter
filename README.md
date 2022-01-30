# pytest-reporter

This GitHub action runs python tests using `pytest` and creates a comment for PR with a coverage table.  

[![made-with-python](https://img.shields.io/badge/Made%20with-Python-1f425f.svg)](https://www.python.org)

## Python Packages Used

- [`pytest`](https://pypi.org/project/pytest/)
- [`coverage`](https://pypi.org/project/coverage/)

## Optional Inputs


- `package-manager`
  - Python package manager you use in your project
  - `pip` by default
  - Can be `pip`, `poetry`

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

## Outputs

- `output-table`
  - str
  - `pytest --cov` markdown output table
- `cov-threshold-single-fail`
  - boolean
  - `false` if any single file coverage less than `cov-threshold-single`, else `true`
- `cov-threshold-total-fail`
  - boolean
  - `false` if total coverage less than `cov-threshold-total`, else `true`

## Template workflow file

```yaml
name: pytester-cov workflow

on: [pull_request]

jobs:
  tests:
    runs-on: ubuntu-latest
    name: Unit tests
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
        with:
          python-version: '3.9.6' # Define necassary python version
      - id: run-tests
        uses: dima-engineer/pytest-reporter@v1.0.0
        with:
          package-manager: poetry
          cov-omit-list: tests/*
          cov-threshold-single: 85
          cov-threshold-total: 90
