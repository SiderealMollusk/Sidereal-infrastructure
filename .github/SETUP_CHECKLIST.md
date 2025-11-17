# Project Board Automation - Setup Checklist

This checklist will guide you through setting up the automatic issue-to-project workflow.

## Quick Setup (5 minutes)

### ☐ Step 1: Create Personal Access Token (2 min)

1. Go to: https://github.com/settings/tokens
2. Click **"Generate new token (classic)"**
3. Name it: `Sidereal Infrastructure Project Bot`
4. Select scopes:
   - [x] `repo` (Full control of private repositories)
   - [x] `project` (Full control of projects)
5. Click **"Generate token"**
6. **Copy the token** (you won't see it again!)

### ☐ Step 2: Add Secret to Repository (1 min)

1. Go to: https://github.com/SiderealMollusk/Sidereal-infrastructure/settings/secrets/actions
2. Click **"New repository secret"**
3. Name: `ADD_TO_PROJECT_PAT`
4. Value: *paste your token from step 1*
5. Click **"Add secret"**

### ☐ Step 3: Verify Project Setup (1 min)

Run the test script locally to check your project configuration:

```bash
./scripts/test_project_setup.sh
```

This will tell you:
- Whether your project is Projects V2 or Classic
- If the workflow will work as-is or needs modification
- If your "Backlog" column exists (for Classic projects)

### ☐ Step 4: Configure Project Automation (1 min) - Projects V2 Only

If using Projects V2:

1. Go to: https://github.com/users/SiderealMollusk/projects/5
2. Click **"..."** menu → **"Settings"**
3. Navigate to **"Workflows"**
4. Enable **"Item added to project"**
5. Set action: **"Set status to Backlog"**

This ensures new issues go directly to the Backlog column.

### ☐ Step 5: Test the Workflow (< 1 min)

1. Create a test issue in this repository
2. Go to the **"Actions"** tab
3. Watch the **"Add Issue to Project Board"** workflow run
4. Check your project board - the issue should appear!

## If Using Classic Projects

If `test_project_setup.sh` indicates you're using a Classic Project:

1. Edit `.github/workflows/add-to-project.yml`
2. Comment out lines 10-25 (the main job)
3. Uncomment lines 89-141 (the Classic Projects alternative)
4. Ensure you have a column named "Backlog" in your project

## Troubleshooting

### ❌ "Resource not accessible by integration"

**Problem**: Token lacks permissions

**Fix**: 
- Ensure PAT has both `repo` and `project` scopes
- Regenerate token if needed
- Update the `ADD_TO_PROJECT_PAT` secret

### ❌ "Could not find project"

**Problem**: Project URL is incorrect or inaccessible

**Fix**:
- Verify project exists: https://github.com/users/SiderealMollusk/projects/5
- Run `./scripts/test_project_setup.sh` to diagnose
- Check if project is archived

### ❌ Issue added but not in "Backlog" column

**Problem**: Project automation not configured (Projects V2)

**Fix**:
- Complete Step 4 above to set up automation
- Or manually move items in the project

### ⚠️ Workflow doesn't run

**Problem**: Workflow file has errors or is disabled

**Fix**:
- Check Actions tab for error messages
- Verify file is at `.github/workflows/add-to-project.yml`
- Ensure you're creating issues, not PRs

## Files Created

- `.github/workflows/add-to-project.yml` - Main workflow file
- `.github/README.md` - Detailed documentation
- `.github/SETUP_CHECKLIST.md` - This file
- `scripts/test_project_setup.sh` - Validation tool

## Need Help?

- See `.github/README.md` for detailed documentation
- Check the workflow file comments for inline documentation
- GitHub Actions docs: https://docs.github.com/en/actions
- Projects V2 docs: https://docs.github.com/en/issues/planning-and-tracking-with-projects

---

**Note**: This workflow only triggers on new issues, not pull requests. This is intentional to prevent PRs from cluttering your project board.
