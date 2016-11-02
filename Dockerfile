FROM alpine:latest
RUN apk add --no-cache mysql-client

ADD ./scripts /scripts
ADD ./scaffold /scaffold

WORKDIR /scripts

VOLUME /cwd
VOLUME /data

CMD ["/bin/ash"]
