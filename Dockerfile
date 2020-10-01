FROM golang:1.15.2-alpine3.12 AS builder

RUN apk add --no-cache \
    git~=2.26 \
    make~=4.3

# container-structure-test default version
ARG CST_REF=v1.9.1
ENV SOURCE_PATH=/go/src/github.com/GoogleContainerTools/container-structure-test

RUN git clone \
    --depth 1 https://github.com/GoogleContainerTools/container-structure-test.git \
    --branch "$CST_REF" \
    "$SOURCE_PATH"

WORKDIR $SOURCE_PATH
# Compile code
RUN VERSION=$(git describe --tags || echo "$CST_REF-$(git describe --always)") make \
  && cp out/container-structure-test /

# Distro image
FROM alpine:3.12
COPY --from=builder /container-structure-test /bin/
ENTRYPOINT ["/bin/container-structure-test"]
