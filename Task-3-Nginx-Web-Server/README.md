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
docker exec codsoft-task3-nginx nginx -t
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

## Response Time
A single local request returned HTTP 200 in 0.019010 seconds. This is not a load test.

## Stop the Server
```powershell
docker compose -f Task-3-Nginx-Web-Server/compose.yaml down
```

## Notes
- The website and Nginx configuration are mounted read-only.
- Nginx uses the nginx:stable-alpine image.
- Host port 8083 maps to container port 80.
- Server version disclosure is disabled.
- The X-Content-Type-Options: nosniff header is enabled.
- HTTPS and cloud deployment are outside this task scope.
