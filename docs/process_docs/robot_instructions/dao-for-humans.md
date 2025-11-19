The Dao of the Workflow

(Human Operator Edition)

The Dao of the Workflow is the operating manual for how humans and AI agents collaborate inside this repository. It defines issue flow, branch creation, context generation, and how small autonomous agents safely contribute. Its purpose is to minimize human overhead while enabling many small agents to work in parallel without interfering with each other.

⸻

Purpose of the Dao
	•	Enforce consistent GitFlow behavior for humans and robots
	•	Automate context generation (sig files, environment introspection)
	•	Enable smaller models via structured memory
	•	Prevent agents from touching unscoped work
	•	Keep supervisors in control with clean, auditable workflows

The single most important rule: All work must start from a tracked issue.
Agents without rails become dangerous. Humans forget. The Dao protects both.

⸻

Issue Levels

Level 3 (L3): High-level definition and planning. Produces structure, documentation, workflows, and decomposes into L2/L1 tasks.

Level 2 (L2): Medium tasks with known scope but requiring reasoning, exploration, and decisions.

Level 1 (L1): Small, concrete, deterministic tasks that do not require real reasoning. Fully specified edits and implementations.

⸻

llm-branch-memory

A working directory excluded from main. It supports two robot-centric workflows:
	1.	Drafting new L3 issue documents before they exist on GitHub
	2.	Maintaining sig.yaml for ongoing work

sig.yaml is structured “working memory” containing:
	•	Issue metadata
	•	Environment detection
	•	Cached lookups
	•	Notes, extracted context, reasoning traces
	•	Decomposition plans

It is temporary. Deleted after merge. Never contains product work.

⸻

Workflow Overview
	1.	Claim an issue using scripts/workflows/L{{level}}/claim-issue.sh.
This validates repo state, moves the issue on the board, creates a branch, and generates sig.yaml.
	2.	Read sig.yaml.
It contains authoritative instructions, decomposition, and any context that has already been prepared.
	3.	Make changes locally, committing frequently.
	4.	Submit work using scripts/workflows/L{{level}}/submit.sh.
This stages all required changes, pushes them, opens a PR, and updates project status.
	5.	Check sig.yaml for next_agent_action.
Often it will instruct running scripts/workflows/utils/get-next-issue.sh -{{level}} to continue workflow execution.

⸻

L3 Issue Creation (Special Case)

L3 issues originate new work and do not start from branches.
	1.	Run scripts/workflows/L3/create-issue.sh.
Ensures repo clean, checks for dangling L3 tasks, resets llm-branch-memory, and creates a new template file.
	2.	Fill in llm-branch-memory/l3-issue.yaml.
Typically done with human assistance.
	3.	When satisfied, run scripts/workflows/L3/submit-issue.sh.
This creates the actual GitHub issue.

⸻

Escalation

If unclear, blocked, out of scope, or low-confidence:

Run scripts/workflows/util/escalate.sh.

The issue moves to Escalated and work stops.
Humans intervene from there.

⸻

llm-ignorable Directory

This directory contains misleading historical material.
Robots must not read it.
Humans may treat it as deep archive only.

Even listing files risks confusing LLMs.

⸻

Respect the Workflow

This repo relies on strict automation. Violations cause:
	•	orphaned branches
	•	inconsistent PRs
	•	broken sig.yaml state
	•	corrupted working memory
	•	agents interfering with each other

To operate correctly:
	•	Always begin from a claimed issue
	•	Always use the claim scripts
	•	Always reference sig.yaml before working
	•	Never bypass workflow automation
	•	Never commit directly to main

If sig.yaml exists, you are in an active work session.
If not, stop and request supervision.

⸻

Why Sub-Documents for L3, L2, L1?

The Dao is the constitution.

The L3, L2, and L1 guides will be small and laser-focused so robots can load only exactly what they need.

⸻

If you want, I can now generate:
	•	L3 guide
	•	L2 guide
	•	L1 guide
	•	sig.yaml template
	•	missing scripts list
	•	issue templates
	•	a cleanup pass for tone and compression