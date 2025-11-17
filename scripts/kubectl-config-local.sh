#!/usr/bin/env bash
set -euo pipefail

# kubectl-config-local.sh
#
# Helper script to pull the k3s kubeconfig from the NUC and
# write a local copy that points at the NUC's Tailscale hostname.
#
# Default remote host and path can be overridden with env vars:
#   NUC_HOST=some-host ./scripts/kubectl-config-local.sh
#   REMOTE_KUBECONFIG_PATH=/path/to/kubeconfig ./scripts/kubectl-config-local.sh

NUC_HOST="${NUC_HOST:-virgil-nucboxg5}"
REMOTE_KUBECONFIG_PATH="${REMOTE_KUBECONFIG_PATH:-/etc/rancher/k3s/k3s.yaml}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$ROOT_DIR/tmp"
LOCAL_CONFIG="$TMP_DIR/config"

mkdir -p "$TMP_DIR"

echo "[kubectl-config-local] fetching kubeconfig from $NUC_HOST ..."

# prompt for NUC sudo password (not saved anywhere)
echo -n "Enter sudo password for $NUC_HOST: "
read -s NUC_PW
echo

# fetch kubeconfig using sudo with password passed over stdin
ssh -t "$NUC_HOST" "sudo -S cat '$REMOTE_KUBECONFIG_PATH'" <<< "$NUC_PW" > "$LOCAL_CONFIG.raw"

echo "[kubectl-config-local] rewriting server address to use $NUC_HOST ..."
awk -v host="$NUC_HOST" '
  /^    server: https:\/\/127\.0\.0\.1:6443/ { sub("127.0.0.1", host); }
  { print }
' "$LOCAL_CONFIG.raw" > "$LOCAL_CONFIG"

rm "$LOCAL_CONFIG.raw"

echo "[kubectl-config-local] wrote $LOCAL_CONFIG"
echo
echo "To use this kubeconfig for a single command:"
echo "  KUBECONFIG=\"$LOCAL_CONFIG\" kubectl get nodes"
echo
echo "To make it your default kubeconfig:"
echo "  mkdir -p \$HOME/.kube"
echo "  cp \"$LOCAL_CONFIG\" \$HOME/.kube/config"
echo