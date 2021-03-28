FROM alpine:3.13 AS base

ENV CLOJURE_VERSION=1.10.3.814

WORKDIR /tmp

RUN echo "@main http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --update --no-cache openjdk11-jdk jq zip bash curl && \
    wget https://download.clojure.org/install/linux-install-$CLOJURE_VERSION.sh && \
    chmod +x linux-install-$CLOJURE_VERSION.sh && \
    ./linux-install-$CLOJURE_VERSION.sh && \
    clojure -P

WORKDIR /usr/src/app

COPY deps.edn .

RUN clojure -P && clojure -A:depstar -P

COPY . .

ARG revision
RUN ./bin/build.sh "$revision" "/usr/lib/jvm/java-11-openjdk" "/workspace"
