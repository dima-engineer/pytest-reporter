#!/bin/bash -x

# $1: package-manager
# $2: requirements file if pip is a package-manager
# $4: pytest-root-dir
# $5: tests dir
# $6: cov-omit-list
# $7: cov-threshold-single
# $8: cov-threshold-total

PACKAGE_MANAGER=${1:-"pip"}

# Case insensitive comparing
case ${PACKAGE_MANAGER,,} in
"poetry")
  python -m pip install 'poetry==1.1.11'
  python -m poetry config virtualenvs.create false
  python -m poetry install
  python -m poetry add pytest pytest-cov pytest-mock
  python -m poetry shell
  ;;
"pip")
  if [ -f "$2" ]
  then
    python -m pip install -r "$2" --no-cache-dir --user
  fi
  python -m pip install pytest pytest-cov
esac
