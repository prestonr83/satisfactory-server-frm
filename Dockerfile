FROM cm2network/steamcmd:root

ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="Custom Satisfactory Dedicated Server" \
      org.opencontainers.image.description="Satisfactory dedicated server image for Unraid built on cm2network/steamcmd:root." \
      org.opencontainers.image.source="https://satisfactory.wiki.gg/wiki/Dedicated_servers"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gosu \
        tini \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /satisfactory /home/steam/.config/Epic/FactoryGame/Saved/SaveGames /scripts \
    && chown -R steam:steam /satisfactory /home/steam /scripts

COPY --chmod=755 docker-entrypoint.sh /scripts/docker-entrypoint.sh
COPY --chmod=755 install-update.sh /scripts/install-update.sh
COPY --chmod=755 start-server.sh /scripts/start-server.sh

ENV HOME=/home/steam \
    STEAMCMDDIR=/home/steam/steamcmd \
    PUID=99 \
    PGID=100 \
    UPDATE_ON_START=true \
    VALIDATE_ON_START=false \
    BRANCH=public \
    STEAM_USER=anonymous \
    STEAM_PASSWORD= \
    GAME_PORT=7777 \
    RELIABLE_PORT=8888 \
    EXTERNAL_RELIABLE_PORT= \
    SERVER_IP=0.0.0.0 \
    DISABLE_SEASONAL_EVENTS=false \
    EXTRA_SERVER_ARGS=

WORKDIR /satisfactory

EXPOSE 7777/udp 7777/tcp 8888/tcp 8080/tcp

VOLUME ["/satisfactory", "/home/steam/.config/Epic/FactoryGame/Saved/SaveGames"]

ENTRYPOINT ["/usr/bin/tini", "--", "/scripts/docker-entrypoint.sh"]
