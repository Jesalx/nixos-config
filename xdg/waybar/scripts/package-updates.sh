#!/bin/sh

# Check for required commands
if ! command -v checkupdates &>/dev/null; then
	echo "checkupdates not found"
	exit 1
fi

if ! command -v paru &>/dev/null; then
	echo "paru not found"
	exit 1
fi

format() {
	[ "$1" -eq 0 ] && echo '-' || echo "$1"
}

# Run update checks in the background and capture their outputs
exec 3< <(checkupdates 2>/dev/null | wc -l)
exec 4< <(paru -Qua 2>/dev/null | wc -l)

# Read the outputs
read -r updates_arch <&3 && read -r updates_aur <&4

# Close file descriptors
exec 3<&-
exec 4<&-

updates=$((updates_arch + updates_aur))

if [ "$updates" -gt 0 ]; then
	# echo "$(format "$updates_arch + $updates_aur")"
  echo "$((updates_arch + updates_aur))"
else
	echo "0"
fi
