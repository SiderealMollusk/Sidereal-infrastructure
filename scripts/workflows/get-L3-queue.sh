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
            ... on PullRequest {
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
' -F login=SiderealMollusk -F number=5