#!/usr/bin/env bash
set -euo pipefail

cd /satisfactory

if [[ ! -x ./FactoryServer.sh ]]; then
  echo "FactoryServer.sh not found in /satisfactory. SteamCMD install/update likely failed." >&2
  exit 1
fi

args=(
  "-unattended"
  "-log"
  "-Port=${GAME_PORT:-7777}"
  "-ReliablePort=${RELIABLE_PORT:-8888}"
)

if [[ -n "${EXTERNAL_RELIABLE_PORT:-}" ]]; then
  args+=("-ExternalReliablePort=${EXTERNAL_RELIABLE_PORT}")
fi

if [[ -n "${SERVER_IP:-}" && "${SERVER_IP}" != "0.0.0.0" ]]; then
  args+=("-multihome=${SERVER_IP}")
fi

if [[ "${DISABLE_SEASONAL_EVENTS,,}" == "true" ]]; then
  args+=("-DisableSeasonalEvents")
fi

if [[ -n "${EXTRA_SERVER_ARGS:-}" ]]; then
  # Intentionally split on shell whitespace so users can pass multiple flags.
  # shellcheck disable=SC2206
  extra_args=(${EXTRA_SERVER_ARGS})
  args+=("${extra_args[@]}")
fi

exec ./FactoryServer.sh "${args[@]}"
