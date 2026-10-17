# CodSoft DevOps Internship Projects

This repository contains practical projects completed for the CodSoft DevOps internship. Each task has its own folder with source files and task-specific documentation.

## Projects

### Task 1 - Dockerized Web Application
- **Stack:** Python, FastAPI, Docker, pytest
- Containerized API with health and information endpoints.
- Automated tests and Docker image build validation.
- [Task 1 documentation](Task-1-Dockerized-Web-App/README.md)

### Task 2 - Git and GitHub Workflow
- **Stack:** Git, GitHub, branches, commits, pull requests
- Workflow documentation, review checklist, feature-branch examples, and conflict-resolution exercises.
- [Task 2 documentation](Task-2-Git-GitHub-Workflow/README.md)

### Task 3 - Nginx Web Server
- **Stack:** Nginx, Docker Compose, HTML, CSS
- Static website, virtual host configuration, and custom 404 page.
- Tested locally with HTTP 200 and HTTP 404 responses.
- [Task 3 documentation](Task-3-Nginx-Web-Server/README.md)

### Task 4 - CI Pipeline with GitHub Actions
- **Stack:** GitHub Actions, Python, pytest, Docker
- Runs Task 1 tests and Docker image-build validation plus automated Task 3 Nginx smoke tests on configured events.
- Latest verified main-branch workflow run: successful.
- This workflow validates the build; it does not deploy to a cloud environment.
- [Task 4 documentation](Task-4-GitHub-Actions-CICD/README.md)

## Quick Start

Run these commands from the repository root in PowerShell.

### Task 1
```powershell
python -m pip install -r Task-1-Dockerized-Web-App/requirements.txt
python -m pytest Task-1-Dockerized-Web-App
docker build -t codsoft-task1:latest Task-1-Dockerized-Web-App
```

### Task 3
```powershell
docker compose -f Task-3-Nginx-Web-Server/compose.yaml up -d
```

Open http://localhost:8083 to view the Nginx website.

Stop the Nginx container with:
```powershell
docker compose -f Task-3-Nginx-Web-Server/compose.yaml down
```

## Repository Layout
```text
.github/workflows/task4-ci.yml
Task-1-Dockerized-Web-App/
Task-2-Git-GitHub-Workflow/
Task-3-Nginx-Web-Server/
Task-4-GitHub-Actions-CICD/
README.md
```

## Validation Summary
- Task 1: 6 automated tests passed in the recorded local test run.
- Task 2: workflow documentation and examples are included; see the Task 2 evidence log for items that still need evidence.
- Task 3: local configuration, homepage, virtual host, and custom 404 checks are recorded; automated health, response-header, and smoke tests run through Task 4 CI once the workflow enhancement is merged and its run passes.
- Task 4: GitHub Actions successfully completed automated tests and Docker image build validation.

## Scope and Limitations
- Task 4 currently performs continuous-integration validation only; cloud deployment is not configured.
- Task 3 is configured for local Docker-based hosting; public cloud hosting and HTTPS are not configured.
- Do not treat optional cloud deployment or other unimplemented extensions as completed.

## Repository
[View this project on GitHub](https://github.com/AbhiKolsure/CODSOFT_TASKSNODevOps)
