#!/usr/bin/env bash
set -euo pipefail

STEAM_HOME="/home/steam"
SAVE_DIR="${STEAM_HOME}/.config/Epic/FactoryGame/Saved/SaveGames"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "This container expects to start as root so it can apply PUID/PGID before dropping privileges." >&2
  exit 1
fi

CURRENT_GID="$(getent group steam | cut -d: -f3)"
CURRENT_UID="$(id -u steam)"

if [[ -n "${PGID:-}" && "${PGID}" != "${CURRENT_GID}" ]]; then
  groupmod -o -g "${PGID}" steam
fi

if [[ -n "${PUID:-}" && "${PUID}" != "${CURRENT_UID}" ]]; then
  usermod -o -u "${PUID}" steam
fi

mkdir -p /satisfactory "${SAVE_DIR}"
chown -R steam:steam /satisfactory "${STEAM_HOME}"

exec gosu steam:steam bash -lc '
  set -euo pipefail
  export HOME="/home/steam"
  /scripts/install-update.sh
  exec /scripts/start-server.sh
'
