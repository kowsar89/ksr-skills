---
name: ksr-commit-changes
description: Show what changed in a GitLab merge request after a given commit, leaving out changes merged in from the target branch, as a diff-view HTML page with review feedback.
disable-model-invocation: true
---

# MR changes after a commit

This skill is activated only by explicit user invocation.

The user gives a GitLab MR (number or URL) and a commit SHA. If either is missing, ask. Run every command from the project repository, and never change its working tree or branches. On any blocker, stop and report.

## 1. MR details

```bash
glab mr view <MR> -F json
```

Take `iid`, `title`, `web_url`, `target_branch`, `diff_refs.head_sha` (`<head>`) and `diff_refs.base_sha` (`<base>`, where the MR now meets the target branch). `<remote>` is the git remote whose URL points at the project in `web_url`.

## 2. Commits

```bash
git fetch <remote> refs/merge-requests/<iid>/head <base>
git rev-parse --verify '<sha>^{commit}'
```

If the SHA is not found and is 40 characters, run `git fetch <remote> <sha>` and check again. Use the full SHA from `rev-parse` as `<sha>` from here on.

## 3. Diff

If `git merge-base --is-ancestor <base> <sha>` succeeds, the target branch has not been merged in since `<sha>`, and the diff is `git diff <sha> <head>`.

Otherwise, replay the target branch onto `<sha>` in a temporary worktree and diff from that result, so only the MR's own changes remain:

```bash
wt=$(mktemp -d)
git worktree add --detach "$wt" <sha>
git -C "$wt" -c user.name=tmp -c user.email=tmp@localhost merge --no-edit --no-verify <base>
```

If the merge conflicts, note the files from `git -C "$wt" diff --name-only --diff-filter=U`, run `git -C "$wt" merge --abort`, and run the merge again with `-X ours`. Then:

```bash
git diff "$(git -C "$wt" rev-parse HEAD)" <head>
git worktree remove --force "$wt"
```

The MR's own commits in the range are `git log --no-merges --format='%h %an %s' <head> ^<sha> ^<base>`.

## 4. Review

Read the diff, with the surrounding code where needed. Give feedback on the changes: bugs, risks, and anything that looks unintended. Anchor each point to a file and line, or say there is nothing to flag.

## 5. Page

Write one self-contained HTML page to a temporary directory outside the repository:

- Header: MR title and link, `<sha>` → `<head>` (short SHAs), the commit list, and file and line counts.
- Feedback summary.
- Each changed file as a diff view: old and new line numbers, added and removed lines coloured, and each feedback point shown under the line it refers to.
- If the merge conflicted, mark those files: hunks there may still contain target-branch changes.
- If the diff is empty, say so instead of the file list.

If your harness can publish HTML artifacts, publish the page and give the link. Otherwise give the file path.
