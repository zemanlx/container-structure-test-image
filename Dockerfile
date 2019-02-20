FROM golang:1.11.5-alpine3.9 AS builder

RUN apk add --no-cache \
    gcc~=8.2 \
    git~=2.20 \
    make~=4.2 \
    musl-dev~=1.1 \
  && go get github.com/golang/dep/cmd/dep

# container-structure-test default version
ARG CST_REF=v1.8.0
ENV SOURCE_PATH=/go/src/github.com/GoogleContainerTools/container-structure-test

RUN git clone \
    --depth 1 https://github.com/GoogleContainerTools/container-structure-test.git \
    --branch "$CST_REF" \
    "$SOURCE_PATH"

WORKDIR $SOURCE_PATH
# Download dependencies
RUN dep ensure
# Compile code
RUN VERSION=$(git describe --tags || echo "$CST_REF-$(git describe --always)") make \
  && cp out/container-structure-test /

# Distro image
FROM alpine:3.9
COPY --from=builder /container-structure-test /bin/
ENTRYPOINT ["/bin/container-structure-test"]
