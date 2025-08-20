#!/usr/bin/env bash
set -e
set -x

export WINEPREFIX=/wineprefix

# Configure build with CMake
wine cmake -B build . $INPUT_CMAKE_FLAGS

# Build
wine cmake --build build -- -j1

# Fetch original binary
curl -Lo /tmp/$INPUT_ORIGINAL_BINARY_FILENAME $INPUT_ORIGINAL_BINARY_URL

# Update path to original binary
reccmp-project detect --search-path /tmp

# Fix up wine paths to underlying linux paths so we can run reccmp outside of wine
cd build
sed -i 's/Z://g' reccmp-build.yml

exec $INPUT_COMMAND


# Unlock directories
#chmod -R 777 source build
