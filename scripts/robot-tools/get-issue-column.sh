

#!/usr/bin/env bash
# Generic issue-column fetcher for GitHub Projects v2
# Usage:
#   get-issue-column.sh                # defaults to Status == "Ready"
#   get-issue-column.sh "In Progress"  # Status == "In Progress"
#
# Output: JSON array of issues with fields: title, url, number

set -euo pipefail

STATUS_NAME="${1:-Ready}"

gh api graphql -f query='
  query {
    user(login: "SiderealMollusk") {
      projectV2(number: 5) {
        items(first: 100) {
          nodes {
            content {
              __typename
              ... on Issue {
                title
                url
                number
              }
            }
            fieldValues(first: 20) {
              nodes {
                __typename
                ... on ProjectV2ItemFieldSingleSelectValue {
                  name
                  field {
                    ... on ProjectV2FieldCommon {
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
' | jq -r --arg status "$STATUS_NAME" '
  [
    .data.user.projectV2.items.nodes[]
    | select(.content.__typename == "Issue")
    | select(
        [.fieldValues.nodes[]?
          | select(
              .__typename == "ProjectV2ItemFieldSingleSelectValue"
              and .field.name == "Status"
              and .name == $status
            )
        ] | length > 0
      )
    | {
        title: .content.title,
        url: .content.url,
        number: .content.number
      }
  ]
'