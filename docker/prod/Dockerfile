ARG IMAGE_NAME
FROM $IMAGE_NAME:build AS builder
FROM $IMAGE_NAME:base

COPY --from=builder /bin/app /bin/

CMD dockerize -wait tcp://${DB_HOST}:${DB_PORT} /bin/app
