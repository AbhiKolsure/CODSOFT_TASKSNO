# Task 3 - Nginx Web Server

## Objective
Configure Nginx to serve a static website with a virtual host and custom 404 error page.

## Technologies
- Nginx
- Docker and Docker Compose
- HTML and CSS

## Project Structure
- site/index.html - Main website
- site/404.html - Custom error page
- nginx/conf.d/default.conf - Nginx virtual host configuration
- compose.yaml - Container configuration

## Start the Server
Run from the repository root:
```powershell
docker compose -f Task-3-Nginx-Web-Server/compose.yaml up -d
```

Open http://localhost:8083 in your browser.

## Validate Configuration
```powershell
docker compose -f Task-3-Nginx-Web-Server/compose.yaml exec nginx nginx -t
```

## Test Homepage
```powershell
curl.exe -i http://localhost:8083/
```
Expected: HTTP 200 OK.

## Test Virtual Host
```powershell
curl.exe -i -H "Host: codsoft.local" http://localhost:8083/
```

## Test Custom 404 Page
```powershell
curl.exe -i http://localhost:8083/this-page-does-not-exist
```
Expected: HTTP 404 Not Found with the custom error page.

## Automated smoke test

From the repository root, run this in Git Bash or another Bash environment with Docker Compose and `curl` available:

```bash
bash .github/scripts/test-task3-nginx.sh
```

The script uses an isolated Compose project and defaults to host port `18083`, so it does not replace the normal demo on port `8083`. It checks Compose syntax, container health, `nginx -t`, homepage HTTP 200 and content, the `codsoft.local` virtual host, the custom HTTP 404 page, security headers, and server-version disclosure. The isolated test stack is removed when the script finishes; Compose logs are printed on failure.
## Response Time
A single local request returned HTTP 200 in 0.019010 seconds. This is not a load test.

## Stop the Server
```powershell
docker compose -f Task-3-Nginx-Web-Server/compose.yaml down
```

## Notes
- The website and Nginx configuration are mounted read-only.
- Nginx uses the `nginx:stable-alpine` image.
- The Compose health check probes the local homepage and exposes container health status.
- Host port defaults to `8083`; `TASK3_HOST_PORT` can override it.
- Response headers include `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, and a Content Security Policy compatible with the page's inline CSS.
- Host port 8083 maps to container port 80.
- Server version disclosure is disabled.
- The X-Content-Type-Options: nosniff header is enabled.
- HTTPS and cloud deployment are outside this task scope.
