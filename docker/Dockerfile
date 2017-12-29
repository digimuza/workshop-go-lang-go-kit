FROM alpine

ENV DOCKERIZE_VERSION v0.5.0

RUN apk add --no-cache openssl
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

ENV DB_HOST=be-keys-go-db
ENV DB_PORT=5432
ENV DB_NAME=db
ENV DB_USER=postgres
ENV DB_PASSWORD=postgres

EXPOSE 80