#How to Work an Issue (L1 / L2 / L3)

This document explains the standard flow for taking an issue from its queue to completion.
It covers all three levels of work — L3 shaping, L2 structuring, L1 implementation — with shared steps extracted where possible.

An issue can also be escalated if it turns out to be the wrong level, underspecified, or the agent is stuck.

⸻

🔷 Shared Workflow (All Levels)

Regardless of level, every issue moves through the same pipeline:
	1.	Move the issue
	•	From its queue (L1 Queue, L2 Queue, or L3 Queue)
	•	→ to its matching In Progress column.
	•	(script TODO: automate this)
	2.	Create and check out a branch
	•	Use the normal branch-naming scheme.
	•	Every issue gets exactly one branch.
	•	(script TODO: automate branch creation + checkout)
	3.	Initialize branch memory
The docs/llm-branch-memory/ directory exists only on feature branches.
It is always empty on main.
On a feature branch:
	•	Populate the memory directory with downloaded issue data and only context.
	•	Never put work product here (no final code, no edited docs, no artifacts that need to survive).
	•	Use the scripts to download issue data into this directory.
	•	Use another script to “sign” the context: environment, agent ID, assignment time, etc.
	•	Commit and push the memory artifacts at start, so supervisors can recover context if needed.
Branch memory is:
	•	A buffer so LLMs don’t have to hunt across the repo.
	•	A snapshot of task-completion state and environment.
	•	Not a workspace. Any real work lives in the actual repo files.
When the branch dies, branch memory dies with it — by design.
	4.	Begin work
	•	Read the downloaded issue data.
	•	Confirm prerequisites are met.
	•	If anything is missing or feels wrong for this level, escalate early (see Escalation below).

⸻

🔺 Escalation

If an agent believes the task is inappropriate for its level, underspecified, or is getting stuck, it should fail early and often rather than thrash.

The escalation path is:
	1.	Move the issue from its L# In Progress column to the Escalated board / column.
	2.	Add a short note to the issue describing:
	•	What was attempted.
	•	What is missing or unclear.
	•	Why this is not appropriate for this level.
	3.	Close the issue if that’s the convention for Escalated items, or leave it open if a human will re-triage it into a different level.

Escalation is not failure; it’s a signal that the issue needs reshaping or reassignment.

⸻

🔶 L3 — Shaping Work (Documentation)

L3 issues define direction, not code.

What counts as L3
	•	Architecture decisions
	•	System-level plans
	•	Definitions of workflows, policies, structures
	•	Producing breakdowns that generate L2 tasks

Goal

Produce documentation that clarifies intent, constraints, unknowns, and outputs.
The result is usually a Markdown file and a set of L2 follow-up issues.

Branch Memory

Should contain:
	•	The shaping note
	•	Links to relevant prior issues
	•	Diagrams or lists an agent might need
	•	Any temporary orientation artifacts

Again: no work product lives here — it’s context only.

⸻

🔷 L2 — Systems / Structure

L2 converts L3 clarity into implementable components.

What counts as L2
	•	Creating multi-step scripts
	•	Designing folder structures or workflows
	•	Orchestrating connected behavior
	•	Producing multiple L1 tasks

Goal

Define how the system will work, not just what to code.
L2 often ends by creating one or more L1 issues.

L1 Completeness Contract

L2 is responsible for making sure downstream L1 issues are fully specified.
The ideal L1 issue has literally everything a small coding model needs in the ticket itself.

Concretely, for any L1 issue derived from L2:
	•	A 7B coding agent should be able to:
	1.	Read the issue data (including links and snippets).
	2.	Open exactly the relevant file(s).
	3.	Make a targeted edit.
	4.	Pass tests / checks.
	•	With no additional digging or guessing about intent.

Branch Memory

Should contain:
	•	System layout notes
	•	Script stubs or pseudocode
	•	Intermediate definitions for future L1 issues
	•	Orientation for how pieces fit together

Still: no work product here, just context and planning.

⸻

🔶 L1 — Implementation / Edits

L1 is execution.
Atomic diffs, minimal scope, targeted work.

What counts as L1
	•	A script fix
	•	A small new script
	•	A document tweak
	•	A specific repo edit
	•	A workflow adjustment

Goal

Produce a clean PR that satisfies the spec defined by L2/L3.

L1 Ticket Requirements

L1 issues should be fully self-contained.
The intent is that a 7B coding agent can:
	1.	Look only at the issue data (title, body, and linked snippets).
	2.	Identify the exact file(s) to touch.
	3.	Apply the required edit.
	4.	Run or rely on tests/checks.
	5.	Succeed without wandering the repo or guessing.

If an L1 issue cannot be executed this way, it likely needs to be escalated or reshaped at L2.

Branch Memory

Should contain:
	•	Downloaded issue data
	•	The signed context
	•	Any scratch orientation notes (what files were inspected, relevant commands, etc.)

No code, no diffs, no final artifacts — just enough context for supervision or recovery.

⸻

Closing Out Work
	1.	Open a PR.
	2.	The issue should auto-move to In Review (workflow TODO).
	3.	After merge:
	•	Issue → Done
	•	Branch may be safely deleted.
	•	Branch memory dies with the branch (by design).

If at any point the issue feels wrong for the level, blocked, or under-specified, prefer early escalation over silent failure.

This workflow allows:
	•	Humans and agents to operate predictably
	•	Supervisors to inspect active branches and their context
	•	Clean boundaries between shaping, structuring, and implementation
	•	Zero branch-memory pollution on main and no work product stored in memory directories.