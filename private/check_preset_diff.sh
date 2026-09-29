#!/usr/bin/env bash
set -euo pipefail

if [[ "$1" == "--missing" ]]; then
    echo "File $2 is missing. Run 'bazel run $3' to create it." >&2
    exit 1
fi

if [[ -s "$2" ]]; then
    cat "$2" >&2
    echo "The bazelrc preset has changed. Run 'bazel run $3' to update it." >&2
    exit 1
fi
