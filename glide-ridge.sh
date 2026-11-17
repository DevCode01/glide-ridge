#!/bin/bash
# Disk usage report: largest files, directory breakdown, duplicate detection.
set -euo pipefail

DIR="${1:-.}"
if [ ! -d "$DIR" ]; then
    echo "Error: directory not found: $DIR"
    exit 1
fi

TOP_N="${2:-10}"

echo "=== Disk Report: $DIR ==="
echo

echo "--- Top $TOP_N largest files ---"
find "$DIR" -type f -printf '%s %p\n' 2>/dev/null | sort -rn | head -n "$TOP_N" | \
    awk '{size=$1; $1=""; printf "%10.1f KB  %s\n", size/1024, substr($0,2)}'
echo

echo "--- Directory size breakdown (top-level) ---"
du -sh "$DIR"/*/ 2>/dev/null | sort -rh | head -n "$TOP_N" || echo "(no subdirectories)"
echo

echo "--- Duplicate files (by content hash) ---"
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

find "$DIR" -type f -exec md5sum {} \; 2>/dev/null > "$TMPFILE"

DUP_COUNT=0
SAVED_BYTES=0
awk '{print $1}' "$TMPFILE" | sort | uniq -d | while read -r hash; do
    echo "Hash $hash:"
    grep "^$hash " "$TMPFILE" | awk '{$1=""; print "  " substr($0,2)}'
done

TOTAL_DUP_GROUPS=$(awk '{print $1}' "$TMPFILE" | sort | uniq -d | wc -l)
if [ "$TOTAL_DUP_GROUPS" -eq 0 ]; then
    echo "No duplicates found."
else
    echo
    echo "Found $TOTAL_DUP_GROUPS duplicate group(s)."
fi

echo
echo "--- Summary ---"
TOTAL_FILES=$(find "$DIR" -type f 2>/dev/null | wc -l)
TOTAL_SIZE=$(du -sh "$DIR" 2>/dev/null | awk '{print $1}')
echo "Total files: $TOTAL_FILES"
echo "Total size:  $TOTAL_SIZE"
