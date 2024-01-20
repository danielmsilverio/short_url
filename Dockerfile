FROM elixir:1.15

RUN apt-get update && \
    apt-get install --yes build-essential inotify-tools postgresql-client git && \
    apt-get clean

ADD . /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /app

# install mix dependencies
RUN mix deps.get
RUN mix deps.compile

EXPOSE 4000

CMD ["/app/entrypoint.sh"]
