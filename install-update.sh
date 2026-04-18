#!/usr/bin/env bash
set -euo pipefail

STEAMCMD="/opt/steamcmd/steamcmd.sh"
INSTALL_DIR="/satisfactory"
APP_ID="1690800"

mkdir -p "${INSTALL_DIR}"

should_update="${UPDATE_ON_START,,}"
should_validate="${VALIDATE_ON_START,,}"
branch="${BRANCH:-public}"
steam_user="${STEAM_USER:-anonymous}"
steam_password="${STEAM_PASSWORD:-}"

if [[ "${should_update}" != "true" && -x "${INSTALL_DIR}/FactoryServer.sh" ]]; then
  exit 0
fi

cmd=("${STEAMCMD}" "+force_install_dir" "${INSTALL_DIR}" "+login")
if [[ "${steam_user}" == "anonymous" ]]; then
  cmd+=("anonymous")
else
  cmd+=("${steam_user}" "${steam_password}")
fi

cmd+=("+app_update" "${APP_ID}")
if [[ "${branch}" != "public" && -n "${branch}" ]]; then
  cmd+=("-beta" "${branch}")
fi
if [[ "${should_validate}" == "true" ]]; then
  cmd+=("validate")
fi
cmd+=("+quit")

"${cmd[@]}"
