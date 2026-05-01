#!/usr/bin/env bash

# Entry point that runs all gist sync scripts.
# Add new sync scripts here as the collection grows.

set -e

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/support/colours.sh"

"$SCRIPT_DIR/gist-sync-zshrc.sh"
"$SCRIPT_DIR/gist-sync-snippets.sh"

echo ""
echo -e "${GREEN}✓ All gists synced.${RESET_COLOUR}"
