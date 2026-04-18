FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="Custom Satisfactory Dedicated Server" \
      org.opencontainers.image.description="Standalone SteamCMD-based Satisfactory dedicated server image for Unraid." \
      org.opencontainers.image.source="https://satisfactory.wiki.gg/wiki/Dedicated_servers"

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gosu \
        lib32gcc-s1 \
        libstdc++6:i386 \
        libcurl4:i386 \
        libc6:i386 \
        libncurses5:i386 \
        libbz2-1.0:i386 \
        tini \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 steam \
    && useradd -m -u 1000 -g 1000 -s /bin/bash steam \
    && mkdir -p /opt/steamcmd /satisfactory /home/steam/.config/Epic/FactoryGame/Saved/SaveGames /scripts \
    && chown -R steam:steam /opt/steamcmd /satisfactory /home/steam /scripts

RUN curl -fsSL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" \
    | tar -xz -C /opt/steamcmd \
    && chown -R steam:steam /opt/steamcmd

COPY --chmod=755 docker-entrypoint.sh /scripts/docker-entrypoint.sh
COPY --chmod=755 install-update.sh /scripts/install-update.sh
COPY --chmod=755 start-server.sh /scripts/start-server.sh

ENV PUID=99 \
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
