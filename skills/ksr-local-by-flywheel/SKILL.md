---
name: ksr-local-by-flywheel
description: Work on WordPress sites managed by Local (LocalWP, Local by Flywheel) via the `localwp` CLI - WP-CLI, database, wp-admin/browser access, files and logs. Use whenever a task touches a Local site - a `*.local` domain, a path under `~/Local Sites` or `~/Local-Sites`, the user mentioning Local, or a site name `localwp list` knows (with or without `.local`).
---

# Local sites

## 1. CLI

Find the CLI with `command -v localwp`. If that finds nothing, try `~/.config/Local/bin/localwp`. If it is still missing, **stop and report**: the user must enable Local → Preferences → Advanced → "Install Local CLI".

## 2. Site ID

Run `localwp list --json` and match the user's reference against `domain` (with `.local` optional), then `name` (case-insensitive), then `path`. Use the matching `id` in every command. If several sites match, or none do, ask the user.

## 3. Running

If `status` isn't `running`, run `localwp start <id>`, then confirm the status with `localwp info <id> --json`. If the site is still not running after two attempts, **stop and report**.

## 4. WP-CLI

```bash
localwp cli <id> -- plugin list --format=json
```

Pass the arguments as separate words after `--`, without `wp`. A single quoted command string is rejected.

## 5. Database

Run `wp db` commands through `scripts/local-wp.sh`, found in this skill's directory, not through `localwp cli`:

```bash
scripts/local-wp.sh <id> db query "SELECT COUNT(*) FROM wp_posts"
```

## 6. wp-admin

To log in as admin, open `<url>/wp-admin/?localwp_auto_login=1` in Playwright, then go to the page you need. If you land on `wp-login.php` instead, **stop and report**.

## 7. Paths

`localwp info <id> --json --full` gives `url` and `paths`, including `webRoot` and `logs`. PHP errors are in `<logs>/php/error.log`.
