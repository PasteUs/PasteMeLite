FROM node:12 as frontend_builder
COPY ./PasteMeFrontend /source
COPY ./vue.config.js /source/vue.config.js
WORKDIR /source
RUN npm install --registry=https://registry.npm.taobao.org
RUN npm run build
RUN mv pasteme_frontend/usr/config.example.json pasteme_frontend/usr/config.json
RUN rm -rf pasteme_frontend/conf.d pasteme_frontend/report.html

FROM golang:1.13-alpine as backend_builder
COPY ./PasteMeGoBackend /go/src/github.com/PasteUs/PasteMeGoBackend
COPY ./server.go /go/src/github.com/PasteUs/PasteMeGoBackend/server/server.go
ENV GO111MODULE=on \
    GOPROXY=https://goproxy.io \
    GOOS=linux
WORKDIR /go/src/github.com/PasteUs/PasteMeGoBackend
RUN apk --no-cache add g++
RUN go mod download
RUN go build main.go

FROM alpine:3
LABEL maintainer="Lucien Shui" \
      email="lucien@lucien.ink"
COPY --from=backend_builder /go/src/github.com/PasteUs/PasteMeGoBackend/main /usr/bin/pastemed
COPY --from=frontend_builder /source/pasteme_frontend /pasteme_frontend
RUN chmod +x /usr/bin/pastemed && \
    mkdir /data && \
    mkdir /config && \
    echo '{"address":"0.0.0.0","port":8000,"database":{"type":"sqlite","username":"username","password":"password","server":"pasteme-mysql","port":3306,"database":"pasteme"}}' > /config/config.json
CMD ["pastemed", "-c", "/config/config.json", "-d", "/data"]