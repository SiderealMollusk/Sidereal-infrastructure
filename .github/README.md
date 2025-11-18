# GitHub Workflows Configuration

This directory contains automated GitHub Actions workflows for the Sidereal-infrastructure repository.

## Available Workflows

### Add Issue to Project Board (`add-to-project.yml`)

Automatically adds newly created issues to the project board at https://github.com/users/SiderealMollusk/projects/5.

**Trigger**: When a new issue is opened (not pull requests)

**What it does**:
- Detects when a new issue is created
- Automatically adds the issue to your GitHub Project board
- Places it in the appropriate column (typically "Backlog" or as configured in project automation)

## Setup Instructions

### 1. Create a Personal Access Token (PAT)

The workflow requires a GitHub Personal Access Token with the necessary permissions.

#### Option A: Classic Token (Recommended for simplicity)

1. Go to [GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)](https://github.com/settings/tokens)
2. Click "Generate new token (classic)"
3. Give it a descriptive name: "Sidereal Infrastructure Project Automation"
4. Select the following scopes:
   - ✅ `repo` - Full control of private repositories
   - ✅ `project` - Full control of projects
5. Set an appropriate expiration (or no expiration if you trust the security)
6. Click "Generate token"
7. **Copy the token immediately** (you won't be able to see it again)

#### Option B: Fine-grained Token (More secure)

1. Go to [GitHub Settings → Developer settings → Personal access tokens → Fine-grained tokens](https://github.com/settings/personal-access-tokens/new)
2. Name: "Sidereal Infrastructure Project Automation"
3. Repository access: Select "Only select repositories" → Choose `SiderealMollusk/Sidereal-infrastructure`
4. Permissions:
   - Repository permissions:
     - ✅ Issues: Read and write
   - Account permissions:
     - ✅ Projects: Read and write
5. Click "Generate token"
6. **Copy the token immediately**

### 2. Add the Token as a Repository Secret

1. Go to [Repository Settings → Secrets and variables → Actions](https://github.com/SiderealMollusk/Sidereal-infrastructure/settings/secrets/actions)
2. Click "New repository secret"
3. Name: `ADD_TO_PROJECT_PAT`
4. Value: Paste your copied token
5. Click "Add secret"

### 3. Configure Your Project Board

#### For GitHub Projects V2 (Modern, Recommended)

1. Ensure your project at https://github.com/users/SiderealMollusk/projects/5 is a Projects V2 project
2. Set up project automation (optional but recommended):
   - Go to your project → Click "..." menu → Settings
   - Navigate to "Workflows" section
   - Enable "Item added to project" workflow
   - Set action: "Set status to Backlog" (or your preferred default column)

#### For Classic Projects (Legacy)

If you're using a Classic Project (older project type):
1. The workflow file includes commented-out alternative code
2. Edit `.github/workflows/add-to-project.yml`
3. Comment out the current job (lines with `actions/add-to-project`)
4. Uncomment the "ALTERNATIVE: FOR CLASSIC PROJECTS" section
5. Ensure your project has a column named "Backlog" (or update the column name in the script)

### 4. Verify the Setup

1. Create a test issue in the repository
2. Go to the "Actions" tab in GitHub
3. You should see the "Add Issue to Project Board" workflow running
4. Check your project board - the issue should appear in the Backlog column
5. If it fails:
   - Check the workflow run logs for detailed error messages
   - Verify the PAT has the correct permissions
   - Ensure the project URL is correct
   - Confirm the project/column exists

## Troubleshooting

### Workflow fails with "Resource not accessible by integration"

**Cause**: The PAT token doesn't have sufficient permissions.

**Solution**: 
- Regenerate the token with `repo` and `project` scopes
- Update the `ADD_TO_PROJECT_PAT` secret with the new token

### Workflow fails with "Could not find project"

**Cause**: The project URL is incorrect or the project doesn't exist.

**Solution**:
- Verify the project exists at https://github.com/users/SiderealMollusk/projects/5
- Check if it's a Projects V2 vs Classic Project
- Ensure the PAT has access to user-level projects

### Issue is added to project but not to "Backlog" column

**Cause**: Projects V2 doesn't automatically set status; Classic Projects might not have the column.

**Solution**:
- For Projects V2: Set up project automation workflows (see step 3 above)
- For Classic Projects: Ensure a column named "Backlog" exists
- Alternatively, manually move items or set up field defaults in project settings

### Workflow doesn't trigger at all

**Cause**: Workflow file might have syntax errors or be disabled.

**Solution**:
- Check the Actions tab for any error messages
- Verify the workflow file is in the correct location: `.github/workflows/add-to-project.yml`
- Ensure workflows are enabled in repository settings
- Check that you're creating issues, not pull requests (PRs are excluded)

## Customization

### Change the target column name

For Classic Projects, edit the workflow and change `"Backlog"` to your desired column name in the jq filter.

### Add issues with specific labels only

Uncomment and modify the `labeled` line in the workflow:
```yaml
labeled: bug, enhancement  # Only add issues with these labels
```

### Add to multiple columns based on labels

You can create multiple workflow files with different triggers and column targets.

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Projects V2 Documentation](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [GitHub API - Classic Projects](https://docs.github.com/en/rest/projects)
- [actions/add-to-project Action](https://github.com/actions/add-to-project)

## Security Notes

- The PAT token is stored securely as a GitHub Secret
- Never commit the PAT token to the repository
- Use fine-grained tokens when possible for better security
- Regularly rotate tokens and use expiration dates
- The workflow only runs on issue creation, limiting potential abuse
- Only issues (not PRs) are processed to prevent misuse
