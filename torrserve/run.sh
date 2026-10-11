#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# TorrServe HA add-on entrypoint.
# Ports logic from Android client ServerFile.kt:
#   torrserver -k --path <setspath> --logpath <logfile> [--httpauth] [--webdav]
# + upstream docker-entrypoint.sh: --port, --torrentsdir

set -e

PORT=$(bashio::config 'port')
HTTP_AUTH=$(bashio::config 'http_auth')
LOGIN=$(bashio::config 'login')
PASSWORD=$(bashio::config 'password')
WEBDAV=$(bashio::config 'enable_webdav')
DONTKILL=$(bashio::config 'dont_kill')
TORRENTS_DIR=$(bashio::config 'torrents_dir')

CONF_PATH="/data"
LOG_PATH="/data/torrserver.log"
ACCS_FILE="${CONF_PATH}/accs.db"

export GODEBUG=madvdontneed=1

mkdir -p "${CONF_PATH}" "${TORRENTS_DIR}"

FLAGS="--path ${CONF_PATH} --logpath ${LOG_PATH} --port ${PORT} --torrentsdir ${TORRENTS_DIR}"

if bashio::config.true 'dont_kill'; then
  FLAGS="${FLAGS} --dontkill"
fi

if bashio::config.true 'enable_webdav'; then
  FLAGS="${FLAGS} --webdav"
fi

if bashio::config.true 'http_auth'; then
  if [ -z "${LOGIN}" ] || [ -z "${PASSWORD}" ]; then
    bashio::log.error "http_auth is enabled but login/password is empty!"
    bashio::exit.nok
  fi
  # Same format as Android ServerFile.storeAccs(): {"user":"pass"}
  printf '{"%s":"%s"}' "${LOGIN}" "${PASSWORD}" > "${ACCS_FILE}"
  bashio::log.info "HTTP auth enabled for user '${LOGIN}'"
  FLAGS="${FLAGS} --httpauth"
else
  rm -f "${ACCS_FILE}" || true
fi

bashio::log.info "Starting TorrServer with: torrserver ${FLAGS}"
bashio::log.info "Web UI: http://<host>:${PORT}/  API: /echo /torrents /stream /settings /viewed"

exec /usr/bin/torrserver ${FLAGS}
