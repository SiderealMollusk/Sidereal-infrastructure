#!/usr/bin/env bash
# List issues in the "Ready" (or given) status for a GitHub Projects v2 user project
# Default: user = SiderealMollusk, project number = 5, status = Ready

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