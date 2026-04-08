# Agent Guidelines for npm-sync

## Project Overview
This repository contains a Bash script that synchronizes CNAME DNS records between Pi-hole and Nginx Proxy Manager (NPM). The script fetches domains from NPM's REST API and manages Pi-hole DNS records through its REST API.

## Build/Test Commands

### Running the Script
```bash
npm-sync
# Or from source
./npm-sync
```

### Debugging
```bash
bash -x npm-sync    # debug mode
bash -n npm-sync    # syntax check
shellcheck npm-sync # recommended linter
```

No automated test suite exists. Manual testing requires valid Pi-hole and NPM instances.

## Code Style

### Bash Conventions
- Always `set -e` at top; use `trap cleanup EXIT INT TERM`
- Double quotes around variable expansions: `"$VAR"`
- Use `[[ ]]` for conditionals, `$(command)` for substitution
- Indentation: 2 spaces (no tabs)
- Loop variables: lowercase; constants: UPPERCASE

### Output
- Use emojis: ✅ ❌ ⚠️ 📥 🔐
- User-facing messages in French

### External Dependencies
`jq`, `curl`, `sqlite3`, `awk`, `sed`, `grep`, `sort`, `comm`, `wc`

## Installation
Run `sh install.sh` to install the script to `/usr/local/bin/npm-sync` and set up environment files.

## Environment Variables
Required in `/root/.env_npm-sync`:
- `PIHOLE_PASSWORD`: Pi-hole admin password
- `PIHOLE_HOST`: Pi-hole URL (e.g., http://pihole.local)
- `NPM_HOST`: NPM API URL (e.g., http://192.168.x.x:5000)
- `MIN_DOMAIN_COUNT`: Minimum subdomains per target domain (script default: 3, README says 1 - script wins)
- `CLEANUP_ORPHANS`: Remove orphaned CNAMEs (true/false)

## API Endpoints Used
- Pi-hole Auth: POST `/api/auth` with password
- Pi-hole CNAME: GET/PUT/DELETE `/api/config/dns/cnameRecords`
- Pi-hole DNS Restart: POST `/api/action/restartdns`
- NPM Hosts: GET `/api/hosts` returns JSON array with host objects containing `domain_names`
