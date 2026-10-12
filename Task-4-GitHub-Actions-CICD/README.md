# CodSoft DevOps Internship — Task 4: CI/CD with GitHub Actions

## Purpose

This task adds an automated continuous-integration workflow for the existing Task 1 FastAPI application. On supported events, GitHub Actions installs the declared Python dependencies, runs the automated tests, and validates that the Docker image builds. It does not publish the image or deploy the application.

## Architecture

The executable workflow is at the repository-root path `.github/workflows/task4-ci.yml`, which is where GitHub Actions discovers workflows. Task-specific documentation stays in this directory. The workflow runs on an Ubuntu GitHub-hosted runner, checks out the existing repository, selects Python 3.12 (matching the Task 1 Dockerfile base image), and executes commands from `Task-1-Dockerized-Web-App/`.

The job has only `contents: read` permission. It uses the official `actions/checkout` and `actions/setup-python` actions, does not access secrets, and does not push an image to a registry.

## Triggers

- Push to `main`.
- Pull request targeting `main`.
- Manual run using `workflow_dispatch` from the GitHub Actions UI (select a branch where the workflow file exists).

## Workflow steps

In order, the workflow:

1. Checks out the repository with `actions/checkout@v4`.
2. Sets up Python 3.12 with `actions/setup-python@v5`.
3. Installs dependencies using `python -m pip install -r requirements.txt`.
4. Runs `python -m pytest`.
5. Builds `codsoft-task1:latest` with `docker build -t codsoft-task1:latest .`.

The job stops on a failed command. The image is built only on the runner for validation; there is no login or push step.

## Inspect GitHub Actions runs

After this workflow file is available on GitHub in a branch/event that matches a trigger:

1. Open the repository on GitHub and select **Actions**.
2. Choose **Task 4 - CI** and open a run.
3. Review the event, branch/commit, job, and each step log.
4. Record the run URL, conclusion, and relevant test/build output in your Task 4 evidence only after observing the actual run.

A local test or Docker build is not a GitHub-hosted workflow run. Do not report this workflow as passing until GitHub shows a successful run.

## Local validation commands

Run from the repository root in PowerShell. The commands mirror the workflow’s dependency, test, and image-build steps:

```powershell
Set-Location 'C:\Users\kolsu\task-1-dockerized-web-app\Task-1-Dockerized-Web-App'
python -m pip install -r requirements.txt
python -m pytest
docker build -t codsoft-task1:latest .
```

These commands require a compatible Python installation, package-index access for dependency installation, and a running Docker Engine for the image build. They validate locally only; they do not trigger GitHub Actions or publish the image.

## Troubleshooting

- **Dependency installation fails:** inspect the pip error, Python version, and package-index connectivity. Do not remove or weaken the declared requirements to hide a failure.
- **Tests fail:** open the test step log, reproduce with `python -m pytest` from the Task 1 directory, and address the underlying cause without weakening tests.
- **Docker build fails:** reproduce with the documented `docker build` command, inspect the failing Dockerfile layer and build output, and confirm the Docker daemon is available.
- **Workflow does not trigger:** confirm the workflow exists at repository-root `.github/workflows/task4-ci.yml`, the event targets `main` as configured, and the file is present on the relevant GitHub branch. Manual dispatch is available only for branches that contain the workflow.
- **Workflow permission or action error:** inspect the run logs and repository policy. The job requests only `contents: read`; do not broaden permissions without a specific need.

## Verification status and limitations

The workflow definition and this documentation are being prepared in the current local working branch. A GitHub-hosted run has not been verified by this README; record its result only after inspecting an actual Actions run. Local test and Docker build results must likewise be reported separately and only if executed successfully.

Cloud deployment is intentionally not configured. No target environment, deployment architecture, access approval, or deployment credentials have been specified. A safe deployment workflow would first require an explicitly selected target (for example, a named cloud service), documented environment and rollback strategy, owner-approved repository/environment configuration, least-privilege short-lived credentials or supported identity federation, protected deployment environments/approvals, and a separate reviewed deployment job. Secrets must not be added to source files or exposed in logs. Until those prerequisites are defined and approved, CI stops at tests and local image-build validation.