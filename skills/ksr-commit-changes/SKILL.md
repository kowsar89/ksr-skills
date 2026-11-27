---
name: ksr-commit-changes
description: Show what changed in a GitLab merge request or GitHub pull request after a given commit, leaving out changes merged in from the target branch, as a diff-view HTML page with review feedback.
disable-model-invocation: true
---

# MR/PR changes after a commit

This skill is activated only by explicit user invocation.

The user gives a GitLab MR or GitHub PR (number or URL) and a commit SHA. If either is missing, ask. Run every command from the project repository, and never change its working tree or branches. On any blocker, stop and report.

## 1. MR/PR details

Use `glab` for GitLab and `gh` for GitHub. Tell which from the URL, or else from the repository's remote.

- GitLab: `glab mr view <MR> -F json`. Take `iid`, `title`, `web_url`, `target_branch` and `sha` (`<head>`). The head ref is `refs/merge-requests/<iid>/head`.
- GitHub: `gh pr view <PR> --json number,title,url,baseRefName,headRefOid`. `baseRefName` is the target branch and `headRefOid` is `<head>`. The head ref is `refs/pull/<number>/head`.

`<remote>` is the git remote whose URL points at the project in the MR/PR URL.

## 2. Commits

```bash
git fetch <remote> <head-ref>
git fetch <remote> <target-branch>
git merge-base <head> FETCH_HEAD
git rev-parse --verify '<sha>^{commit}'
```

The merge base is `<base>`, where the MR/PR now meets the target branch. If the SHA is not found and is 40 characters, run `git fetch <remote> <sha>` and check again. Use the full SHA from `rev-parse` as `<sha>` from here on.

## 3. Diff

If `git merge-base --is-ancestor <base> <sha>` succeeds, the target branch has not been merged in since `<sha>`, and the diff is `git diff <sha> <head>`.

Otherwise, replay the target branch onto `<sha>` in a temporary worktree and diff from that result, so only the MR/PR's own changes remain:

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

The MR/PR's own commits in the range are `git log --no-merges --format='%h %an %s' <head> ^<sha> ^<base>`.

## 4. Review

Read the diff, with the surrounding code where needed. Give feedback on the changes: bugs, risks, and anything that looks unintended. Anchor each point to a file and line, or say there is nothing to flag.

## 5. Page

Write one self-contained HTML page to a temporary directory outside the repository:

- Header: MR/PR title and link, `<sha>` → `<head>` (short SHAs), the commit list, and file and line counts.
- Feedback summary.
- Each changed file as a diff view: old and new line numbers, added and removed lines coloured, and each feedback point shown under the line it refers to.
- If the merge conflicted, mark those files: hunks there may still contain target-branch changes.
- If the diff is empty, say so instead of the file list.

If your harness can publish HTML artifacts, publish the page and give the link. Otherwise give the file path.
