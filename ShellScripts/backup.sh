#!/usr/bin/env bash
# Author: Ashwani Singh
# Roll number: 2601730361
# Creates a timestamped compressed folder backup.

set -eu

backup_dir="$HOME/DeveloperPortfolio_Backups"
mkdir -p "$backup_dir"

log_result() {
  printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" \
    >> "$backup_dir/backup.log"
}

fail() {
  printf 'Error: %s\n' "$1" >&2
  log_result "FAILED: $1"
  exit 1
}

if [ "$#" -ne 1 ]; then
  echo 'Usage: ./backup.sh <folder>' >&2
  log_result 'FAILED: expected one source folder'
  exit 2
fi

[ -d "$1" ] || fail "Folder does not exist: $1"

source_dir=$(cd -- "$1" && pwd -P)
backup_dir=$(cd -- "$backup_dir" && pwd -P)

case "$backup_dir/" in
  "${source_dir%/}/"*)
    fail 'Source folder contains the backup destination.'
    ;;
esac

temporary=$(mktemp "$backup_dir/.partial.XXXXXX")
trap 'rm -f -- "$temporary"' EXIT

tar -czf "$temporary" -C "$source_dir" . \
  || fail "Could not archive $source_dir"

# Keep existing backups if two runs finish in the same second.
while true; do
  filename="backup_$(date '+%Y-%m-%d_%H-%M-%S').tar.gz"
  archive="$backup_dir/$filename"

  if ln -- "$temporary" "$archive" 2>/dev/null; then
    break
  fi

  [ -e "$archive" ] || fail "Could not save $filename"
  sleep 1
done

size=$(du -h --apparent-size "$archive" | cut -f1)
log_result "SUCCESS: $filename ($size)"

printf 'Backup created successfully.\n'
printf 'File: %s\n' "$archive"
printf 'Size: %s\n' "$size"
