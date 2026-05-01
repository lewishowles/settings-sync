# gist-sync

Automatically syncs global, re-usable configuration files to GitHub Gists.

## What gets synced

| Script | Configuration | Contents |
| --- | --- | --- |
| `gist-sync-zshrc.sh` | `GIST_ID_ZSHRC` in `.env` | `.zshrc` and included settings files |
| `gist-sync-snippets.sh` | `GIST_ID_SNIPPETS` in `.env` | All `.json` files from snippets directory |

## Setup

### 1. Install dependencies

```bash
brew install 1password-cli jq
```

### 2. Enable 1Password CLI integration

In 1Password, go to **Settings → Developer** and enable **Integrate with 1Password CLI**. This allows the CLI to authenticate using your existing 1Password session.

### 3. Add the GitHub token to 1Password

Create a GitHub personal access token with the `gist` scope at <https://github.com/settings/tokens>, then save it in 1Password.

### 4. Make scripts executable

```bash
chmod +x /path/to/directory/*.sh
```

### 5. Configure gist-sync

Copy `.env.example` to `.env` and customise with your values:

```bash
cp /path/to/directory/.env.example /path/to/directory/.env
# Edit .env with your GitHub username, 1Password reference, and gist IDs
```

**Note:** `.env` is git-ignored and should never be committed, as it contains your personal gist IDs and 1Password references.

### 6. Add the aliases to `.zshrc` (optional)

```bash
alias gist:sync="/path/to/directory/gist-sync.sh"
alias goto:gist-sync="cd /path/to/directory/
```

## Configuration

The `.env` file controls where files are synced to and how they're retrieved.

### Configuration Variables

| Variable | Purpose |
| --- | --- | --- |
| `GITHUB_USERNAME` | Your GitHub username |
| `OP_TOKEN_REFERENCE` | 1Password vault path to GitHub token |
| `GIST_ID_SNIPPETS` | Gist ID for VSCode snippets |
| `GIST_ID_ZSHRC` | Gist ID for .zshrc and settings |
| `SNIPPETS_DIR` | VSCode snippets directory |
| `ZSHRC_PATH` | Path to .zshrc file |
| `ZSH_SETTINGS_DIR` | Directory containing zsh settings |

## Usage

```bash
gist:sync
```

Runs all sync scripts in sequence. Individual scripts can also be run directly if needed.

## Adding a new sync target

1. Create a new `gist-sync-<name>.sh` script:
   - Load `.env` at the top (see existing scripts for pattern)
   - Source `gist-common.sh` for token retrieval and upload helper
   - Define a new gist ID variable (e.g., `GIST_ID_MYCONFIG`)
2. Add a new variable to `.env.example` and `.env` for the gist ID
3. Add a call to the script in `gist-sync.sh`
4. Update the "What gets synced" table in `README.md`
