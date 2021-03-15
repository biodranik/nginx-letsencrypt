#!/bin/sh
set -eu

# Print environment on startup.
/usr/bin/env | /usr/bin/sort

# Scan all domains and get or update Letsencrypt certificates.
# Port 80 should be exposed to the Internet.
for f in /var/lib/www/*.conf; do
  domain=${f##*/}  # Strip path.
  domain=${domain%.conf}  # Strip extension.
  if [ -z "${domain##*localhost*}" ]; then
    continue  # Skip localhost servers.
  fi
  DOMAINS="$domain ${DOMAINS:-}"
  certbot certonly -n -d "$domain" --standalone --agree-tos \
      --preferred-challenges http --expand --email "$LETSENCRYPT_EMAIL"
done
# Used in HTTP => HTTPS redirect.
export DOMAINS

# Run cron daemon for automatic Letsencrypt updates (see ./renew_letsencrypt script).
/usr/sbin/crond -f -d 8 &

# Run nginx script for env vars substitution (added in nginx image 1.19).
# See https://hub.docker.com/_/nginx for more details.
# After that, start nginx in foreground.
# exec properly delegates SIGQUIT for graceful shutdown.
exec /docker-entrypoint.sh nginx -g 'daemon off;'
