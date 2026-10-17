# CodSoft DevOps Internship — Task 2: Git & GitHub Workflow

## Objective and scope

This task documents a safe, repeatable Git and GitHub collaboration workflow: inspect an existing repository, make small changes on feature branches, review diffs, prepare pull requests, review changes, and practice resolving a merge conflict in isolated example files. It reuses the repository at `C:\Users\kolsu\task-1-dockerized-web-app`; it does not create another repository or change Task 1.

**Evidence boundary:** PR #1, "Document feature branch workflow example," was opened and merged into `main`; see `docs/evidence.md`. Formal reviewer approval, successful conflict resolution, and main-branch protection settings remain unverified. Record them as complete only after observing the relevant results.

## Repository layout

```text
repository-root/
├── .git/                              Existing repository metadata (do not move)
├── README.md                          Repository overview
├── .gitignore                         Shared generated-file exclusions
├── Task-1-Dockerized-Web-App/          Existing Task 1 (leave unchanged)
└── Task-2-Git-GitHub-Workflow/
    ├── README.md
    ├── docs/
    │   ├── workflow-guide.md
    │   ├── code-review-checklist.md
    │   └── evidence.md
    ├── examples/
    │   ├── feature-note.md
    │   ├── conflict-demo.md
    │   └── conflict-resolution.md
    └── .github/
        └── PULL_REQUEST_TEMPLATE.md
```

The template is nested for task isolation. GitHub automatically discovers templates only from repository-root `.github/` (or supported template locations), not this nested folder. If desired, a repository owner can copy it to root `.github/PULL_REQUEST_TEMPLATE.md` after checking that destination does not exist.

## Prerequisites and repository inspection

Use PowerShell and Git from the existing repository root:

```powershell
Set-Location 'C:\Users\kolsu\task-1-dockerized-web-app'
git rev-parse --show-toplevel
git status --short --branch
git branch --show-current
git log -1 --oneline --decorate
git remote -v
git branch -vv
```

Confirm the root, intended base branch (`main`), and existing `origin`. Start only with a clean worktree; if changes appear, inspect and preserve them rather than resetting or cleaning. Refresh and compare remote-tracking information with:

```powershell
git fetch origin
git status --short --branch
git rev-list --left-right --count main...origin/main
```

The counts are `ahead behind`; `0 0` means the tips match. `fetch` updates local remote-tracking metadata; it does not push.

Check that Task 1 has no unexpected changes:

```powershell
git status --short -- Task-1-Dockerized-Web-App
git diff -- Task-1-Dockerized-Web-App
git diff --cached -- Task-1-Dockerized-Web-App
```

## Meaningful commits and reviewing changes

Keep commits focused and descriptive. Examples (use only for work actually performed): `docs(task-2): add feature branch workflow guide`, `docs(task-2): add pull request review checklist`, `docs(task-2): document conflict exercise`.

```powershell
git status --short
git diff
git diff --check
git diff --stat
git diff --cached
git log --oneline --decorate -10
git log --oneline --graph --decorate --all
```

Review staged and unstaged changes before any commit. Do not include secrets, `.env` files, generated caches, or unrelated Task 1 changes. This documentation does not stage or commit changes.

## Feature branch workflow

After confirming the worktree is clean and the base branch is current, this harmless example targets only `examples/feature-note.md`:

```powershell
git switch main
git pull --ff-only origin main
git switch -c task-2/example-feature-note
Add-Content -LiteralPath 'Task-2-Git-GitHub-Workflow/examples/feature-note.md' -Value "`nFeature-branch exercise: reviewed change."
git diff -- Task-2-Git-GitHub-Workflow/examples/feature-note.md
git diff --check
git status --short
```

Review the diff and scope. A contributor may then stage and commit only the reviewed change if authorized. Do not merge or push until ready and permitted. These instructions do not create a branch or commit automatically.

## Pull requests and code reviews

For real collaboration, push a reviewed feature branch only when authorized, then open GitHub and create a PR with base `main` and compare set to that branch. Complete `.github/PULL_REQUEST_TEMPLATE.md`, request a reviewer, respond to feedback, and merge only after required approvals/checks pass. Record actual PR state and links in `docs/evidence.md`.

The template is nested under Task 2 and is not automatically applied by GitHub. PR #1 was opened and merged into `main`; its details are recorded in `docs/evidence.md`. This does not establish formal reviewer approval, successful conflict resolution, or branch protection. Use `docs/code-review-checklist.md` on the latest revision; feedback should be actionable and respectful.

## Safe merge-conflict demonstration

The conflict practice edits only `examples/conflict-demo.md` inside disposable temporary clones. Follow `docs/workflow-guide.md`; it first commits that one example as a temporary baseline in a seed clone, then creates two clones that modify the same existing line. This avoids an add/add conflict and keeps the current repository history and Task 1 safe. The guide uses a one-off identity for its local demo commits and does not alter global Git configuration. `examples/conflict-resolution.md` describes the intended conflicting line and resolution.

During the temporary-clone conflict, inspect in the right-hand clone (use the `$right` path from `docs/workflow-guide.md`):

```powershell
git -C $right status
git -C $right diff -- $relative
Get-Content -LiteralPath (Join-Path $right $relative)
```

Git conflict markers are `<<<<<<<`, `=======`, and `>>>>>>>`. Resolve only the example file, remove all markers, and verify:

```powershell
git -C $right diff --check
git -C $right diff -- $relative
git -C $right status --short
```

Only proceed after reviewing the resolution. Instructions are not evidence that a conflict was produced or resolved.

## Clean history

Prefer short-lived branches, small commits, focused reviews, and pull requests for shared work. Avoid rewriting shared history and never force-push. Inspect history with:

```powershell
git log --oneline --graph --decorate --all
```

## Optional main-branch protection

Recommended rules, where supported: require PRs before merging, at least one approval, dismiss stale approvals after new commits, require relevant status checks, and restrict force-pushes/deletions. Branch protection was not verified during this implementation. Inspect GitHub **Settings → Rules → Rulesets** or **Settings → Branches** with suitable permission. If GitHub CLI is installed and authenticated, read-only checks include:

```powershell
gh auth status
gh api repos/AbhiKolsure/CODSOFT_TASKSNODevOps/rulesets
gh api repos/AbhiKolsure/CODSOFT_TASKSNODevOps/branches/main/protection
```

Permission errors or plan limitations leave the state unverified. Do not change settings without owner approval.

## Verification checklist

- [ ] Repository root, remote, branch, status, and latest commit recorded.
- [ ] No unexpected staged or unstaged Task 1 changes.
- [ ] Feature branch/diff reviewed; any branch, commit, or PR recorded only if actually performed.
- [ ] Conflict walkthrough performed in the temporary clone if practical; no conflict markers remain in a resolved file.
- [ ] `git diff --check` passes for reviewed changes.
- [ ] PR, review, checks, and merge evidence recorded only after real GitHub actions.
- [ ] Branch rules inspected or clearly marked unverified.
- [ ] No secrets, private data, or generated caches included.

## Troubleshooting

- **Not a Git repository:** return to the existing repository root and check `git rev-parse --show-toplevel`; do not run `git init` in a task folder.
- **Branch already exists:** inspect `git branch --list` and choose a distinct name; do not delete unknown work.
- **Branch is behind:** fetch and inspect incoming changes. `git pull --ff-only origin main` refuses non-fast-forward merges.
- **Authentication/permission denied:** verify `origin`, use the approved sign-in method, and request access; never put tokens in commands or files.
- **Conflict or unexpected changes:** inspect status and diff, preserve all work, and ask for review if uncertain; do not reset or clean.

## Evidence and results

Use `docs/evidence.md` to record observed commands, dates, screenshots, branch/commit names, and PR/review links. Redact sensitive information. Current implementation status and manual GitHub actions still needed are recorded there; do not invent outputs or results.