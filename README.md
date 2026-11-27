## Install

Install all skills globally:

```bash
npx skills add 'git@github.com:kowsar89/ksr-skills.git' -g -s '*' --force
```

Install a specific skill globally, then use it as shown. Examples use Claude Code's `/<name>`; in Codex, use `$<name>`.

1. **ksr-ask**: Ask-only mode; answers without making changes.

   ```bash
   npx skills add 'git@github.com:kowsar89/ksr-skills.git' -g -s ksr-ask --force
   ```

   Usage: `/ksr-ask <question>`, e.g. `/ksr-ask why does the checkout test fail?`

2. **ksr-local-by-flywheel**: Work on Local (LocalWP) WordPress sites.

   ```bash
   npx skills add 'git@github.com:kowsar89/ksr-skills.git' -g -s ksr-local-by-flywheel --force
   ```

   Usage: runs on its own when a task mentions a Local site, e.g. `List the active plugins on mysite.local`

3. **ksr-commit-changes**: Show what changed in a GitLab MR or GitHub PR after a commit, without target-branch merges, as a diff-view HTML page with feedback.

   ```bash
   npx skills add 'git@github.com:kowsar89/ksr-skills.git' -g -s ksr-commit-changes --force
   ```

   Usage: `/ksr-commit-changes <MR/PR number or URL> <commit SHA>`, e.g. `/ksr-commit-changes 2572 d1591b3d`
