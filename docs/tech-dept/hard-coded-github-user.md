# SiderealMollusk's Projects are in the codebase

## Known locations

### .github/workflows/add-to-project.yml

line 23 of project-url: <https://github.com/users/SiderealMollusk/projects/5>
I think the real solution here is to add an environment variable to the repo making it configurable.

### scripts/robot-tools

scripts/robot-tools/get-issue-column.sh
Lines 17 and 18 reference my username, and project #5.
The basic graph query is fine, but the script should make explicitly use of the
gh cli because it's super mature, and has a login flow. No need to redo that.
Also like need to have repo config for what project.
