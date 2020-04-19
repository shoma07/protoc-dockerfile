FROM node:13-alpine

WORKDIR /usr/src/app
RUN yarn add typescript ts-node google-protobuf @types/google-protobuf && \
    npx tsc --init

ENTRYPOINT ["npx", "ts-node"]

