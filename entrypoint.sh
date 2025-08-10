#!/usr/bin/env bash
set -e

export WINEPREFIX=/wineprefix

# Configure build with CMake
wine cmake -B build . $INPUT_CMAKE_FLAGS

# Build
wine cmake --build build -- -j1

# Update path to original binary
reccmp-project detect --search-path /original

# Fix up wine paths to underlying linux paths so we can run reccmp outside of wine
cd /build
sed -i 's/Z://g' reccmp-build.yml

exec $INPUT_COMMAND


# Unlock directories
#chmod -R 777 source build
