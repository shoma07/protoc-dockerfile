# Dockerfile of protoc command

## Build

```
$ docker build --pull --rm -t protoc .
```
## Run

```
$ docker run --rm -v $(pwd):/usr/src/app protoc \
         -I proto \
         --ruby_out=ruby \
         --js_out="import_style=commonjs,binary:typescript" \
         --ts_out=typescript \
         --scala_out=scala \
         --go_out=golang \
         --python_out=python \
         --php_out=php \
         --doc_out=doc \
         --doc_opt=markdown,README.md \
         proto/*.proto

```

## Included plugin

- [protoc-gen-ts](https://github.com/improbable-eng/ts-protoc-gen)
- [protoc-gen-go](https://pkg.go.dev/github.com/golang/protobuf/protoc-gen-go?tab=doc)
- [protoc-gen-doc](https://github.com/pseudomuto/protoc-gen-doc)
- [protoc-gen-scala](https://scalapb.github.io/scalapbc.html)
