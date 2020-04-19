FROM alpine:3.11 AS build-protoc
ENV PROTOBUF_VERSION="3.11.4"
ENV PROTOBUF_URL="https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-cpp-$PROTOBUF_VERSION.tar.gz"
RUN apk add --no-cache curl autoconf automake libtool build-base && \
    curl -L $PROTOBUF_URL | tar xvz -C /tmp && cd /tmp/protobuf-$PROTOBUF_VERSION && \
    ./autogen.sh && ./configure && make -j 4 && make check && make install

FROM golang:alpine3.11 AS build-protoc-go
RUN apk add --no-cache git && \
    go get -u github.com/golang/protobuf/protoc-gen-go && \
    go get -u github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc

FROM node:13-alpine AS build-protoc-ts
RUN npm install -g ts-protoc-gen

FROM alpine:3.11 AS build-protoc-scala
ENV SCALA_PROTOC_VERSION="0.10.2"
ENV SCALA_PROTOC_URL="https://github.com/scalapb/ScalaPB/releases/download/v$SCALA_PROTOC_VERSION/protoc-gen-scala-$SCALA_PROTOC_VERSION-linux-x86_64.zip"
RUN apk add --no-cache curl && cd /tmp && \
    curl -L $SCALA_PROTOC_URL | unzip - && chmod +x protoc-gen-scala

FROM alpine:3.11
LABEL maintainer="shoma07"
COPY --from=build-protoc /usr/local/lib/* /usr/local/lib/
COPY --from=build-protoc /usr/local/bin/* /usr/local/bin/
COPY --from=build-protoc /usr/local/include /usr/local/include
COPY --from=build-protoc-go /go/bin/* /usr/local/bin/
COPY --from=build-protoc-ts /usr/local/bin/node /usr/local/bin/protoc-gen-ts /usr/local/bin/
COPY --from=build-protoc-ts /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=build-protoc-scala /tmp/protoc-gen-scala /usr/local/bin/
RUN apk add --no-cache build-base
WORKDIR /usr/src/app

ENTRYPOINT [ \
      "protoc", \
      "--plugin=protoc-gen-ts=/usr/local/lib/node_modules/ts-protoc-gen/bin/protoc-gen-ts", \
      "--plugin=protoc-gen-scala=/usr/local/bin/protoc-gen-scala", \
      "--plugin=protoc-gen-go=/usr/local/bin/protoc-gen-go" \
    ]
