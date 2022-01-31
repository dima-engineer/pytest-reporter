#!/bin/bash

# $1: requirements file if pip is a package-manager
# $2: pytest-root-dir
# $3: tests dir
# $4: cov-omit-list
# $5: cov-threshold-single
# $6: cov-threshold-total


COV_CONFIG_FILE=.coveragerc


COV_THRESHOLD_SINGLE_FAIL=false
COV_THRESHOLD_TOTAL_FAIL=false


# Case insensitive comparing and installing of package-manager
if [ -f "./pyproject.toml" ] && [ -f "./poetry.lock" ]
then
  python -m pip install 'poetry==1.1.11'
  python -m poetry config virtualenvs.create false
  python -m poetry install
  python -m poetry add pytest pytest-mock coverage
  python -m poetry shell
elif [ -f "./Pipfile" ] && [ -f "./Pipfile.lock" ];
then
  python -m pip install pipenv
  pipenv install --dev pytest pytest-mock coverage
  pipenv install --dev --system
  pipenv --rm
elif [ -f "$1" ];
then
  python -m pip install -r "$1" --no-cache-dir --user
  python -m pip install pytest pytest-mock coverage
else
  echo "Can not detect your package manager :("
  exit 1
fi 


# write omit str list to coverage file
cat << EOF > "$COV_CONFIG_FILE"
[run]
omit = "$4 coverage_handler.py"
EOF

# Run pytest
coverage run --source="$2" --rcfile=.coveragerc  -m pytest "$3"

if [ $? == 1 ]
then
  echo "Unit tests failed"
  exit 1
fi

coverage json -o coverage.json

export COVERAGE_SINGLE_THRESHOLD="$5"
export COVERAGE_TOTAL_THRESHOLD="$6"

TABLE=$(python coverage_handler.py)

COVERAGE_STATUS_CODE=$?

if [ $COVERAGE_STATUS_CODE == 1 ]
then
  COV_THRESHOLD_SINGLE_FAIL=true
elif [ $COVERAGE_STATUS_CODE == 2 ]
then
  COV_THRESHOLD_TOTAL_FAIL=true
fi


# set output variables to be used in workflow file
echo "::set-output name=output-table::$TABLE"
echo "::set-output name=cov-threshold-single-fail::$COV_THRESHOLD_SINGLE_FAIL"
echo "::set-output name=cov-threshold-total-fail::$COV_THRESHOLD_TOTAL_FAIL"
