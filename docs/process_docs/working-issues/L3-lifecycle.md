# L3 Issue Lifecycle

## Lifecycle Summary

0. **Creation** — Fill L3 template, generate issue.
1. **Queued** — Waiting in *L3 Queue*.
2. **Claimed** — `claim-L3-from-queue.sh`:
   - Validates repo state.
   - Moves issue → *L3 In Progress*.
   - Creates L3 branch.
   - Initializes `llm-branch-memory/<branch>/sig.yaml`.
   - Runs automatic research (docs + signals pulled).
3. **In Progress**
   - **Orientation** — Read issue + sig.yaml.
   - **Research** — Gather missing context.
   - **Documentation** — Write the L3 outputs.
   - **Decomposition** — Create L2/L1 issues and queue them.
   - **Consolidation** — Clean sig.yaml, prep for review.
4. **Ready for Review** — PR opened, linked.
5. **In Review** — Human check.
6. **Merged** — Docs land in main; working memory deleted.
7. **Done** — L3 complete; sub‑issues proceed independently.
8. **Escalated** — If blocked or wrong level; stop work.

---

## What L3 Work Is

- Defines structure, documentation, and workflows.
- Produces *docs*, *architecture decisions*, *scripts*, and *sub‑issues*.
- Does **not** implement features or write product code.

---

## Required L3 Outputs

- Core docs in `docs/process_docs/…`
- Updated workflows/scripts (if needed)
- L2/L1 sub‑issues for all actionable work
- Clean + committed `sig.yaml` (context only)

---

## Working Memory (`sig.yaml`)

Temporary per‑branch context containing:

- Issue metadata
- Environment + detection info
- Draft docs + notes
- Open questions and decomposition plan

Deleted on merge. Never contains work product.

---

## Escalation

Move to *Escalated* if:

- Blocked
- Wrong level
- Missing prerequisites
- Unclear scope

Add reason → stop work.

---

## Glossary

**L3** high‑level docs/structure  
**L2** medium tasks from L3 spec  
**L1** small precise edits  
**Working Memory** per‑branch temp context  
**sig.yaml** structured context file  
**Claim Script** automation that initializes L3 work

---

## File Map

- `config/infra.env` — OWNER/REPO, project number, branch template  
- `scripts/workflows/` — automation scripts  
- `docs/process_docs/` — long‑lived manuals/specs  
- `llm-branch-memory/` — ephemeral per-branch memory
