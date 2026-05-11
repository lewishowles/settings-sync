# settings-sync

Keeps global configuration files in sync with version-controlled repos.

## What gets synced

| Script | Configuration | Contents |
| --- | --- | --- |
| `settings-sync-snippets.sh` | `SNIPPETS_DIR`, `VSCODE_CONFIG_DIR` in `.env` | VS Code snippet `.json` files |

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

### 5. Configure settings-sync

Copy `.env.example` to `.env` and customise with your values:

```bash
cp /path/to/directory/.env.example /path/to/directory/.env
```

**Note:** `.env` is git-ignored and should never be committed, as it contains your personal 1Password references.

### 6. Add the aliases to `.zshrc` (optional)

```bash
alias sync:settings="/path/to/directory/settings-sync.sh"
alias goto:settings-sync="cd /path/to/directory"
```

## Configuration

The `.env` file controls where files are synced from and to.

### Configuration variables

| Variable | Purpose |
| --- | --- |
| `GITHUB_USERNAME` | Your GitHub username |
| `OP_TOKEN_REFERENCE` | 1Password vault path to GitHub token |
| `SNIPPETS_DIR` | VS Code snippets directory |
| `VSCODE_CONFIG_DIR` | VS Code configuration repo directory |

## Usage

```bash
sync:settings
```

Runs all sync scripts in sequence. Individual scripts can also be run directly if needed.

## Adding a new sync target

1. Create a new `settings-sync-<name>.sh` script:
   - Source `support/colours.sh` and `.env` at the top (see existing scripts for pattern)
   - Copy or process the relevant files into the destination repo
2. Add any new path variables to `.env.example` and `.env`
3. Add a call to the script in `settings-sync.sh`
4. Update the "What gets synced" table in this README
