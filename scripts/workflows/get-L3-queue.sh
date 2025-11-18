#!/usr/bin/env bash
set -euo pipefail

# Resolve repo root and source config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$REPO_ROOT/config/infra.env"

echo "Using OWNER=$OWNER PROJECT_NUMBER=$PROJECT_NUMBER"

gh api graphql -f query='
query($login: String!, $number: Int!) {
  user(login: $login) {
    projectV2(number: $number) {
      title
      items(first: 50) {
        nodes {
          id
          content {
            __typename
            ... on Issue {
              number
              title
              url
            }
          }
          fieldValues(first: 50) {
            nodes {
              ... on ProjectV2ItemFieldSingleSelectValue {
                name
                field {
                  ... on ProjectV2SingleSelectField {
                    name
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
' -F login="$OWNER" -F number="$PROJECT_NUMBER" \
| jq '
  .data.user.projectV2.items.nodes
  | map(
      select(.content.__typename == "Issue")
      | select(
          [ .fieldValues.nodes[]? 
            | select(.field.name == "Status" and .name == "L3 Queue")
          ] | length > 0
        )
      | { number: .content.number, title: .content.title, url: .content.url }
    )
'