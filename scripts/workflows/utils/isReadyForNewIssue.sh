#!/usr/bin/env bash
set -euo pipefail

### Validate repo state
# if [[ -n $(git status --porcelain) ]]; then
#   echo "Error: Working directory is not clean. Please commit or stash changes before running this script." >&2
#   exit 1
# fi

### llm-ignorable is empty
# check the dir
if [[ -d "llm-ignorable" && -n "$(ls -A llm-ignorable)" ]]; then
  echo "Error: 'llm-ignorable' directory is not empty. Make sure there isn't still work to do" >&2
  exit 1
fi
