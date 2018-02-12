# Container Structure Tests - Alpine Docker Image

This repository offers `Dockerfile` and instructions for building container based on Alpine Linux that contains [container-structure-test](https://github.com/GoogleCloudPlatform/container-structure-test) binary.

For your convenience, you can use automatic build from Docker Hub [zemanlx/container-structure-test](https://hub.docker.com/r/zemanlx/container-structure-test) tags:
- `v0.2.0-alpine`

## Use image from Docker Hub

An image can be used the same way as an original Google's one.

Pull image

```bash
docker pull zemanlx/container-structure-test:v0.2.0-alpine
```

Run your tests, that you mount alongside with `docker.sock` eg.

```bash
docker run -i --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ${PWD}:/test zemanlx/container-structure-test:v0.2.0-alpine \
    -test.v \
    -image zemanlx/container-structure-test:v0.2.0-alpine \
    /test/structure-tests.yaml
```

## Build image

Tagged commit of source code is downloaded during image build.

```bash
CST_REF=v0.2.0
docker build \
  --build-arg CST_REF=${CST_REF} \
  --tag container-structure-test:${CST_REF}-alpine \
  .
```

After a successful build, you should have `container-structure-test:v0.2.0-alpine` image.

If you need to use different tag or branch, set `CST_REF` to a different value.

To get latest `master` branch build run

```bash
CST_REF=master
docker build \
  --build-arg CST_REF=${CST_REF} \
  --tag container-structure-test:${CST_REF}-alpine \
  .
```
