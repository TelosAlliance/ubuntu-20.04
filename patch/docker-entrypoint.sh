#!/bin/sh
# Usage: docker-entrypoint.sh [cmd [arg0 [arg1 ...]]]

echo ">>>>> Entering Ubuntu 20.04 development container..."

# Exit on failure
set -e

# Pull Docker ENV variables, using defaults if not set
user="${LINUX_USER:-"user"}"
uid="${LINUX_UID:-"1000"}"
group="${LINUX_GROUP:-"dev"}"
gid="${LINUX_GID:-"1000"}"
dir="${LINUX_DIR:-"/home/$user"}"

echo "Setting up container for user:$user($uid) group:$group($gid)..."

# Make new user and group
groupadd -f -g "$gid" "$group"
useradd -u "$uid" -g "$gid" -m "$user"

# Start here
cd "$dir"

# Run cmd as new user
gosu "$user" "$@"

echo "<<<<< Leaving Ubuntu 20.04 development container..."
