#!/usr/bin/env bash
set -e

export WINEPREFIX=/wineprefix
export BUILDDIR=build-msvc42

# Configure build with CMake
wine cmake -B $BUILDDIR . $INPUT_CMAKE_FLAGS

# Build
wine cmake --build $BUILDDIR -- -j1

echo build_only: $INPUT_BUILD_ONLY
if [ "${INPUT_BUILD_ONLY}" = "true" ]; then
  exit 0
fi

# Fetch original binary
curl -Lo /tmp/$INPUT_ORIGINAL_BINARY_FILENAME $INPUT_ORIGINAL_BINARY_URL

# Update path to original binary
reccmp-project detect --search-path /tmp

# Fix up wine paths to underlying linux paths so we can run reccmp outside of wine
cd $BUILDDIR
sed -i 's/Z://g' reccmp-build.yml

found=0
while IFS= read -r line; do
  echo "$line"
  if [[ "$line" == *Decreased* ]]; then
    found=1
  fi
done < <(reccmp-reccmp --target $INPUT_TARGET --html reccmp-report.html --json reccmp-report-new.json --diff $INPUT_REPORT_FILENAME
if (( found )); then
  exit 1
fi

# Check if "Decreased" appears anywhere
if grep -q "Decreased" <<< "$DIFF_OUTPUT"; then
  exit 1
fi

# # the report file must be the same as the one being commited in this PR
# if cmp -s $INPUT_REPORT_FILENAME reccmp-report-new.json; then
#   echo "Files are identical"
# else
#   echo "Files differ"
#   return 1
# fi
