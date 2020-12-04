# Z19rpw

[![Coverage Status](https://coveralls.io/repos/github/zackkitzmiller/z19rpw/badge.svg?branch=main)](https://coveralls.io/github/zackkitzmiller/z19rpw?branch=blog-api)
![Tests](https://github.com/zackkitzmiller/z19rpw/workflows/does%20it%20blend%3F/badge.svg)

zack kitzmiller's personal website

## Pull Requests

As I've always done in the past, pull requests are welcome. I'm not a designer, and I don't really care. If you want to make some improvements or.. make things worse, go ahead. Pull down the repo, make some changes, and I'll merge them in. GitHub actions will take care of the release.

## Running Locally

There's not much to this:

Dependancies:

z19rpw currently depends on:

- CockroachDB
- Memcached

If you're on an Intel based Mac you can install with

```
$ brew install cockroachdb/tap/cockroach memcached
```

You need update the configuration of CockroachDB in `config/dev.exs` and `config/test.exs`. That should be enough to get you up and running.

```
$ hub clone zackkitzmiller/z19rpw
$ mix deps.get
$ mix phx.server
```

If this doesn't work, please open an issue and I'll take a look at it.

## tests

Yup! To run the test suite make sure that `config/test.exs` is correctly pointing to CockroachDB (or Postgres) and run:

```
MIX_ENV=test mix coveralls
```

You might get an warning about reporting to Sentry because of a missing DSN. It can safely be ignored as I don't want tests reporting errors to Sentry.

## Release

Releases are handled by GitHub actions. You can see the build configuration at `.github/workflows/main.yml`. 

## Architecture

z19rpw is currently hosted on a Raspberry Pi cluster that sits on my desk. It's a 10 node configuration running Kubernetes with routing handled by Traefik. DNS is served by Google Cloud DNS.

## Varnish

- `cd deploy && kubectl create configmap varnish-vcl --from-file=default.vcl` to create the configmap
- `kubectl delete configmap varnish-vcl` to delete the configmap
- On a varnish pod `varnishlog -i VCL_Log` to tail custom logs
- `kubectl rollout restart deployment varnish-proxy` to purchase the cache. This is also done on deploy
