# CodSoft DevOps Internship — Task 4: CI/CD with GitHub Actions

## Purpose

This task adds continuous integration for the Task 1 FastAPI API and Task 3 Nginx static website. On pushes to `main` and pull requests targeting `main`, GitHub Actions installs Task 1 dependencies, runs pytest, builds the Task 1 Docker image, uploads a short-lived JUnit report artifact, and runs isolated Nginx smoke tests for container health, Nginx configuration, homepage, virtual host, custom 404 behavior, security headers, and server-version disclosure. The workflow validates rather than publishes the Docker image and does not deploy to a public cloud environment.

## Architecture

The executable workflow is at the repository-root path `.github/workflows/task4-ci.yml`, which is where GitHub Actions discovers workflows. It contains two independent jobs on GitHub-hosted `ubuntu-24.04` runners: one installs Python 3.12 dependencies, tests the Task 1 API, builds its Docker image, and uploads the JUnit report; the other calls `.github/scripts/test-task3-nginx.sh` to exercise the Docker Compose Nginx site in an isolated project.

The workflow has only `contents: read` permission. It uses the official `actions/checkout@v7`, `actions/setup-python@v7`, and `actions/upload-artifact@v7` actions, does not access secrets, and does not push an image to a registry.

## Triggers

- Push to `main`.
- Pull request targeting `main`.
- Manual run using `workflow_dispatch` from the GitHub Actions UI (select a branch where the workflow file exists).

## Workflow steps

The workflow defines two independent jobs.

**Job 1 â€” Task 1 test and Docker build**

1. Checks out the repository with `actions/checkout@v7`.
2. Sets up Python 3.12 with `actions/setup-python@v7`.
3. Installs dependencies from `Task-1-Dockerized-Web-App/requirements.txt`.
4. Runs pytest and writes `test-results.xml` in JUnit format.
5. Builds `codsoft-task1:latest` as a validation step only.
6. Uploads the JUnit report as the `task1-pytest-report` artifact for seven days, including when the test step fails and produces a report.

**Job 2 â€” Task 3 Nginx smoke test**

1. Validates `Task-3-Nginx-Web-Server/compose.yaml`.
2. Starts a separate Compose project on host port `18083` by default, without replacing the demo stack on port `8083`.
3. Waits for the Compose health check and runs `nginx -t`.
4. Checks homepage HTTP 200 and content, the `codsoft.local` virtual host, custom 404 status and content, four security response headers, and hidden Nginx version disclosure.
5. Tears down the isolated stack and prints Compose logs if a test fails.

A failing command makes its job fail. The image is built only on the runner for validation; there is no registry login, image push, or cloud deployment.
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

## Run the Task 3 smoke test locally

From the repository root, use Git Bash (or another Bash environment) with Docker Desktop/Engine and Docker Compose available:

```bash
bash .github/scripts/test-task3-nginx.sh
```

The script uses a separate Compose project and host port `18083` by default. It removes that isolated test stack after the checks finish; on failure, it prints the Compose logs. The normal demo can continue to use port `8083`.
## Troubleshooting

- **Dependency installation fails:** inspect the pip error, Python version, and package-index connectivity. Do not remove or weaken the declared requirements to hide a failure.
- **Tests fail:** open the test step log, reproduce with `python -m pytest` from the Task 1 directory, and address the underlying cause without weakening tests.
- **Docker build fails:** reproduce with the documented `docker build` command, inspect the failing Dockerfile layer and build output, and confirm the Docker daemon is available.
- **Workflow does not trigger:** confirm the workflow exists at repository-root `.github/workflows/task4-ci.yml`, the event targets `main` as configured, and the file is present on the relevant GitHub branch. Manual dispatch is available only for branches that contain the workflow.
- **Nginx smoke test fails:** inspect the `Run Nginx smoke tests` log; ensure Docker Engine/Compose are available and host port `18083` is free. The script prints Compose logs when a test fails.
- **Workflow permission or action error:** inspect the run logs and repository policy. The job requests only `contents: read`; do not broaden permissions without a specific need.

## Verification status and limitations

Verified successful GitHub-hosted runs on `main` include:
- [Latest main run 39014433348](https://github.com/AbhiKolsure/CODSOFT_TASKSNO/actions/runs/39014433348)
- [Run 39009468995](https://github.com/AbhiKolsure/CODSOFT_TASKSNO/actions/runs/39009468995)
- [Run 39008594252](https://github.com/AbhiKolsure/CODSOFT_TASKSNO/actions/runs/39008594252)
- [Run 38216295593](https://github.com/AbhiKolsure/CODSOFT_TASKSNO/actions/runs/38216295593)

These runs completed dependency installation, automated tests, and Docker image build validation. The workflow does not push an image or deploy the application to a cloud environment.

Cloud deployment remains unconfigured. No target environment, deployment architecture, access approval, or deployment credentials have been specified. Deployment should be considered a separate future task requiring an approved target, a rollback plan, and appropriately scoped credentials. Never commit secrets.
