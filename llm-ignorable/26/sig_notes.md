# sig.yaml (Working Memory Template)

This directory contains *ephemeral working memory* for Issue #26.  
Nothing here is ever merged to `main`.  
Everything here can be safely deleted at any time—LLMs will reconstruct it as needed.

---

## Purpose

`sig.yaml` (or other temp files) exist to:

- Keep all task-relevant context in one place for the agent working the issue.
- Prevent the agent from needing to search the entire repo.
- Allow supervisors to recover/inspect an agent’s state.
- Track discovered sub‑issues and relationships without producing “work product.”
- Store *task state*, not *project artifacts*.

---

## File Lifecycle

1. **Created** when the issue is claimed.  
2. **Populated** by automation + agent (issue text, links, relationships, scratch context).  
3. **Used** during the span of work on this branch.  
4. **Discarded** when the branch merges or the issue closes; the directory is fully wiped.  
5. **Never** promoted to `main`.

---

## YAML Template

Below is the recommended `sig.yaml` structure.

```yaml
# Top-level working memory object for this branch/issue
# SOURCE: Created by claim script when issue is claimed.
issue:
  number: 26                 # SOURCE: GitHub Issues API (gh api) via claim script
                             # TODO: claim-L3 script should write this
  title: "Automation Support L3"  # SOURCE: GitHub Issues API
                                  # TODO: claim script should populate this
  url: ""                   # SOURCE: GitHub Issues API
                            # TODO: claim script should populate this
  status: "L3 In Progress"  # SOURCE: Project column at claim time (script) or human update
                           # TODO: future move-status script must keep this in sync with project column
  created_at: ""            # SOURCE: GitHub Issues API
                            # TODO: claim script should populate this
  updated_at: ""            # SOURCE: GitHub Issues API; can be refreshed by sync script
                            # TODO: claim script should populate this

# Environment + runtime context for this working session
# SOURCE: Populated by script from local environment; optional human edits.
agent:
  environment: ""           # e.g., coder workspace name, host label, or "macbook-local"
                           # TODO: write env-snapshot.sh to populate automatically
  runtime: ""               # e.g., python/node versions; filled by env snapshot script
                           # TODO: env-snapshot.sh should detect versions
  notes: ""                 # freeform human/LLM note about where/how this work is running

# Task-level context and constraints the agent should obey
# SOURCE: Mixed – initial seed from L3/L2 templates + human; maintained by LLM/human.
context:
  summary: ""               # short human/LLM summary of what this issue is about
                           # TODO: L3 bootstrap script should seed from issue text
  instructions: ""          # concatenated instructions from docs + templates + human
                           # TODO: L3 template should define initial instructions
  constraints: []            # list of rules (from docs, infra.env, human decisions)
  relevant_files: []         # paths to key files (script can seed; human/LLM can refine)
                            # TODO: auto-detect touched files once code exists
  imported_docs: []          # snippets explicitly pasted in (NOT full source files)

# Relationships to other issues and high-level tracking
# SOURCE: Scripts that create/link issues + human shaping; may be cross-checked with API.
links:
  parent_issue: null         # L3 parent, if this is L2/L1; else null
                            # TODO: set via create-sub-issue.sh when used
  child_issues: []           # L2/L1 children created from this work (issue numbers)
                            # TODO: append as sub-issues are created
  related: []                # other issues that are relevant but not strict children
                            # TODO: link-issues.sh should update this
  blockers: []               # issues or conditions blocking progress; human/LLM maintained
                            # TODO: auto-populate from agent escalation script

# Free-form scratchpad for reasoning, questions, and future work ideas
# SOURCE: Primarily LLM + human during work; never promoted to main.
scratch:
  thoughts: ""              # running notes / reflections (safe to overwrite/append)
                           # NOTE: LLM writes ephemeral reasoning here; not a script TODO
  questions: []              # open questions that may become comments or escalations
                            # TODO: escalation-to-github.sh should surface unresolved questions
  future_work: []            # ideas that might later become L2/L1 issues
                            # TODO: generate-followup-issues.sh should convert entries into new issues
```

---

## Notes

Use `sig.yaml` as the *single authoritative temporary state store* while working this issue.

Add as little or as much as needed—this file exists purely to make the agent’s job easier and to make recovery trivial.

Remember:

- **No work product here.**
- **No code here.**
- **No long documents here.**
- Only state, context, links, and thinking.
