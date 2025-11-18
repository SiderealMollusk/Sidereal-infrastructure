# What's with that empty dir?

Branches and issues to should have a 1-to-1 mapping.
When starting work on an issue an agent should:

- move the issue to from L# queue to L# In Progress, via script. [script is todo]
- create and check out a branch per branch naming scheme [todo]

Then it should populate the llm-branch-memory dir.

- format and templates are [todo]
- branch memory is excluded from main via .gitattributes
- use the scripts to download issue data to the dir
- use another script to "sign" the context
- - the point of signing is to stamp the branch memory with the coding environment, agent, etc
- - for the purpose of having supervisors check in on them.
- add and commit push these changes.

Start working

- get oriented.
- read the downloaded docs, see if it all makes sense.
- confirm if prereqs are met.
