

Top-Level Plan for the Office-in-a-Repo Project

1. Overview
This repository bootstraps a complete personal “office” stack onto a Kubernetes cluster. It includes core infrastructure, developer tooling, LLM routing, communication systems, and optional game logic services. The MacBook acts as the cockpit, the i3 box hosts the main cluster, and the NVIDIA laptop provides GPU LLM compute.

2. Physical Architecture
- MacBook Pro (M1): developer cockpit; runs kubectl, helm, devctl; browser access to Coder and dashboards.
- i3 headless box: primary Kubernetes cluster; runs all core services (Coder, ingress, matrix, messaging, llm-gateway, game).
- NVIDIA laptop: GPU appliance running local LLMs (initially external to Kubernetes).

3. Core Components
- Namespaces: infra, coder, llm, messaging, matrix, game.
- Ingress controller: provides unified HTTP entrypoint.
- Coder: browser-based integrated development environment hosted in the cluster.
- LLM-Gateway: unified API between services and LLM providers (local Ollama and external APIs).
- Matrix stack: communication backend.
- Messaging triage: multi-source message ingestion and classification.
- Game services: logic, NPCs, admin UI.

4. Cluster Bootstrap Flow
- scripts/cluster-up: ensure cluster is reachable.
- scripts/bootstrap-namespaces: create all required namespaces.
- scripts/install-ingress: install ingress controller into infra namespace.
- scripts/install-coder: install Coder into coder namespace.

5. Development Flow
- User develops from the MacBook.
- Edits code locally or inside Coder workspace.
- CI builds and tests but does not deploy.
- Deployment is driven manually via devctl from the Mac.

6. Deployment Flow
- CI pushes built images to registry.
- User runs devctl or scripts to deploy services into cluster.
- k8s manifests and Helm charts are applied to the i3 cluster.
- Dashboard used for monitoring.

7. LLM Strategy
- Local GPU LLMs live on the NVIDIA laptop.
- llm-gateway routes tasks between local and external LLMs.
- office.config.yaml defines providers and routing rules.
- Services only talk to llm-gateway.

8. Goals
- Clone repo + run scripts = full office environment.
- Entire system declarative, reproducible, portable.
- Easy to add new services and LLM providers.

9. Next Steps
- Define devctl command structure.
- Add initial manifests for coder and ingress.
- Add llm-gateway v1.
- Add Matrix deployment.
- Add messaging triage skeleton.