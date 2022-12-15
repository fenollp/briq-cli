# syntax=docker.io/docker/dockerfile:1@sha256:9ba7531bd80fb0a858632727cf7a112fbfd19b17e94c4e84ced81e24ef1a0dbc

# Fetched on 2022/11/14
FROM --platform=$BUILDPLATFORM docker.io/library/golang:1-alpine@sha256:dc4f4756a4fb91b6f496a958e11e00c0621130c8dfbb31ac0737b0229ad6ad9c AS golang
# On this image:
#  go env GOCACHE    => /root/.cache/go-build
#  go env GOMODCACHE => /go/pkg/mod


FROM golang AS base
WORKDIR /w
ENV CGO_ENABLED=0
COPY go.??? .
RUN \
  --mount=type=cache,target=/go/pkg/mod \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=type=cache,target=/var/cache/apk ln -vs /var/cache/apk /etc/apk/cache && \
    set -ux \
 && go mod download
COPY . .
RUN \
  --mount=type=cache,target=/go/pkg/mod \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=type=cache,target=/var/cache/apk ln -vs /var/cache/apk /etc/apk/cache && \
    set -ux \
 && go build .

FROM scratch
COPY --from=base /w/briq-cli /
