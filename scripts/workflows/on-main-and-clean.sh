#!/usr/bin/env bash
set -euo pipefail

# Resolve repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Load BASE_BRANCH from config
source "$REPO_ROOT/config/infra.env"

# Default to main if BASE_BRANCH is not set
BASE_BRANCH="${BASE_BRANCH:-main}"

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

if [[ "$CURRENT_BRANCH" != "$BASE_BRANCH" ]]; then
  echo "Error: Must be on '$BASE_BRANCH' branch, but you're on '$CURRENT_BRANCH'."
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Error: Working directory is not clean. Commit or stash changes first."
  exit 1
fi

echo "OK: On '$BASE_BRANCH' and workspace is clean."
