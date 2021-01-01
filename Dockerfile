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

ARG aws_key
ARG aws_secret
ARG sendgrid_api_key

ENV AWS_ACCESS_KEY_ID=${aws_key}
ENV AWS_SECRET_ACCESS_KEY=${aws_secret}
ENV SENDGRID_API_KEY=${sendgrid_api_key}}

ENV DATABASE_URL=ecto://app@cockroachdb.default.svc.cluster.local:26257/z19r
ENV SECRET_KEY_BASE=34PA0jqGQLok1NXTLqNkXCBjRemHgmt/lc25MRMFBHD7tFy02newjvPLQ1gOAyiV
RUN mix do deps.get, deps.compile

COPY priv priv
COPY assets assets
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
