#!/usr/bin/env bash
# Run WP-CLI against a Local site with the PHP and MySQL versions Local selected for it.
# Usage: local-wp.sh <site-id> <wp-cli args...>
set -euo pipefail

die() { echo "local-wp: $*" >&2; exit 1; }
[[ $# -ge 2 ]] || die "usage: local-wp.sh <site-id> <wp-cli args...>"
ID=$1; shift

DATA=~/.config/Local
RUN=$DATA/run/$ID
WP_CLI=/opt/Local/resources/extraResources/bin/wp-cli/wp-cli.phar

IFS=$'\t' read -r SITE PHP_V DB_N DB_V < <(python3 -I -c '
import json, sys
s = json.load(open(sys.argv[1]))[sys.argv[2]]
v = s["services"]
print(s["path"], v["php"]["version"], v["mysql"]["name"], v["mysql"]["version"], sep="\t")
' "$DATA/sites.json" "$ID" 2>/dev/null) || die "no site with ID '$ID' (see: localwp list --json)"

service() { ls -d "$DATA/lightning-services/$1-$2"* 2>/dev/null | sort -V | tail -1; }
PHP=$(service php "$PHP_V")/bin/linux
DB=$(service "$DB_N" "$DB_V")/bin/linux
[[ -x $PHP/bin/php ]] || die "PHP $PHP_V not installed yet"
[[ -S $RUN/mysql/mysqld.sock ]] || die "site not running (localwp start $ID)"

export PATH="$DB/bin:$PATH" LD_LIBRARY_PATH="$PHP/shared-libs" PHPRC="$RUN/conf/php" MYSQL_UNIX_PORT="$RUN/mysql/mysqld.sock"
exec "$PHP/bin/php" "$WP_CLI" --path="${SITE/#\~/$HOME}/app/public" "$@"
