ARG IMAGE_NAME
FROM $IMAGE_NAME:base

RUN apk add --no-cache ca-certificates

ENV GOLANG_VERSION 1.9.2

RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
		bash \
		gcc \
		musl-dev \
		openssl \
		go \
	; \
	export \
# set GOROOT_BOOTSTRAP such that we can actually build Go
		GOROOT_BOOTSTRAP="$(go env GOROOT)" \
# ... and set "cross-building" related vars to the installed system's values so that we create a build targeting the proper arch
# (for example, if our build host is GOARCH=amd64, but our build env/image is GOARCH=386, our build needs GOARCH=386)
		GOOS="$(go env GOOS)" \
		GOARCH="$(go env GOARCH)" \
		GO386="$(go env GO386)" \
		GOARM="$(go env GOARM)" \
		GOHOSTOS="$(go env GOHOSTOS)" \
		GOHOSTARCH="$(go env GOHOSTARCH)" \
	; \
	\
	wget -O go.tgz "https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz"; \
	echo '665f184bf8ac89986cfd5a4460736976f60b57df6b320ad71ad4cef53bb143dc *go.tgz' | sha256sum -c -; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	\
	cd /usr/local/go/src; \
	for p in /go-alpine-patches/*.patch; do \
		[ -f "$p" ] || continue; \
		patch -p2 -i "$p"; \
	done; \
	./make.bash; \
	\
	rm -rf /go-alpine-patches; \
	apk del .build-deps; \
	\
	export PATH="/usr/local/go/bin:$PATH"; \
	go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

COPY docker/build/go-wrapper /usr/local/bin/

ENV CGO_ENABLED=0
ENV GOOS=linux

RUN apk update && apk upgrade
RUN apk add --no-cache bash git openssh

RUN go get github.com/jinzhu/gorm \
 && go get github.com/lib/pq \
 && go get github.com/gorilla/mux \
 && go get github.com/go-kit/kit/endpoint \
 && go get github.com/go-kit/kit/transport/http \ 
 && go get github.com/go-kit/kit/log \
 && go get github.com/go-kit/kit/metrics \
 && go get github.com/go-kit/kit/metrics/prometheus \
 && go get github.com/prometheus/client_golang/prometheus \
 && go get github.com/prometheus/client_golang/prometheus/promhttp

WORKDIR /platform

COPY /platform /platform

RUN go build  -ldflags '-w -s' -a -installsuffix cgo -o /bin/app