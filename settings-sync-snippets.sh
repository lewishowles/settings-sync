#!/usr/bin/env bash

# Copies VSCode snippet files from the snippets directory to the config repo.
# Keeps the config repo in sync when snippets are edited directly in VS Code.

set -e

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/support/colours.sh"
source "$SCRIPT_DIR/.env"

echo ""
echo "${BLUE}ℹ${RESET_COLOUR} Syncing ${PURPLE}snippets${RESET_COLOUR}…"

for filepath in "$SNIPPETS_DIR"/*.json; do
	filename=$(basename "$filepath")

	if [ ! -s "$filepath" ]; then
		echo "  ${YELLOW}⚠ Skipping $filename — file is empty.${RESET_COLOUR}"
		continue
	fi

	cp "$filepath" "$VSCODE_CONFIG_DIR/$filename"
done

echo "${GREEN}✓ ${PURPLE}snippets${RESET_COLOUR} copied."
echo ""
