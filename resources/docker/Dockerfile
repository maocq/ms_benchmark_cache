FROM artifactory.apps.bancolombia.com/devops/elixir:1.11.4-alpine
ENV MIX_ENV=prod
RUN apk add build-base
WORKDIR /app
COPY . /app
RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix deps.compile --force \
    && MIX_ENV=prod mix distillery.release \
    && rm -rf /app/_build/prod/rel/fua/etc
FROM artifactory.apps.bancolombia.com/devops/elixir:1.11.4-alpine
ENV MIX_ENV=prod
WORKDIR /app
EXPOSE 8083
RUN apk update && apk upgrade && apk add bash && ulimit -s 30000 
COPY --from=0 /app/_build/prod /app
VOLUME /app/rel/fua/etc
ENTRYPOINT exec /app/rel/fua/bin/fua foreground