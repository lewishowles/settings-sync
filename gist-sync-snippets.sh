#!/usr/bin/env bash

# Syncs all VSCode snippet files to a GitHub Gist.
# Each .json file in the snippets directory becomes its own gist file.

set -e

# Load environment configuration from .env
source "$(dirname "$0")/.env"

# Load shared configuration and helpers.
source "$(dirname "$0")/gist-common.sh"

# Sync

echo -e "${PURPLE}Syncing snippets gist...${RESET_COLOUR}"

GITHUB_TOKEN=$(retrieve_github_token)

# Start with an empty files object, then append each snippet file.
payload=$(jq -n '{"files": {}}')

for filepath in "$SNIPPETS_DIR"/*.json; do
	filename=$(basename "$filepath")

	if [ ! -s "$filepath" ]; then
		echo -e "  ${YELLOW}⚠ Skipping $filename — file is empty.${RESET_COLOUR}"
		continue
	fi

	payload=$(echo "$payload" | jq \
		--arg name "$filename" \
		--rawfile content "$filepath" \
		'.files[$name] = {"content": $content}')
done

upload_gist "$GIST_ID_SNIPPETS" "$payload" "$GITHUB_TOKEN"

echo -e "${GREEN}✓ Snippets gist updated.${RESET_COLOUR}"
