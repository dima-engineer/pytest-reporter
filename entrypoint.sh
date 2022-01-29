#!/bin/bash -x

# $1: package-manager
# $2: requirements file if pip is a package-manager
# $3: pytest-root-dir
# $4: tests dir
# $5: cov-omit-list
# $6: cov-threshold-single
# $7: cov-threshold-total



PACKAGE_MANAGER=${1:-"pip"}

COV_CONFIG_FILE=.coveragerc


COV_THRESHOLD_SINGLE_FAIL=false
COV_THRESHOLD_TOTAL_FAIL=false


# Case insensitive comparing and installing of package-manager
case ${PACKAGE_MANAGER,,} in
"poetry")
  python -m pip install 'poetry==1.1.11'
  python -m poetry config virtualenvs.create false
  python -m poetry install
  python -m poetry add pytest pytest-mock coverage
  python -m poetry shell
  ;;
"pip")
  if [ -f "$2" ]
  then
    python -m pip install -r "$2" --no-cache-dir --user
  fi
  python -m pip install pytest pytest-mock coverage
esac


# write omit str list to coverage file
cat << EOF > "$COV_CONFIG_FILE"
[run]
omit = $5
EOF

# Run pytest
OUTPUT=$(coverage run --rcfile=.coveragerc  -m pytest "$4")


coverage json -o coverage.json

export COVERAGE_SINGLE_THRESHOLD="$6"
export COVERAGE_TOTAL_THRESHOLD="$7"

TABLE=$(python coverage_processor.py)

if [ $? == 1 ]
then
  COV_THRESHOLD_SINGLE_FAIL=true
elif [ $? == 2 ]
then
  COV_THRESHOLD_TOTAL_FAIL=true
fi


# set output variables to be used in workflow file
echo "::set-output name=output-table::$TABLE"
echo "::set-output name=cov-threshold-single-fail::$COV_THRESHOLD_SINGLE_FAIL"
echo "::set-output name=cov-threshold-total-fail::$COV_THRESHOLD_TOTAL_FAIL"


