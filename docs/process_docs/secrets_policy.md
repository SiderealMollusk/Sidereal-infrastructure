# Secrets & Token Management (Project Sync)

This document lists the security steps and placeholders you must manage to operate the Project Sync workflow safely.

DO NOT commit any real tokens, IDs, or secrets to the repo. Replace values with the placeholders shown below.

## Required secrets (placeholders)

- PROJECT_SYNC_TOKEN: <PROJECT_SYNC_TOKEN>
  - Purpose: PAT used by the Action to call the Projects REST API and create/move cards.
  - Scope: repo (read/write), projects (read/write) OR fine-grained equivalent. Least privilege is recommended.

- BACKLOG_COLUMN_ID: <BACKLOG_COLUMN_ID>
  - Purpose: Numeric column ID for the Backlog column in your user project. Used by the Action to create cards.
  - Value type: integer (e.g., 12345678)

## Example: set secrets with gh (replace placeholders)

```bash
# Add PAT (do not paste token into files)
echo -n "<PROJECT_SYNC_TOKEN>" | gh secret set PROJECT_SYNC_TOKEN --repo SiderealMollusk/Sidereal-infrastructure --body -

# Add numeric column id
echo -n "<BACKLOG_COLUMN_ID>" | gh secret set BACKLOG_COLUMN_ID --repo SiderealMollusk/Sidereal-infrastructure --body -
```

## PAT creation checklist (guidance)

- Use a fine-grained personal access token when possible.
- Minimum privileges required:
  - Repository: read & write (or selected repo access)
  - Projects: read & write (if using classic user projects) OR appropriate GraphQL scopes for Projects (beta)
- Avoid granting unnecessary org-wide permissions.
- Name the token clearly: `sidereal-infra/project-sync-YYYYMMDD`.
- Record the token creation date and purpose in your password manager or vault; do not store token plaintext in the repo.

## Rotation policy

- Rotate the `PROJECT_SYNC_TOKEN` every 90 days (or sooner if personnel changes or suspected compromise).
- When rotating:
  1. Create new token with same minimal scopes.
  2. Immediately add the new token to repo secret `PROJECT_SYNC_TOKEN`.
  3. Verify the Action runs successfully using the new token (create a test issue).
  4. Revoke the old token in GitHub.

## Least-privilege & alternatives

- If you can, prefer repo-level projects (owned by the repository) or organization projects where the `GITHUB_TOKEN` or org-installation tokens can be used and scoped more tightly.
- For user-level projects, `GITHUB_TOKEN` often lacks the required scope; a PAT is usually required.

## Access control & audit

- Use GitHub audit logs to track who created/rotated tokens (if using org account).
- Limit who can update repo secrets in the repository settings.
- For sensitive workflows, consider storing tokens in a central vault (HashiCorp Vault, AWS Secrets Manager) and reference them via GitHub Actions OIDC or self-hosted runners.

## Emergency revocation

If you suspect a token is compromised:
1. Remove the secret from the repo (`gh secret delete PROJECT_SYNC_TOKEN --repo ...`).
2. Revoke the token immediately at https://github.com/settings/tokens.
3. Investigate recent Action runs and repository pushes for suspicious activity.
4. Create a new token and reconfigure secrets after remediation.

## Troubleshooting tips

- Action fails with 401/403: verify `PROJECT_SYNC_TOKEN` is valid and has the required scopes.
- API 404 when calling projects endpoints: confirm you are using the classic Projects REST API (`Accept: application/vnd.github.inertia-preview+json`) for user projects; Beta Projects use a different API.
- Duplicate cards: check if the Action ran multiple times for the same issue; the workflow includes a guard to skip creation if a card already exists in the Backlog column.

## Example placeholders (do not use literal values in real life)

- PROJECT_SYNC_TOKEN: <PROJECT_SYNC_TOKEN>
- BACKLOG_COLUMN_ID: <BACKLOG_COLUMN_ID>

## Follow-ups (recommended)

- Move project ownership to a repo-level or org-level project if you want to avoid PATs for user-level projects.
- Consider restricting who can create tokens and who can write repo secrets.


*File created by automation — placeholders intentionally used.*
