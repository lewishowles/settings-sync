#!/usr/bin/env bash

# Entry point that runs all settings sync scripts.
# Add new sync scripts here as the collection grows.

set -e

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/support/colours.sh"

"$SCRIPT_DIR/settings-sync-snippets.sh"

echo ""
echo "${GREEN}✓ All settings synced.${RESET_COLOUR}"
echo ""
