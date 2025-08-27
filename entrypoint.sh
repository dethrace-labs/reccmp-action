#!/usr/bin/env bash
set -e

export WINEPREFIX=/wineprefix
export BUILDDIR=build-msvc42

# Configure build with CMake
wine cmake -B $BUILDDIR . $INPUT_CMAKE_FLAGS

# Build
wine cmake --build $BUILDDIR -- -j1

if [ "${INPUT_BUILD_ONLY}" = "true" ]; then
  exit 0
fi

# Fetch original binary
curl --silent --show-error --fail -Lo /tmp/$INPUT_ORIGINAL_BINARY_FILENAME $INPUT_ORIGINAL_BINARY_URL

# Update path to original binary
reccmp-project detect --search-path /tmp

# Fix up wine paths to underlying linux paths so we can run reccmp outside of wine
cd $BUILDDIR
sed -i 's/Z://g' reccmp-build.yml

# Capture the output of the command into a variable
output=$(
  reccmp-reccmp \
    --target "$INPUT_TARGET" \
    --html reccmp-report.html \
    --json "$INPUT_REPORT_FILENAME" \
    --diff "$INPUT_DIFF_REPORT_FILENAME"
)

# Print the full output
echo "$output"

echo "$output" > $INPUT_RECCMP_OUTPUT_FILENAME
