#!/usr/bin/env bash
set -euo pipefail

#Pass scripts/workflows/utils/isReadyForNewIssue.sh
scripts/workflows/utils/isReadyForNewIssue.sh

## copy template file llm-ignorable
cp scripts/workflows/L3/l3-queue-template.yaml llm-ignorable/
