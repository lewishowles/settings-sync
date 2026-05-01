#!/usr/bin/env bash

# Syncs .zshrc and its associated settings files to a GitHub Gist.

set -e

# Load environment configuration from .env
source "$(dirname "$0")/.env"

# Load shared configuration and helpers.
source "$(dirname "$0")/gist-common.sh"

# Configuration

# Settings files to include as separate gist files. firefox-settings.zsh is
# excluded as it contains sensitive addon developer keys.
ZSH_INCLUDES=(
	"bun-settings.zsh"
	"nvm-settings.zsh"
	"oh-my-zsh-settings.zsh"
)

# Sync

echo -e "${PURPLE}Syncing .zshrc gist...${RESET_COLOUR}"

GITHUB_TOKEN=$(retrieve_github_token)

# Start the payload with the main .zshrc file.
payload=$(jq -n \
	--rawfile zshrc "$ZSHRC_PATH" \
	'{"files": {".zshrc": {"content": $zshrc}}}')

# Append each included settings file as its own gist file.
for filename in "${ZSH_INCLUDES[@]}"; do
	filepath="$ZSH_SETTINGS_DIR/$filename"

	if [ -f "$filepath" ]; then
		payload=$(echo "$payload" | jq \
			--arg name "$filename" \
			--rawfile content "$filepath" \
			'.files[$name] = {"content": $content}')
	else
		echo -e "  ${YELLOW}⚠ Skipping $filename — file not found.${RESET_COLOUR}"
	fi
done

upload_gist "$GIST_ID_ZSHRC" "$payload" "$GITHUB_TOKEN"

echo -e "${GREEN}✓ .zshrc gist updated.${RESET_COLOUR}"
