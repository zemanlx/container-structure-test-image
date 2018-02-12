FROM golang:1.9.4-alpine3.7 AS builder

RUN apk add --no-cache \
      gcc=6.4.0-r5 \
      git=2.15.0-r1 \
      musl-dev=1.1.18-r3 \
    && go get github.com/golang/dep/cmd/dep

# container-structure-test default version
ARG CST_REF=v0.2.0
ENV SOURCE_PATH=/go/src/github.com/GoogleCloudPlatform/container-structure-test

RUN git clone \
    --depth 1 https://github.com/GoogleCloudPlatform/container-structure-test.git \
    --branch "$CST_REF" \
    "$SOURCE_PATH"

WORKDIR $SOURCE_PATH
# Download dependencies
RUN dep ensure
# Compile code
RUN go test -c . -o /container-structure-test

# Distro image
FROM alpine:3.7
COPY --from=builder /container-structure-test /usr/local/bin
ENTRYPOINT ["/usr/local/bin/container-structure-test"]
