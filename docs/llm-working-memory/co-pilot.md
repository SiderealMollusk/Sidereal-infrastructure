# GitHub Migration Plan for Sidereal Infrastructure

## Overview
Migrate planning documents and tasks from `/planning` directory to GitHub Issues, Milestones, and Projects for centralized tracking and collaboration.

---

## Phase 1: GitHub Repository Setup

✅ **COMPLETED**
- Repository created: `Sidereal-infrastructure`
- Owner: `SiderealMollusk`
- URL: https://github.com/SiderealMollusk/Sidereal-infrastructure
- Local directory pushed to remote

---

## Phase 2: Create GitHub Milestones

Create milestones corresponding to the 11 major phases from `milestones_00_TableOfContents.md`:

### Milestone Structure

| # | Milestone | Duration | Status |
|---|-----------|----------|--------|
| 1 | Foundation | 1-2 weeks | Not Started |
| 2 | Developer Tooling | 1-2 weeks | Planned |
| 3 | LLM Infrastructure | 1-2 weeks | Planned |
| 4 | Communication Stack | 1-2 weeks | Planned |
| 5 | Messaging Intake | 1-2 weeks | Planned |
| 6 | Game Services | 1-2 weeks | Planned |
| 7 | CI Integration | 1 week | Planned |
| 8 | Deployment Flows | 1 week | Planned |
| 9 | Observability | 1-2 weeks | Planned |
| 10 | Stabilization | 2-3 weeks | Planned |
| 11 | Expansion (Optional) | TBD | Planned |

---

## Phase 3: Create Issues for Milestone 01 (Foundation)

### Source: `milestones_01.md`

**Objective**: Establish the minimum, reliable base on which the entire Office-in-a-Repo system will run.

#### Issue 1.1: Verify Cluster Reachability
- **Title**: Verify MacBook can kubectl to i3 cluster
- **Description**: 
  - Confirm that kubectl on the Mac can reach the cluster API server.
  - If using k3s: ensure the KUBECONFIG is copied or accessible remotely.
  - Validate node status: run "kubectl get nodes".
- **Acceptance Criteria**:
  - [ ] "kubectl get nodes" from the Mac shows at least one Ready node
  - [ ] kubectl commands do not hang or require sudo
  - [ ] Network path between Mac and i3 box is stable
- **Milestone**: Foundation
- **Priority**: P0
- **Labels**: `component:infra`, `type:setup`, `status:blocked`

#### Issue 1.2: Install Baseline Kubernetes Components
- **Title**: Verify container runtime (containerd/Docker)
- **Description**: Verify the i3 box runs containerd or Docker compatible with k8s.
- **Acceptance Criteria**:
  - [ ] Container runtime verified on i3 box
  - [ ] Version compatible with k8s
- **Milestone**: Foundation
- **Priority**: P1
- **Labels**: `component:infra`, `type:setup`

#### Issue 1.3: Ensure Storage Provisioning
- **Title**: Ensure StorageClass exists
- **Description**: 
  - Check for an existing default StorageClass.
  - If missing, install a simple local-path provisioner.
- **Acceptance Criteria**:
  - [ ] A valid StorageClass exists
  - [ ] StorageClass is set as default
- **Milestone**: Foundation
- **Priority**: P1
- **Labels**: `component:infra`, `type:setup`

#### Issue 1.4: Install Helm on MacBook
- **Title**: Install Helm on MacBook
- **Description**: Required for Coder, ingress controller, and later components.
- **Acceptance Criteria**:
  - [ ] helm version returns valid client/server info when using the Mac
  - [ ] Helm can access the cluster from MacBook
- **Milestone**: Foundation
- **Priority**: P1
- **Labels**: `component:infra`, `type:setup`

#### Issue 1.5: Create Project Namespaces
- **Title**: Create k8s namespaces manifest
- **Description**: 
  - Create k8s/namespaces.yaml containing all namespaces to bootstrap via kubectl apply.
  - Namespaces: infra, coder, llm, messaging, matrix, game
  - Add this to repository.
- **Acceptance Criteria**:
  - [ ] k8s/namespaces.yaml created with all required namespaces
  - [ ] "kubectl get ns" lists: infra, coder, llm, messaging, matrix, game
  - [ ] Reapplying namespaces.yaml is idempotent
- **Milestone**: Foundation
- **Priority**: P0
- **Labels**: `component:infra`, `type:implementation`

#### Issue 1.6: Initialize Repository Structure
- **Title**: Initialize repo structure and scripts
- **Description**: 
  - Create base directories: scripts/, k8s/, k8s/infra/, k8s/coder/, k8s/llm/, k8s/messaging/, k8s/matrix/, k8s/game/, .run/
  - Add office.config.yaml with seed configuration
  - Create initial scripts: cluster-up, bootstrap-namespaces, install-ingress, install-coder, status
  - Add .gitignore
- **Acceptance Criteria**:
  - [ ] All required directories exist
  - [ ] office.config.yaml exists with placeholder structure
  - [ ] All scripts exist and run (even if just echoing TODO)
  - [ ] .gitignore includes .run/, logs, kubeconfig backups
- **Milestone**: Foundation
- **Priority**: P0
- **Labels**: `component:infra`, `type:implementation`
- **Sub-issues**:
  - Create scripts/ directory structure
  - Create k8s/ directory structure
  - Create placeholder scripts
  - Add office.config.yaml template
  - Add .gitignore

#### Issue 1.7: Validation Before Proceeding
- **Title**: Run dry-run validation for Foundation milestone
- **Description**: 
  - Run scripts/cluster-up.
  - Run scripts/bootstrap-namespaces.
  - Run scripts/status.
  - Ensure repo is ready for Milestone 02.
- **Acceptance Criteria**:
  - [ ] Cluster is reachable
  - [ ] Namespaces created successfully
  - [ ] Scripts run without failure
  - [ ] Repo is ready for Milestone 02 (Developer Tooling)
- **Milestone**: Foundation
- **Priority**: P0
- **Labels**: `component:infra`, `type:testing`, `status:blocked`

---

## Phase 4: Create GitHub Project Board

**Name**: Sidereal Infrastructure Tracker

**Columns**:
1. **Backlog** - Issues not yet started
2. **In Progress** - Currently being worked on
3. **In Review** - Awaiting review or acceptance testing
4. **Done** - Completed and verified

---

## Phase 5: Issue Labels (Standard Taxonomy)

### Component Labels
- `component:infra`
- `component:coder`
- `component:llm`
- `component:messaging`
- `component:matrix`
- `component:game`

### Type Labels
- `type:setup` - Initial configuration/installation
- `type:implementation` - Feature development
- `type:testing` - Validation/testing
- `type:bugfix` - Bug fixes
- `type:docs` - Documentation

### Priority Labels
- `priority:P0` - Critical path, blocks other work
- `priority:P1` - High priority
- `priority:P2` - Nice to have

### Status Labels
- `status:blocked` - Waiting on something else
- `status:in-progress` - Currently being worked
- `status:review` - Awaiting review
- `status:needs-investigation` - Requires exploration

---

## Phase 6: Future Milestone Issues

For each remaining milestone (2-11), follow the same pattern:
1. Analyze the milestone objectives from `milestones_00_TableOfContents.md`
2. Break down into individual issues
3. Assign to GitHub Milestone
4. Add appropriate labels
5. Link related issues using "Related to" or "Blocks"

---

## Phase 7: Integration with Development

### Developer Workflow
1. Pick issue from "Backlog" or "In Progress"
2. Create branch: `git checkout -b feature/issue-#123`
3. Make changes and push
4. Create PR linked to issue
5. Move issue to "In Review"
6. Upon merge, move issue to "Done"

### Commands
```bash
# View all issues for a milestone
gh issue list --milestone "Foundation"

# Create branch linked to issue
git checkout -b issue-#123

# Link PR to issue
gh pr create --body "Closes #123"
```

---

## Status Tracking

| Phase | Task | Status |
|-------|------|--------|
| 1 | Create GitHub repo | ✅ Complete |
| 2 | Create 11 milestones | ⏳ TODO |
| 3 | Create M01 issues (7 issues) | ⏳ TODO |
| 4 | Create project board | ⏳ TODO |
| 5 | Define issue labels | ⏳ TODO |
| 6 | Create M02-M11 issues | ⏳ TODO |
| 7 | Document dev workflow | ✅ Complete |

---

## Next Steps
1. Run `gh milestone create` for milestones 1-11
2. Create 7 issues for Foundation milestone
3. Set up GitHub Project board
4. Move to Milestone 02 planning
