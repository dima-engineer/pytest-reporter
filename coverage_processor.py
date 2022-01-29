import json
from pathlib import Path

COVERAGE_FILE_PATH = "./coverage.json"

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
    output.append(
        f'|{file_path}|{num_statements}|{missing_lines}|{percent_covered}|'
    )

totals = data["totals"]

output.append(f'|TOTAL|{totals["num_statements"]}|{totals["missing_lines"]}|{round(totals["percent_covered"], 2)}|')

print(*output, sep="\n")
