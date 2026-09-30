#!/bin/bash
# Smoke test for the Docker deployment.
# Usage: ./smoke_test.sh [port]   (default 5001)
set -e
PORT="${1:-5001}"
URL="http://localhost:$PORT"

echo "Smoke testing $URL ..."
code=$(curl -s -o /tmp/smoke_index.html -w "%{http_code}" "$URL/")
[ "$code" = "200" ] && echo "PASS: / returned 200" || { echo "FAIL: / returned $code"; exit 1; }
grep -qiE "NIST|CSF" /tmp/smoke_index.html && echo "PASS: index contains NIST/CSF" || { echo "FAIL: index content unexpected"; exit 1; }

code=$(curl -s -o /tmp/smoke_api.json -w "%{http_code}" "$URL/api/functions")
[ "$code" = "200" ] && echo "PASS: /api/functions returned 200" || { echo "FAIL: /api/functions returned $code"; exit 1; }

echo "ALL SMOKE TESTS PASSED"
