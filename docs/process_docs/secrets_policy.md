# Secrets Policy

This document tracks all secrets used in the system, where they are stored, and how to rotate them. Confidence is noted on each entry, along with whether this assistant has seen the secret content directly.

---

## 1. GitHub Personal Access Token (PAT) (Old Info, we cleaned up the Repo level)

- **Usage**: Used for syncing issues to GitHub Projects via GitHub Actions.
- **Stored in**: GitHub repo secrets
  - `PROJECT_SYNC_TOKEN`
  - `BACKLOG_COLUMN_ID`
- **How to cycle**:
  1. Visit https://github.com/settings/tokens
  2. Revoke the existing token or generate a new fine-grained token.
  3. Add the new token to the repository secrets page under the same name.
- **Confidence**: High
- **Seen by assistant**: No

---

## 2. Kubernetes Config (`kubeconfig`)

- **Usage**: Accessing the cluster from dev environments (e.g. your MacBook).
- **Stored in**: Local filesystem
  - Primary location: `$HOME/.kube/config`
  - Temporary source: `/Users/virgil/Developer/k8/tmp/config`
- **How to cycle**: Re-fetch via the script `scripts/kubectl-config-local.sh`, which copies the config from the K3s node.
- **Confidence**: High
- **Seen by assistant**: Yes (partial content during config setup)

---

## Format for New Secrets

```
## X. <Name of Secret>

- **Usage**: <Brief description>
- **Stored in**: <Where it's stored (vault, env var, GitHub, etc.)>
- **How to cycle**: <Instructions or link>
- **Confidence**: <High | Medium | Low>
- **Seen by assistant**: <Yes | No>
```

Add new entries below as more secrets are introduced.
