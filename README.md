## Install

Install all skills globally:

```bash
npx skills add 'git@github.com:kowsar89/ksr-skills.git' -g -s '*' --force
```

Install a specific skill globally:

1. **ksr-ask**: Ask-only mode; answers without making changes.

   ```bash
   npx skills add 'git@github.com:kowsar89/ksr-skills.git' -g -s ksr-ask --force
   ```

2. **ksr-local-by-flywheel**: Work on Local (LocalWP) WordPress sites.

   ```bash
   npx skills add 'git@github.com:kowsar89/ksr-skills.git' -g -s ksr-local-by-flywheel --force
   ```

3. **ksr-commit-changes**: Show what changed in a GitLab MR or GitHub PR after a commit, without target-branch merges, as a diff-view HTML page with feedback.

   ```bash
   npx skills add 'git@github.com:kowsar89/ksr-skills.git' -g -s ksr-commit-changes --force
   ```
