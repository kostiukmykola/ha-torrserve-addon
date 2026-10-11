# TorrServe for Home Assistant

Цей репозиторій — HA add-on репозиторій, згенерований з Android `TorrServe MatriX.143.Client`.

- `torrserve/` — сам add-on (Dockerfile качає Go-бінарник `TorrServer`, `run.sh` повторює `ServerFile.run()`).
- Upstream сервер: https://github.com/YouROK/TorrServer
- Upstream клієнт (референс API/логіки): https://github.com/YouROK/TorrServe (тег `MatriX.143.Client`)

Встановлення: HA -> Settings -> Add-ons -> Add-on Store -> Repositories -> додати URL цього git-репо.
