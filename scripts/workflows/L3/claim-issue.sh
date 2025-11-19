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

# Print the issue details 


ISSUE_TITLE=$(echo "$ISSUE_DETAILS" | jq -r '.data.repository.issue.title')
ISSUE_URL=$(echo "$ISSUE_DETAILS" | jq -r '.data.repository.issue.url')
ISSUE_BODY=$(echo "$ISSUE_DETAILS" | jq -r '.data.repository.issue.body')

# Print a human-readable summary
echo ""
echo "############## Issue #$ISSUE_NUMBER: $ISSUE_TITLE ##############"
echo "URL: $ISSUE_URL"
echo ""
echo "Body:"
echo "$ISSUE_BODY"
echo "###############################################################"

# ask user to confirm
read -p "Do you want to claim this issue from L3 Queue? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  echo "Aborting."
  exit 0
fi
# Create a new branch name for this L3 issue
DEFAULT_TEMPLATE="docs/L{{level}}/issue-{{number}}-{{slug}}"
TEMPLATE="${BRANCH_NAME_TEMPLATE:-$DEFAULT_TEMPLATE}"


# Generate a URL-safe slug from the issue title
ISSUE_SLUG=$(echo "$ISSUE_TITLE" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9' '-' | tr -s '-')
# Trim leading and trailing dashes
ISSUE_SLUG=$(echo "$ISSUE_SLUG" | sed 's/^-*//; s/-*$//')

# Populate template placeholders
BRANCH_NAME="$TEMPLATE"
BRANCH_NAME="${BRANCH_NAME//\{\{level\}\}/3}"
BRANCH_NAME="${BRANCH_NAME//\{\{number\}\}/$ISSUE_NUMBER}"
BRANCH_NAME="${BRANCH_NAME//\{\{slug\}\}/$ISSUE_SLUG}"

echo "Creating and switching to branch '$BRANCH_NAME'"