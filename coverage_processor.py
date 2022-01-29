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
        f'|{file_path}|{num_statements}|{missing_lines}|{percent_covered}%25|'
    )

totals = data["totals"]

output.append(f'|TOTAL|{totals["num_statements"]}|{totals["missing_lines"]}|{round(totals["percent_covered"], 2)}%25|')

print(*output, sep="%0A")

if round(totals["percent_covered"], 2) < COVERAGE_TOTAL_THRESHOLD:
    COV_THRESHOLD_TOTAL_FAIL = True

if COV_THRESHOLD_SINGLE_FAIL:
    sys.exit(1)
if COV_THRESHOLD_TOTAL_FAIL:
    sys.exit(2)
