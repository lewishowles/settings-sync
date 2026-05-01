#!/usr/bin/env bash

# Shared configuration and helpers for gist-sync scripts.
# Source this file at the top of each sync script.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/support/colours.sh"

# Environment configuration

# Load environment configuration from .env if it exists
if [ -f "$SCRIPT_DIR/.env" ]; then
	source "$SCRIPT_DIR/.env"
fi

# Token retrieval

# Fetch the GitHub token from 1Password at runtime so it is never stored on
# disk. Triggers a Touch ID prompt if the session is not already authenticated.
retrieve_github_token() {
	local token
	token=$(op read "$OP_TOKEN_REFERENCE")

	if [ -z "$token" ]; then
		echo -e "${RED}✗ Could not retrieve GitHub token from 1Password.${RESET_COLOUR}" >&2
		exit 1
	fi

	echo "$token"
}

# Gist upload

# Send a PATCH request to the GitHub Gist API with the given JSON payload.
# Arguments:
#   $1 — Gist ID
#   $2 — JSON payload
#   $3 — GitHub token
upload_gist() {
	local gist_id="$1"
	local payload="$2"
	local token="$3"

	local response
	response=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH \
		-H "Authorization: token $token" \
		-H "Content-Type: application/json" \
		-d "$payload" \
		"https://api.github.com/gists/$gist_id")

	if [ "$response" != "200" ]; then
		echo -e "${RED}✗ Upload failed (HTTP $response) for gist $gist_id.${RESET_COLOUR}" >&2
		exit 1
	fi
}
