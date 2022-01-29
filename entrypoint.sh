#!/bin/bash -x

# $1: package-manager
# $2: requirements file if pip is a package-manager
# $3: pytest-root-dir
# $4: tests dir
# $5: cov-omit-list
# $6: cov-threshold-single
# $7: cov-threshold-total

ls
echo "$(pwd)"

PACKAGE_MANAGER=${1:-"pip"}

# Case insensitive comparing and installing of package-manager
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
  python -m pip install pytest pytest-cov pytest-mock
esac


COV_CONFIG_FILE=.coveragerc
COV_THRESHOLD_SINGLE_FAIL=false
COV_THRESHOLD_TOTAL_FAIL=false


# write omit str list to coverage file
cat << EOF > "$COV_CONFIG_FILE"
[run]
omit = $5
EOF

# Run pytest
output=$(pytest --cov="$3" --cov-config=.coveragerc "$4")
echo "Output is:"
echo "$output"
