FROM elixir:1.11.2-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git python3

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config

ENV DATABASE_URL=ecto://app@cockroachdb.default.svc.cluster.local:26257/z19rpw
ENV SECRET_KEY_BASE=34PA0jqGQLok1NXTLqNkXCBjRemHgmt/lc25MRMFBHD7tFy02newjvPLQ1gOAyiV

RUN mix do deps.get, deps.compile

# build assets
# COPY assets/package.json assets/package-lock.json ./assets/
# RUN npm uninstall node-sass -g && npm cache clean --force && npm install node-sass
# RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error --production

COPY priv priv
COPY assets assets
# RUN npm run --prefix ./assets deploy
RUN mix phx.digest

COPY lib lib
COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/z19rpw ./

ENV HOME=/app

CMD ["bin/z19rpw", "start"]
