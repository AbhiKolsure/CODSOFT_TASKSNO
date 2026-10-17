#!/usr/bin/env bash
set -Eeuo pipefail

COMPOSE_FILE="Task-3-Nginx-Web-Server/compose.yaml"
COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-codsoft-task3-smoke}"
TASK3_HOST_PORT="${TASK3_HOST_PORT:-18083}"
export TASK3_HOST_PORT
BASE_URL="http://127.0.0.1:${TASK3_HOST_PORT}"
TMP_DIR="$(mktemp -d)"

compose() {
  docker compose --project-name "$COMPOSE_PROJECT_NAME" -f "$COMPOSE_FILE" "$@"
}

cleanup() {
  local exit_code=$?
  trap - EXIT
  if (( exit_code != 0 )); then
    echo "Nginx smoke test failed; collected Compose logs follow:" >&2
    compose logs --no-color >&2 || true
  fi
  compose down --remove-orphans >/dev/null 2>&1 || true
  rm -rf "$TMP_DIR"
  exit "$exit_code"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

pass() {
  echo "PASS: $*"
}

compose config --quiet
pass "Docker Compose configuration is valid"

compose up -d --remove-orphans
container_id="$(compose ps --quiet nginx)"
[[ -n "$container_id" ]] || fail "Compose did not create the Nginx container"

healthy=false
for attempt in $(seq 1 30); do
  health_status="$(docker inspect --format '{{.State.Health.Status}}' "$container_id" 2>/dev/null || true)"
  if [[ "$health_status" == "healthy" ]]; then
    healthy=true
    break
  fi
  state="$(docker inspect --format '{{.State.Status}}' "$container_id" 2>/dev/null || true)"
  if [[ "$state" == "exited" ]]; then
    fail "Nginx container exited before passing its health check"
  fi
  sleep 1
done
[[ "$healthy" == true ]] || fail "Nginx container did not become healthy within 30 seconds"
pass "Container health check is healthy"

compose exec -T nginx nginx -t
pass "Nginx configuration test passed"

home_status="$(curl -sS -o "$TMP_DIR/home.html" -w '%{http_code}' "$BASE_URL/")"
[[ "$home_status" == "200" ]] || fail "Homepage returned HTTP $home_status instead of 200"
grep -Fq 'Welcome to Task 3 of the CodSoft DevOps internship.' "$TMP_DIR/home.html" || fail "Homepage content marker was not found"
pass "Homepage returns HTTP 200 with expected content"

vhost_status="$(curl -sS -H 'Host: codsoft.local' -o "$TMP_DIR/vhost.html" -w '%{http_code}' "$BASE_URL/")"
[[ "$vhost_status" == "200" ]] || fail "Virtual host returned HTTP $vhost_status instead of 200"
grep -Fq 'Nginx Web Server' "$TMP_DIR/vhost.html" || fail "Virtual-host response content marker was not found"
pass "codsoft.local virtual host returns HTTP 200"

not_found_status="$(curl -sS -o "$TMP_DIR/404.html" -w '%{http_code}' "$BASE_URL/this-page-does-not-exist")"
[[ "$not_found_status" == "404" ]] || fail "Missing page returned HTTP $not_found_status instead of 404"
grep -Fq 'Page Not Found' "$TMP_DIR/404.html" || fail "Custom 404 page content was not returned"
pass "Unknown path returns HTTP 404 with the custom error page"

curl -sS -D "$TMP_DIR/headers.txt" -o /dev/null "$BASE_URL/"
grep -Eiq '^X-Content-Type-Options:[[:space:]]*nosniff' "$TMP_DIR/headers.txt" || fail "X-Content-Type-Options nosniff header is missing"
grep -Eiq '^X-Frame-Options:[[:space:]]*DENY' "$TMP_DIR/headers.txt" || fail "X-Frame-Options DENY header is missing"
grep -Eiq '^Referrer-Policy:[[:space:]]*no-referrer' "$TMP_DIR/headers.txt" || fail "Referrer-Policy no-referrer header is missing"
grep -Fqi "Content-Security-Policy: default-src 'self'; base-uri 'self'; object-src 'none'; frame-ancestors 'none'; style-src 'self' 'unsafe-inline'" "$TMP_DIR/headers.txt" || fail "Expected Content-Security-Policy header is missing"
if grep -Eiq '^Server:[[:space:]]*nginx/[0-9]' "$TMP_DIR/headers.txt"; then
  fail "Nginx server version is exposed in the Server response header"
fi
pass "Security headers are present and the Nginx version is not exposed"

echo "All Task 3 Nginx smoke tests passed."
