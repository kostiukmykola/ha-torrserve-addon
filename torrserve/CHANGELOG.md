# Changelog
## 1.0.3
- Downgrade TorrServer MatriX.146 -> MatriX.143 for Lampa compatibility
- MatriX.146 returned `403 Banned` for `bylampa.online` Referer, 143 does not block mirrors
## 1.0.2
- Add `ffmpeg` (provides `ffprobe`) for `/ffp` endpoint
- Fix `ffprobe and avprobe not found in $PATH` warning
## 1.0.1
- Fix HA discovery: `arch` amd64/aarch64 only (Supervisor 2026.04+ accepts only these)
- Fix `webui` syntax to `http://[HOST]:[PORT:8090]/`
- Change label `io.hass.type` addon -> app, fix translations and repository.yaml
## 1.0.0
- Initial HA add-on wrapping TorrServer MatriX.146
- Ported launch flags from Android `ServerFile.kt` / `TorrService.kt`
- Options: port, http_auth, webdav, dontkill, torrents_dir
