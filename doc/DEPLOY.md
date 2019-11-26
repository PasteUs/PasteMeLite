# PasteMe Lite 部署文档

> 默认监听 8000 端口

## 直接运行

> 由于 sqlite 使用了 cgo，故目前只支持 linux-amd64

前往此项目的 [latest release](https://github.com/PasteUs/PasteMeLite/releases/latest) 页面下载 `pasteme_lite.tar.gz` ，解压后执行 `./pastemed` 即可。

## Docker

```bash
docker run \
    -d \
    -p 80:8000 \
    -v ${PWD}/backend/data/:/data/ \
    registry.cn-hangzhou.aliyuncs.com/pasteus/pasteme-lite:0.0.1
```

## docker-compose

[docker-compose.yml](../docker-compose.yml)
