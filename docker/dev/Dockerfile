ARG IMAGE_NAME
FROM $IMAGE_NAME:build

RUN go get github.com/pilu/fresh

CMD dockerize -wait tcp://$DB_HOST:$DB_PORT fresh