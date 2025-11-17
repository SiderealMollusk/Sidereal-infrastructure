Terse workflow: keep Issues as source-of-truth and let the Project board reflect state.

- Add issue to repo (title, body, checkboxes, labels, milestone). Do not edit the card directly.
- One-time: add issue to Project board Backlog (Issue page → right sidebar → Projects → pick column) or drag from board.
- Use labels for status: `status:backlog`, `status:in-progress`, `status:review`, `status:done`, and component/priority labels.
- Enable Project automation (project settings): move card when PR opened → In Progress; when PR merged or issue closed → Done.
- On PRs include `Closes #<issue>` so merges close issues and trigger automation.
- Optional: add a lightweight GitHub Action to auto-add new issues (or labeled issues) to the Backlog column.

Minimal label policy

- `component:<name>` — routing (infra/coder/llm/...), set on creation.
- `priority:P0|P1|P2` — scheduling.
- `status:*` — used by automation; do not manually set `status:done` (use PR merge/close).

Quick automation Action (concept)

1. Trigger: `issues` (types: opened, labeled) and `pull_request` (opened, closed, merged).
2. On issue opened/labeled: if label matches a rule, call GitHub API to add issue to project column ID (Backlog).
3. On PR opened: find linked issue(s) via body or commits and move their cards to In Progress.
4. On PR merged or issue closed: move card to Done.

Notes

- Prefer project automation when available (Projects beta has richer built-ins). Classic user projects may need Actions or manual adds.
- Keep the Issue body as the single source for acceptance criteria and progress (checkboxes are visible in cards).
- Avoid duplicate cards by using automation OR manual adds, not both.

How to add the Action (optional)

1. Create `.github/workflows/project-sync.yml` with a small workflow that calls the REST API to add/move project items.
2. Store project/column IDs in repo secrets or hardcode if stable.
3. Start with 'issue opened' → add to Backlog; expand rules later.

See also: `planning/milestones_01.md` for Foundation milestone tasks and acceptance criteria.

