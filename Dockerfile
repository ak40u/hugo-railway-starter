# Build the site with a pinned Hugo, then serve the static output with Caddy.
# A Dockerfile keeps this deterministic: the platform's builder cannot decide to
# run something else, which is exactly how the nixpacks-based version broke.
FROM hugomods/hugo:0.165.0 AS build

WORKDIR /src
COPY . .

# RAILWAY_PUBLIC_DOMAIN is available at build time; fall back to a relative base
# so local `docker build` also produces working links.
ARG RAILWAY_PUBLIC_DOMAIN
RUN if [ -n "$RAILWAY_PUBLIC_DOMAIN" ]; then \
      hugo --minify --baseURL "https://$RAILWAY_PUBLIC_DOMAIN/"; \
    else \
      hugo --minify --baseURL "/"; \
    fi

FROM caddy:2-alpine
COPY --from=build /src/public /srv
COPY Caddyfile /etc/caddy/Caddyfile
