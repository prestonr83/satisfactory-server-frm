# Custom Satisfactory Server Image

This folder contains a standalone Satisfactory dedicated server image built from `ubuntu:24.04` plus SteamCMD. It does not depend on `indifferentbroccoli/satisfactory-server-docker`.

## Build

Build and tag the image as `local/satisfactory-server-frm:latest`:

```bash
cd /mnt/user/appdata/satisfactory-custom-image
docker build -t local/satisfactory-server-frm:latest .
```

## GitHub hosting

This folder now includes a GitHub Actions workflow at `.github/workflows/publish-image.yml` that builds the image and publishes it to GitHub Container Registry (`ghcr.io`).

Expected hosted image name:

`ghcr.io/<your-github-owner>/satisfactory-server-frm:latest`

Workflow behavior:

- builds on pull requests
- builds and pushes on `main`
- builds and pushes on tags like `v1.0.0`
- builds and pushes when a GitHub release is published

For the publish step to work:

1. Put these files in their own GitHub repository with this folder as the repo root.
2. Keep GitHub Actions enabled for the repo.
3. Give the workflow `packages: write` permission, which is already set in the workflow.
4. Make the package public in GHCR after the first push if you want Unraid to pull it without GitHub authentication.

After the first publish, your Unraid XML should point to the GHCR image instead of the local tag.

## What the image does

- Installs SteamCMD directly from Valve
- Downloads or updates the Satisfactory dedicated server with app ID `1690800`
- Starts the server via `./FactoryServer.sh`
- Supports Unraid `PUID` and `PGID`
- Persists:
  - `/satisfactory`
  - `/home/steam/.config/Epic/FactoryGame/Saved/SaveGames`
- Exposes:
  - `7777/udp`
  - `7777/tcp`
  - `8888/tcp`
  - `8080/tcp` for the Ficsit Remote Monitoring web/API

## Supported environment variables

- `PUID` and `PGID`
- `UPDATE_ON_START=true|false`
- `VALIDATE_ON_START=true|false`
- `BRANCH=public|experimental`
- `STEAM_USER` and `STEAM_PASSWORD`
- `GAME_PORT`
- `RELIABLE_PORT`
- `EXTERNAL_RELIABLE_PORT`
- `SERVER_IP`
- `DISABLE_SEASONAL_EVENTS=true|false`
- `EXTRA_SERVER_ARGS`

## Important FRM note

This image only exposes `8080/tcp`. The FRM mod still has to be installed in the server and configured to start its HTTP server. FRM documentation says the default web port is `8080`, and the web server is not active until started or configured with `Web_Autostart=true`.

## Unraid use

The matching Unraid template in this workspace now points to:

`ghcr.io/prestonr83/satisfactory-server-frm:latest`

If your GitHub owner is not `prestonr83`, change the XML `Repository` field before importing it into `/boot/config/plugins/dockerMan/templates-user/`.
