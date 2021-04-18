FROM postgres:12.4-alpine AS postgres

FROM elixir:1.11.2-alpine
EXPOSE 4000

ENV APP_PATH /app
ENV TZ "America/Sao_Paulo"

RUN mix local.hex --force \
  && mix local.rebar --force \
  && apk --no-cache --update add bash alpine-sdk coreutils curl postgresql-client inotify-tools yarn \
  && rm -rf /var/cache/apk/* \
  && mkdir $APP_PATH

COPY --from=postgres /usr/local/bin/pg_dump /usr/local/bin/pg_dump

COPY . $APP_PATH
WORKDIR $APP_PATH

RUN mix deps.get

CMD ["mix", "phx.server"]
