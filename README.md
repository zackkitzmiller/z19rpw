# Z19rpw

[![Coverage Status](https://coveralls.io/repos/github/zackkitzmiller/z19rpw/badge.svg?branch=main)](https://coveralls.io/github/zackkitzmiller/z19rpw?branch=blog-api)

zack kitzmiller's personal website

## Pull Requests

As I've always done in the past, pull requests are welcome. I'm not a designer, and I don't really care. If you want to make some improvements or.. make things worse, go ahead. Pull down the repo, make some changes, and I'll deploy when I merge the PR in.

## running locally

There's not much to this,

```
$ hub clone zackkitzmiller/z19rpw
$ mix deps.get
$ mix phx.server
```

## tests

sure, i have that

```
mix test
```

## deploy

this is a little more involved. z19rpw is hosted in a k8s cluster on gcp. there's a few pieces

* headless services (ClusterIP) that just lets elixir discover eachother with [libcluster](https://github.com/bitwalker/libcluster)
* a regular service that acts as in ingress
* a coupl'a secrets, mostly just db connection shit
* speaking of, the db is a postgres goog storage instance
* then the deployment
    * currently there are two containers per pod
    * you've got the z19rpw elixir service
    * you've got the cloud_sql_proxy which reads the config from a secret volume stored in googleville somewhere
        * generated with `kubectl create secret generic z19rpw-dbc --from-file=service_account.json=key.json
kubectl create secret generic z19rpw-dbc --from-file=service_account.json=key.json` where `key.json` was configured in console.gcp's iam groups.
* there's a static IP address that I got with `gcloud compute addresses create z19rpw-ip` or something

## release

```
$ ./deploy/release.sh
```

## Environments
* Dev - Local Environment
    - Port 4000
    - DNS: None
    - DB: Cockroach (Homebrew)
    - Ingress: None
    - Mesh: None
    - Service Deploy: None
* Staging - k3s Pi Cluster
    - Port 4000
    - DNS: None
    - DB: Postgres
    - Ingress: Traefic
    - Mesh: Traefic
    - Service Deploy: Yes - Custom (service-staging)
* Prod
    - Port 80:443
    - DNS: Yes (z19r.pw)
    - DB: Cockroach (k8s)
    - Ingress: GKE
    - Mesh: None
    - Service Deploy: Yes - -service w/ ingress.yaml


Dev environment is OK.

### Not Working
* Dev
    - Livereload
    - Node Watcher
    - Libcluster (Not Needed)

* Staging
    - No DNS
    - Postgres DB
    - 32 bit architecture

* Prod
    - No Traefic


Move to envoy from traefic (I think so)
