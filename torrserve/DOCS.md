# TorrServe Home Assistant Add-on

Порт Android-клієнта `MatriX.143.Client` в HA Add-on: запускає Go-сервер `TorrServer`
(той самий бінарник, який Android-клієнт качав через `UpdaterServer` і запускав через `ServerFile`/`TorrService`).

## Що всередині

- Бінарник береться з `https://github.com/YouROK/TorrServer/releases` (за замовч. `MatriX.146`, див. `Dockerfile` `TORRSERVER_VERSION`).
- Мапінг архітектур (з `UpdaterServer.getArch()` + `server_release.json`):
  - `amd64` -> `linux-amd64`
  - `aarch64` -> `linux-arm64`
  - `armv7` -> `linux-arm7`
  - `armhf` -> `linux-arm5`
  - `i386` -> `linux-386`
- Запуск повторює `ServerFile.run()`:
  `torrserver --path /data --logpath /data/torrserver.log --port <port> --torrentsdir <dir> [--dontkill] [--httpauth] [--webdav]`
  + `GODEBUG=madvdontneed=1`, `accs.db` у форматі `{"user":"pass"}`.
- API той самий, що використовує `server/api/Api.kt`:
  `GET /echo, /shutdown, /ffp/{hash}/{id}, /search?query=, /stream/...`
  `POST /torrents {add,get,rem,list,drop}`, `/settings`, `/viewed`, `/torrent/upload`.

## Налаштування

| Опція | За замовч. | Опис |
|---|---|---|
| `port` | 8090 | Web UI + API порт |
| `http_auth` | false | Увімкнути `--httpauth` |
| `login` / `password` | "" | Пишуться в `/data/accs.db` |
| `enable_webdav` | false | `--webdav` |
| `dont_kill` | true | `--dontkill` (`-k`, як в Android) |
| `torrents_dir` | `/data/torrents` | `--torrentsdir` |

`host_network: true` увімкнено для DLNA (опція `EnableDLNA` в `BTSets`) і пошуку, як в оригіналі.

## Використання

1. Встанови репозиторій в HA: Налаштування -> Add-ons -> Repositories -> додай URL цього репо.
2. Встанови TorrServe, вистав порт/логін, Start.
3. Відкрий Web UI або звертайся з автоматизацій:
  `curl http://homeassistant:8090/echo`
  `curl -X POST http://homeassistant:8090/torrents -d '{"action":"list"}'`
4. Стрім: `GET /stream/<name>?link=<hash>&index=<id>&play` — можна віддавати в VLC/Kodi або `media_player.play_media` в HA.
5. Тонкі налаштування BT (`BTSets`: CacheSize, PreloadCache, EnableIPv6, ConnectionsLimit...) — через Web UI TorrServer `/settings`, як робив `ServerSettingsFragment`.

## Оновлення сервера

Зміни `TORRSERVER_VERSION` в `Dockerfile` (актуальну дивись в `https://releases.yourok.ru/torr/server_release.json`) і підніми `version` в `config.yaml`.
