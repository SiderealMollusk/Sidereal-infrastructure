

Milestone 01 — Foundation

Objective  
Establish the minimum, reliable base on which the entire Office-in-a-Repo system will run. This milestone ensures the home cluster is reachable, namespaces exist, and the repo has its initial structure with scripts and manifests.

---

1. Verify Cluster Reachability

1.1 Task — Validate that MacBook can contact the i3 cluster  
- Confirm that kubectl on the Mac can reach the cluster API server.  
- If using k3s: ensure the KUBECONFIG is copied or accessible remotely.  
- Validate node status: run "kubectl get nodes".

1.2 Acceptance Criteria  
- “kubectl get nodes” from the Mac shows at least one Ready node.  
- kubectl commands do not hang or require sudo.  
- Network path between Mac and i3 box is stable.

---

2. Install Baseline Kubernetes Components

2.1 Task — Confirm container runtime  
- Verify the i3 box runs containerd or Docker compatible with k8s.

2.2 Task — Ensure storage provisioning  
- Check for an existing default StorageClass.  
- If missing, install a simple local-path provisioner.

2.3 Task — Install Helm on the MacBook  
- Required for Coder, ingress controller, and later components.

2.4 Acceptance Criteria  
- A valid StorageClass exists.  
- helm version returns valid client/server info when using the Mac.  
- cluster reports zero critical warnings.

---

3. Create Project Namespaces

3.1 Task — Create initial namespaces  
Namespaces to create:
- infra
- coder
- llm
- messaging
- matrix
- game

3.2 Task — Add namespace manifest  
- Create k8s/namespaces.yaml containing all namespaces to bootstrap via kubectl apply.  
- Add this to repository.

3.3 Acceptance Criteria  
- “kubectl get ns” lists all the above namespaces.  
- Reapplying namespaces.yaml is idempotent.

---

4. Commit Initial Repo Structure

4.1 Task — Create base repo folders  
Directories:
- scripts/
- k8s/
- k8s/infra/
- k8s/coder/
- k8s/llm/
- k8s/messaging/
- k8s/matrix/
- k8s/game/
- .run/ (gitignored)

4.2 Task — Add office.config.yaml  
- Seed with cluster_name, enabled stacks, and placeholder llm/provider configuration.

4.3 Task — Create initial scripts  
Scripts:
- cluster-up
- bootstrap-namespaces
- install-ingress (empty placeholder)
- install-coder (empty placeholder)
- status

All scripts initially contain TODO markers and an echo describing expected behavior.

4.4 Task — Add .gitignore  
- Ignore .run/, logs, kubeconfig backups.

4.5 Acceptance Criteria  
- Repo clones cleanly.  
- All scripts exist and run (even if just echoing TODO).  
- namespaces.yaml applies without error.  
- office.config.yaml exists with placeholder structure.

---

5. Validation Before Proceeding

5.1 Task — Dry Run  
- Run scripts/cluster-up.  
- Run scripts/bootstrap-namespaces.  
- Run scripts/status.

5.2 Acceptance Criteria  
- Cluster is reachable.  
- Namespaces created.  
- Scripts run without failure.  
- Repo is now ready for Milestone 02 (Developer Tooling).