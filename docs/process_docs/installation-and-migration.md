# Installation & Migration Guide

## Overview

This document tracks the process, decisions, and procedures for installing, upgrading, and migrating components within the Home Office Cluster.

## Goals

- Provide clear, repeatable installation steps.
- Document migration paths between versions or architectures.
- Capture pitfalls, gotchas, and environment-specific notes.

## System Components

- Kubernetes (k3s-based cluster)
- Developer toolchain
- Messaging stack
- LLM compute nodes
- Storage and persistence layers

## Prerequisites

- Hardware roles: MacBook as cockpit, NUC as control-plane/worker, NVIDIA laptop as future LLM worker.
- Tailscale installed and authenticated on all nodes.
- SSH access (root password must be known for privileged operations).
- Basic Unix familiarity and repo cloned locally.

## Installation Steps

### 1. Bootstrapping the NUC

Install Ubuntu, create user 'virgil', install Tailscale and log in. Enable UFW with basic rules. Apply anti-sleep by editing /etc/systemd/logind.conf to ignore lid and idle actions. Install base packages (git, htop, curl, jq). Harden SSH (disable root login, disable password auth once keys are in place). Root password is required for certain sudo or remote retrieval operations.

### 2. Bringing Up k3s

Install k3s via the lightweight installer. Verify service status and node readiness. Retrieve kubeconfig from /etc/rancher/k3s/k3s.yaml. K3s uses containerd built-in; no Docker required.

### 3. Connecting Mac Cockpit

Mac must be online in the same Tailscale network. Clone the k8 repo and run the kubectl-config-local.sh script to pull and rewrite kubeconfig. Place config at ~/.kube/config or use via KUBECONFIG environment variable. Test with kubectl get nodes.

### 4. First Deployments

Deploy a simple test workload (nginx or hello-world). Validate pod readiness and logs. Use kubectl port-forward for quick validation. Confirm cluster health before installing higher-level services.

## Migration Procedures

### Version Upgrades

(to be filled in)

### Hardware / Node Migration

### Data Migration

(to be filled in)

## Validation & Testing

(to be filled in)

## Troubleshooting

(to be filled in)
