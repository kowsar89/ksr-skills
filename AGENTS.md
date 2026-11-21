# ksr-skills

## Skills
- Path: `skills/ksr-<name>/SKILL.md`.

## Writing
- New files: the minimum text that fully achieves the goal.
- Existing files: the minimum change that fully achieves the goal. Rewrite the affected parts cleanly, so the result never reads like a history of fixes. Do not reword or move text that does not need to change.
- Blockers: stop and report. No workarounds.

## Verifying
- Before writing, check every command, path and behaviour live. Docs and older scripts may be wrong.
- After writing, follow the skill literally on real targets, edge cases included.
- Undo every change made during testing.

## Commits

- Write commit messages in the Chris Beams style: a capitalised subject in the imperative mood, up to 50 characters, with no full stop. Leave out the body unless the subject and diff don't explain why the change was made; most small commits need only a subject. When a body is needed, put it after a blank line, wrap it at 72 characters, and say what changed and why, not how.
- AI attribution is allowed in commits and merge requests, but leave out model names, versions and session links.