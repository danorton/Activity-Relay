FROM golang:1.20.1-alpine AS build

WORKDIR /Activity-Relay
COPY . /Activity-Relay

RUN  mkdir -p /rootfs/usr/bin && \
     apk add -U --no-cache git && \
     go build -o /rootfs/usr/bin/relay -ldflags "-X main.version=$(git describe --tags HEAD | sed -r 's/v(.*)/\1/')" .

FROM alpine:3.17.2

COPY --from=build /rootfs/usr/bin /usr/bin
RUN  chmod +x /usr/bin/relay && \
     apk add -U --no-cache ca-certificates
