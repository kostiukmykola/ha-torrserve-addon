# TorrServe HA add-on
# Base image is multi-arch (amd64/aarch64/armv7). Binary is selected via BUILD_ARCH.
FROM ghcr.io/home-assistant/base:latest

ARG BUILD_ARCH
ARG TORRSERVER_VERSION="MatriX.146"

# Install deps (curl for download, jq for bashio is already in base)
RUN apk add --no-cache curl

# Map HA arch -> TorrServer linux build (see server_release.json: linux-amd64/arm64/arm7/arm5/386)
# amd64 -> linux-amd64, aarch64 -> linux-arm64, armv7 -> linux-arm7, armhf -> linux-arm5, i386 -> linux-386
RUN set -eux; \
    case "${BUILD_ARCH}" in \
      amd64)  TS_ARCH="linux-amd64" ;; \
      aarch64) TS_ARCH="linux-arm64" ;; \
      armv7)  TS_ARCH="linux-arm7" ;; \
      armhf)  TS_ARCH="linux-arm5" ;; \
      i386)   TS_ARCH="linux-386" ;; \
      *) echo "Unsupported arch: ${BUILD_ARCH}"; exit 1 ;; \
    esac; \
    echo "Downloading TorrServer ${TORRSERVER_VERSION} ${TS_ARCH}"; \
    curl -fsSL -o /usr/bin/torrserver \
      "https://github.com/YouROK/TorrServer/releases/download/${TORRSERVER_VERSION}/TorrServer-${TS_ARCH}"; \
    chmod +x /usr/bin/torrserver; \
    /usr/bin/torrserver --help 2>&1 | head -20 || true

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]

LABEL \
  org.opencontainers.image.title="TorrServe" \
  org.opencontainers.image.description="Torrent-to-HTTP server for Home Assistant" \
  org.opencontainers.image.source="https://github.com/YouROK/TorrServer" \
  io.hass.version="1.0.1" \
  io.hass.type="app" \
  io.hass.arch="amd64|aarch64"
