# ProjectV2 Implementation Plan for Project Sync Workflow

## Overview
**Greenfield setup:** Create a new ProjectV2 board from scratch and build the issue-to-project automation using GraphQL API. All projects deleted; starting fresh.

## Step 1: Create ProjectV2 Board

**Via CLI:**
```bash
# Create a new ProjectV2 board
gh project create --owner SiderealMollusk --title "Sidereal Infrastructure Board" --format table --public

# This returns a project number (e.g., 1). Note it down.
```

**Setup the board structure (via UI or GraphQL):**
- Create a "Status" field (single-select) with values: Backlog, In Progress, In Review, Done
- Default new items to "Backlog" status
- Create a "Backlog" view (board or table view filtering by Status=Backlog)

## Step 2: Rewrite Workflow for ProjectV2 (GraphQL)

Build a workflow that:
1. **Gets the project ID** by querying for the known project title "Sidereal Infrastructure Board" (we just created it in Step 1)
2. **Queries the Status field** within the project to get its field ID
3. **Checks for duplicate items** linked to the same issue
4. **Creates a project item** linked to the issue and sets Status to "Backlog"

**GraphQL operations in the workflow:**

1. `query Repository` — get the project by title within the repository
2. `query ProjectV2` — fetch project fields (Status field ID)
3. `query ProjectV2Items` — check if issue is already linked to a project item
4. `mutation AddProjectV2ItemById` — create new project item linked to the issue
5. `mutation UpdateProjectV2ItemFieldValue` — set Status field to "Backlog"

## Step 3: Handle Permissions

**GITHUB_TOKEN scopes:**
- By default, `GITHUB_TOKEN` in Actions has limited project access.
- For ProjectV2 write access, you may need a fine-grained PAT with:
  - `repo` read/write (for issues)
  - `project` write (for project items)
- Or check if Actions runner's GITHUB_TOKEN has sufficient scopes in your org settings.

**TOKEN fallback logic:**
```bash
TOKEN="${PROJECT_SYNC_TOKEN:-$GITHUB_TOKEN}"
# Use PROJECT_SYNC_TOKEN (fine-grained PAT) if available, else GITHUB_TOKEN
```

## Step 4: Test Workflow

1. Create test issue (e.g., issue #10)
2. Workflow triggers on `issues.opened`
3. GraphQL queries and mutations execute: get project, check for duplicates, create item, set Status
4. Verify in UI: Board should show the new issue in Backlog

## Step 5: Update Repository Configuration

**Repository variables** (no changes needed):
- `PROJECT_NAME` already set to "Sidereal Infrastructure Board" — reuse for finding project by title

**Repository secrets** (review/update):
- `PROJECT_SYNC_TOKEN` — ensure it has project read/write if GITHUB_TOKEN is insufficient

## Advantages of ProjectV2

✓ Custom fields (Status, Priority, Assignee, etc.)
✓ Multiple views (board, table, roadmap)
✓ More flexible item linking (issues, PRs, drafts)
✓ Better UI/UX
✓ Native to GitHub's current direction

## Timeline

- **Step 1 (Create board):** ~2 min (manual or CLI)
- **Step 2 (Rewrite workflow):** ~30-45 min (write GraphQL, test)
- **Step 3 (Verify permissions):** ~5 min
- **Step 4 (Test):** ~5 min (create issue, watch run)
- **Step 5 (Document):** ~5 min

**Total: ~1 hour end-to-end**

## Rollback Plan

Not applicable. This is greenfield — no prior workflow to revert to. If ProjectV2 workflow has issues:
- Disable the workflow: rename `.github/workflows/project-sync.yml` to `.github/workflows/project-sync.yml.disabled`
- Issues will continue to be created but not added to the project
- Or delete the workflow file and re-enable manual issue management

## Notes

- ProjectV2 is the direction GitHub is moving; investing in it now is future-proof
- GraphQL queries are more verbose but more powerful than REST
- Workflow will be slightly more complex (multi-line GraphQL payloads) but maintainable
