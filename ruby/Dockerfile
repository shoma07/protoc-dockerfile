FROM ruby:2.7.1-alpine
ENV PROTOBUF_VERSION="3.11.4"
RUN gem install google-protobuf -v $PROTOBUF_VERSION && \
    cd /usr/local/bundle/gems/google-protobuf-$PROTOBUF_VERSION-x86_64-linux/lib/google && ln -s 2.6 2.7
WORKDIR /usr/src/app
