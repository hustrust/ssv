#
# STEP 1: Prepare environment
#
FROM golang:1.24@sha256:8b788ecf5fddb91cd04e532205d6411de68a08b510885bb8fb1c93f54c03f737 AS preparer

RUN apt-get update && apt upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  make curl git zip unzip wget dnsutils g++ gcc-aarch64-linux-gnu                 \
  && rm -rf /var/lib/apt/lists/*

RUN go version
ENV GO111MODULE=on
RUN go get github.com/go-delve/delve/cmd/dlv
RUN go get -u github.com/cosmtrek/air@v1.27.8

WORKDIR /go/src/github.com/ssvlabs/ssv/
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

CMD air
