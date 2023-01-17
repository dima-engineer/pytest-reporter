import json
from pathlib import Path
import os
import sys

COVERAGE_FILE_PATH = './coverage.json'
COVERAGE_SINGLE_THRESHOLD = float(os.environ.get('COVERAGE_SINGLE_THRESHOLD', 0))
COVERAGE_TOTAL_THRESHOLD = float(os.environ.get('COVERAGE_TOTAL_THRESHOLD', 0))
COV_THRESHOLD_SINGLE_FAIL = False
COV_THRESHOLD_TOTAL_FAIL = False


coverage_file = Path(COVERAGE_FILE_PATH)
with coverage_file.open('r') as file:
    data = json.load(file)
output = list()


total_coverage = round(data["totals"]["percent_covered"], 2)
color = 'red'

if 50 >= total_coverage > 20:
    color = "orange"
elif 70 >= total_coverage > 50:
    color = "yellow"
elif 90 >= total_coverage > 70:
    color = "green"
elif 100 >= total_coverage > 90:
    color = "brightgreen"


output.append(f'![pytest-reporter-badge](https://img.shields.io/static/v1?label=pytest-reporter🛡️&message={total_coverage}%&color={color})')
output.append('|Name|Stmts|Miss|Cover|')
output.append('| ------ | ------ | ------ | ------ |')


for file_path, file_data in data.get('files', dict()).items():
    file_summary = file_data["summary"]
    num_statements = file_summary["num_statements"]
    missing_lines = file_summary["missing_lines"]
    percent_covered = round(file_summary["percent_covered"], 2)
    if percent_covered < COVERAGE_SINGLE_THRESHOLD:
        COV_THRESHOLD_SINGLE_FAIL = True
    output.append(
        f'|{file_path}|{num_statements}|{missing_lines}|{percent_covered}%|'
    )

totals = data["totals"]


output.append(f'|TOTAL|{totals["num_statements"]}|{totals["missing_lines"]}|{total_coverage}%|')


print(*output, sep="\n")

if round(totals["percent_covered"], 2) < COVERAGE_TOTAL_THRESHOLD:
    COV_THRESHOLD_TOTAL_FAIL = True

if COV_THRESHOLD_SINGLE_FAIL:
    sys.exit(101)
if COV_THRESHOLD_TOTAL_FAIL:
    sys.exit(102)
