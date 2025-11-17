

Milestones for the Office-in-a-Repo Project

1. Foundation
- Verify home cluster (i3 box) is reachable from the MacBook.
- Install baseline Kubernetes components.
- Create project namespaces (infra, coder, llm, messaging, matrix, game).
- Commit initial repo structure with scripts/, k8s/, and config files.

2. Developer Tooling
- Install ingress controller in infra namespace.
- Deploy Coder into coder namespace.
- Verify access to Coder through browser.
- Set up initial devctl script skeleton.

3. LLM Infrastructure
- Create llm-gateway service with placeholder routing.
- Connect llm-gateway to local NVIDIA LLM endpoint.
- Add support for at least one external LLM provider.
- Define logical model names and routing rules.

4. Communication Stack
- Deploy Matrix homeserver and database.
- Deploy Element or preferred Matrix frontend.
- Smoke-test login and messaging.
- Prepare space for Matrix bot and triage connection.

5. Messaging Intake
- Deploy triage-core with basic health endpoint.
- Add one message source (Discord) as proof of concept.
- Deliver normalized events to triage-core.
- Wire triage-core to llm-gateway.

6. Game Services
- Deploy game logic service.
- Deploy admin UI.
- Connect NPC system to llm-gateway.
- Integrate game data storage (Supabase or equivalent).

7. CI Integration
- Set up CI for linting, testing, and image building.
- Push images to registry with git-sha tags.
- Validate manifests in CI.
- Support manual deployment from Mac via devctl.

8. Deployment flows
- Implement devctl stack deploy for messaging, matrix, game, llm.
- Add audit and logging outputs.
- Validate rollout strategy (rolling updates, health checks).

9. Observability
- Install lightweight metrics and logs stack (Prometheus/Loki optional).
- Add dashboards for LLM usage, triage, and cluster health.
- Add alerts for gateway or Matrix failures.

10. Stabilization
- Add retry, backoff, and fallback routing in llm-gateway.
- Harden triage-core error handling.
- Tune resources for each workspace.
- Document operational runbooks.

11. Expansion (optional)
- Promote GPU laptop to Kubernetes worker node.
- Add long-context LLMs.
- Support additional messaging sources (SMS, Telegram, Gmail).
- Add GitOps optional flow (ArgoCD/Flux).