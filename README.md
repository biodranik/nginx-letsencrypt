# Nginx Docker image with automated LetsEncrypt (Certbot) HTTPS/SSL certificates and multiple vhosts

## How to use

Sample `docker-compose.yml`:

```yml
version: "3.8"
services:
  nginx:
    image: biodranik/nginx-letsencrypt
    environment:
      LETSENCRYPT_EMAIL: YOUR@EMAIL
      TZ: "${TZ:-Europe/Berlin}"  # Set for proper container time.
    ports:
      - 8080:80  # Change to your needs.
      - 8443:443  # Change to your needs.
    volumes:
      - letsencrypt:/etc/letsencrypt
      - ./YOUR_WWW_WITH_CONFIGS:/var/lib/www
volumes:
  letsencrypt:
```

Where YOUR_WWW_WITH_CONFIGS is a host directory with nginx server configs (and
static data, if necessary):

```
www/first.domain.name.conf
www/first.domain.name/index.html
www/second.domain.name.conf
```

The simplest `first.domain.name.conf` may look like this:

```conf
server {
  server_name FIRST.DOMAIN_NAME;
  ssl_certificate /etc/letsencrypt/live/FIRST.DOMAIN_NAME/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/FIRST.DOMAIN_NAME/privkey.pem;
  root /var/lib/www/FIRST.DOMAIN_NAME;  # Put your static files here.

  # To serve static content.
  location / {
    try_files $uri $uri/ =404;
  }

  # All common params for all servers, including listen and certbot configs.
  include /etc/nginx/server.default.conf;
}
```

## Notes

- The image is based on [nginx:mainline-alpine](https://hub.docker.com/_/nginx).
- `python3` is also installed in the image, as it's used by Certbot.
