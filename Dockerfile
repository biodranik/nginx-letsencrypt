FROM nginx:mainline-alpine AS base
LABEL maintainer="Alexander Borsuk <me@alex.bio>"
LABEL description="nginx + LetsEncrypt (Certbot) with templates"

ENV LETSENCRYPT_EMAIL="${LETSENCRYPT_EMAIL}"

# Overwrite default nginx configs with ours.
COPY ./conf/ /etc/nginx/
# LetsEncrypt/Certbot renew cron script.
COPY ./renew_letsencrypt /etc/periodic/daily/
# Main entry point to launch on container startup.
COPY ./entrypoint.sh /entrypoint.sh

RUN set -eux && \
  apk -U upgrade && \
  apk add --no-cache certbot && \
  mkdir -p /var/lib/www /var/lib/certbot && \
  rm /var/cache/apk/* && \
  rm /etc/nginx/conf.d/default.conf

VOLUME /etc/letsencrypt /var/lib/www
EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
