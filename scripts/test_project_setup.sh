#!/usr/bin/env bash
# Script to test and validate the project board setup for the add-to-project workflow
# Run this locally where you have gh CLI authenticated with appropriate permissions

set -euo pipefail

OWNER="SiderealMollusk"
PROJECT_NUMBER=5
REPO="Sidereal-infrastructure"

echo "=========================================="
echo "Project Board Setup Validation Tool"
echo "=========================================="
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) is not installed"
    echo "   Install from: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Error: Not authenticated with GitHub CLI"
    echo "   Run: gh auth login"
    exit 1
fi

echo "✅ GitHub CLI is installed and authenticated"
echo ""

echo "Checking project type and accessibility..."
echo "=========================================="
echo ""

# Try Projects V2 API (GraphQL)
echo "1. Checking for Projects V2..."
PROJECTS_V2=$(gh api graphql -f query='
  query($owner: String!) {
    user(login: $owner) {
      projectsV2(first: 20) {
        nodes {
          number
          title
          url
        }
      }
    }
  }
' -f owner="$OWNER" 2>&1 || echo "")

if echo "$PROJECTS_V2" | grep -q "projectsV2"; then
    echo "   Found Projects V2:"
    echo "$PROJECTS_V2" | jq -r '.data.user.projectsV2.nodes[] | "   - Project #\(.number): \(.title) (\(.url))"' 2>/dev/null || true
    
    PROJECT_V2_EXISTS=$(echo "$PROJECTS_V2" | jq -r ".data.user.projectsV2.nodes[] | select(.number == $PROJECT_NUMBER) | .title" 2>/dev/null || echo "")
    
    if [ -n "$PROJECT_V2_EXISTS" ]; then
        echo ""
        echo "✅ Found Projects V2 project #$PROJECT_NUMBER: $PROJECT_V2_EXISTS"
        echo "   The workflow will use actions/add-to-project action"
        echo ""
        echo "   Recommended: Set up project automation:"
        echo "   1. Go to your project settings"
        echo "   2. Navigate to 'Workflows'"
        echo "   3. Enable 'Item added to project' → 'Set status to Backlog'"
        exit 0
    fi
fi

echo ""
echo "2. Checking for Classic Projects..."

# Try Classic Projects API (REST)
CLASSIC_PROJECTS=$(gh api "users/$OWNER/projects" \
    -H "Accept: application/vnd.github.inertia-preview+json" 2>&1 || echo "")

if echo "$CLASSIC_PROJECTS" | jq -e '. | length > 0' &> /dev/null; then
    echo "   Found Classic Projects:"
    echo "$CLASSIC_PROJECTS" | jq -r '.[] | "   - Project #\(.number): \(.name) (ID: \(.id))"' 2>/dev/null || true
    
    PROJECT_ID=$(echo "$CLASSIC_PROJECTS" | jq -r ".[] | select(.number == $PROJECT_NUMBER) | .id" 2>/dev/null || echo "")
    
    if [ -n "$PROJECT_ID" ]; then
        echo ""
        echo "✅ Found Classic Project #$PROJECT_NUMBER (ID: $PROJECT_ID)"
        echo ""
        echo "   Checking for 'Backlog' column..."
        
        COLUMNS=$(gh api "projects/$PROJECT_ID/columns" \
            -H "Accept: application/vnd.github.inertia-preview+json" 2>&1 || echo "")
        
        echo "   Available columns:"
        echo "$COLUMNS" | jq -r '.[] | "   - \(.name) (ID: \(.id))"' 2>/dev/null || echo "   (Failed to fetch columns)"
        
        BACKLOG_COLUMN=$(echo "$COLUMNS" | jq -r '.[] | select(.name == "Backlog") | .id' 2>/dev/null || echo "")
        
        if [ -n "$BACKLOG_COLUMN" ]; then
            echo ""
            echo "✅ Found 'Backlog' column (ID: $BACKLOG_COLUMN)"
        else
            echo ""
            echo "⚠️  Warning: No 'Backlog' column found"
            echo "   You may need to:"
            echo "   - Create a 'Backlog' column in your project, OR"
            echo "   - Update the workflow to use a different column name"
        fi
        
        echo ""
        echo "⚠️  IMPORTANT: This is a Classic Project"
        echo "   The default workflow uses Projects V2 (actions/add-to-project)"
        echo "   You need to edit .github/workflows/add-to-project.yml:"
        echo "   1. Comment out the main job"
        echo "   2. Uncomment the 'ALTERNATIVE: FOR CLASSIC PROJECTS' section"
        exit 0
    fi
fi

echo ""
echo "❌ Could not find project #$PROJECT_NUMBER"
echo ""
echo "Troubleshooting:"
echo "1. Verify the project exists at https://github.com/users/$OWNER/projects/$PROJECT_NUMBER"
echo "2. Ensure your PAT has 'project' scope"
echo "3. Make sure the project is not archived or deleted"
echo ""

exit 1
