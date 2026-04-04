# Agent Guidelines for npm-sync

## Project Overview
This repository contains a Bash script that synchronizes CNAME DNS records between Pi-hole and Nginx Proxy Manager (NPM). The script fetches domains from NPM's REST API and manages Pi-hole DNS records through its REST API.

## Build/Test Commands

### Running the Script
```bash
# Execute manually
npm-sync

# Or from source
./npm-sync
```

### Testing
No automated test suite exists. Manual testing requires:
1. Valid Pi-hole and NPM instances
2. SSH key authentication configured
3. Environment file configured with credentials

### Debugging
```bash
# Run with bash debug mode
bash -x npm-sync

# Check script syntax
bash -n npm-sync

# Check with ShellCheck if available (recommended)
shellcheck npm-sync
```

## Code Style Guidelines

### Bash Scripting
- Use `#!/bin/bash` shebang
- Always include `set -e` at the top to exit on errors
- Define cleanup functions and use `trap cleanup EXIT INT TERM`
- Use double quotes `"$VAR"` around variable expansions to prevent word splitting
- Use `[[ ]]` for conditional tests instead of `[ ]` or `test`
- Use `$(command)` for command substitution instead of backticks

### Formatting
- Indentation: 2 spaces (no tabs)
- Line length: Keep under 120 characters where practical
- Blank lines: One between logical sections

### Error Handling
- Always check HTTP response codes with `curl -w "%{http_code}"`
- Capture exit codes from commands: `local exit_code=$?`
- Use `|| true` for non-critical failures in cleanup
- Validate environment variables before use
- Check for null JSON responses: `if [[ "$SID" == "null" ]]; then`

### Variable Naming
- Environment variables: UPPERCASE (e.g., `PIHOLE_PASSWORD`, `NPM_HOST`)
- Local variables: UPPERCASE (e.g., `CSV`, `DOMAINS`, `SID`)
- Constants: UPPERCASE (e.g., `MIN_DOMAIN_COUNT`, `CLEANUP_ORPHANS`)
- Loop variables: lowercase (e.g., `domain`, `ORPHAN_DOMAIN`)

### Output Messages
- Use emojis for visual feedback: ✅ ❌ ⚠️ 📥 🔐
- Prefix messages with meaningful icons
- Use French for user-facing messages (consistent with existing code)
- Redirect errors appropriately: `2>&1` for logging

### External Dependencies
- `jq`: JSON parsing - required
- `curl`: HTTP requests - required
- `sqlite3`: Database queries (via SSH) - required
- `awk`, `sed`, `grep`, `sort`, `comm`, `wc`: Standard Unix tools

### Security
- Never log passwords or sensitive tokens
- Use trap to cleanup sensitive environment variables
- Validate input from environment files
- API endpoints should be secured with proper authentication if exposed

### File Paths
- Environment files: Use absolute paths (e.g., `/root/.env_npm-sync`)
- Temporary files: Use `/tmp/` prefix
- Clean up temporary files in the exit handler

### Comments
- Use French for code comments
- Keep comments concise and focused on "why" not "what"
- Section comments on their own line with blank lines above/below

## Installation
Run `sh install.sh` to install the script to `/usr/local/bin/npm-sync` and set up environment files.

## Environment Variables
Required in `~/.env_npm-sync`:
- `PIHOLE_PASSWORD`: Pi-hole admin password
- `PIHOLE_HOST`: Pi-hole URL (e.g., http://pihole.local)
- `NPM_HOST`: NPM API URL (e.g., http://192.168.x.x:5000)
- `MIN_DOMAIN_COUNT`: Minimum domains per target (default: 1)
- `CLEANUP_ORPHANS`: Remove orphaned CNAMEs (true/false)

## API Endpoints Used
- Pi-hole Auth: POST `/api/auth` with password
- Pi-hole CNAME: GET/PUT/DELETE `/api/config/dns/cnameRecords`
- Pi-hole DNS Restart: POST `/api/action/restartdns`
- NPM Hosts: GET `/api/hosts` returns JSON array with host objects containing `domain_names`
