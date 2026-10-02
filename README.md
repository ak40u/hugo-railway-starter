# Hugo starter for Railway

A minimal Hugo site that builds and serves through a Dockerfile, so the platform's
builder cannot decide to do something else.

## Why this exists

The Hugo template on Railway configures its build in `nixpacks.toml`. Railway has
since moved to a different builder, which ignores that file — and then finds nothing
to run:

```
⚠ Script start.sh not found
railpack process exited with an error
```

Nothing about the site is wrong. The build instructions are simply addressed to a
builder that is no longer used.

This starter ships a `Dockerfile` instead. A Dockerfile is not a hint the builder may
reinterpret — it is the build. Hugo is pinned to a specific version, and the output is
served by Caddy.

## What's in here

| File | Why it exists |
|------|---------------|
| `Dockerfile` | Two stages: `hugomods/hugo:0.165.0` builds, `caddy:2-alpine` serves |
| `Caddyfile` | Serves `/srv` on `$PORT`, gzip/zstd, a real 404 page |
| `hugo.toml` | Site config; `baseURL` comes from the build, not from this file |
| `layouts/` | Minimal templates — a list, a single page, and a shared shell |
| `content/posts/` | One example post |

`baseURL` is passed at build time from `RAILWAY_PUBLIC_DOMAIN`, so canonical URLs and
feeds are correct without editing the config after each deploy. Building locally
without that variable falls back to a relative base, so `docker build` still works.

## Add a page

```bash
hugo new content posts/my-post.md
```

Edit the file, drop `draft: true`, commit, push.

## Run locally

```bash
hugo server        # http://localhost:1313
```

Or exactly as production runs it:

```bash
docker build -t site . && docker run -p 8080:8080 -e PORT=8080 site
```

## License

MIT
