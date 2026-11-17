#!/usr/bin/env bash
# Auto-generated test harness — run after cloning to verify the build.
set -uo pipefail
FAIL=0

echo "-- syntax/build check --"
if bash -n glide-ridge.sh; then echo "  ok"; else echo "  FAIL"; FAIL=1; fi

echo "-- functional check --"
OUT="$(mkdir -p /tmp/glide-ridge-fc && echo hi > /tmp/glide-ridge-fc/a.txt && bash glide-ridge.sh /tmp/glide-ridge-fc 2>&1)"
if echo "$OUT" | grep -qF -- 'Disk Report'; then
  echo "  ok   - contains: Disk Report"
else
  echo "  FAIL - expected to contain: Disk Report"
  echo "  got: $OUT"
  FAIL=1
fi

if [ "$FAIL" = "1" ]; then echo; echo "FAILED"; exit 1; fi
echo; echo "All tests passed."
