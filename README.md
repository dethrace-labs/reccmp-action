# reccmp-action

Executes MSVC 4.2 and [reccmp](https://github.com/isledecomp/reccmp) useful for decomp projects.

## Example usage

```yaml
- uses: dethrace-labs/reccmp-action@main
  name: Run reccmp
  with:
    cmake_flags: -G Ninja -DCMAKE_BUILD_TYPE=Debug -DMSVC_42_FOR_RECCMP=on
    target: CARM95
    diff_report_filename: ${{ github.workspace}}/reccmp-report-report.json
    report_filename: ${{ github.workspace}}/new-reccmp-report.json
    original_binary_url: https://archive.org/download/carm-95/CARM95.EXE
    original_binary_filename: CARM95.EXE
    reccmp_output_filename: ${{ github.workspace}}/reccmp-output.txt
```


See https://github.com/dethrace-labs/dethrace/blob/main/.github/workflows/workflow.yaml
