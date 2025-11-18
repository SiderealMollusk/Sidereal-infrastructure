#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Error: issue number required."
  echo "Usage: $0 <issue-number>"
  exit 1
fi

ISSUE_NUMBER="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Load OWNER and REPO from config/infra.env
source "$REPO_ROOT/config/infra.env"

# assure that we are on main and clean. Echo error and exit if not.
##### TODO: enable this check later #####
#"$REPO_ROOT/scripts/workflows/on-main-and-clean.sh"
#########################################

# Fetch issue details using GH CLI
echo "Fetching details for issue #$ISSUE_NUMBER from $OWNER/$REPO..."

ISSUE_DETAILS=$(gh api graphql -f query='
query($owner:String!, $repo:String!, $number:Int!) {
  repository(owner:$owner, name:$repo) {
    issue(number:$number) {
      number
      title
      url
      body
    }
  }
}
' -F owner="$OWNER" -F repo="$REPO" -F number="$ISSUE_NUMBER")

# Print the issue details like:
# Issue #<number>: <title>
# URL: <url>
# Body:
# <body> 
ISSUE_TITLE=$(echo "$ISSUE_DETAILS" | jq -r '.data.repository.issue.title')
ISSUE_URL=$(echo "$ISSUE_DETAILS" | jq -r '.data.repository.issue.url')
ISSUE_BODY=$(echo "$ISSUE_DETAILS" | jq -r '.data.repository.issue.body')

# Print a human-readable summary
echo "Issue #$ISSUE_NUMBER: $ISSUE_TITLE"
echo "URL: $ISSUE_URL"
echo ""
echo "Body:"
echo "$ISSUE_BODY"
