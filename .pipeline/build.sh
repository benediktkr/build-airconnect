#!/bin/bash

set -e

source ./.pipeline/airconnect.env

. ./.pipeline/init-git.sh

mkdir -pv ./bin/

find ../${AIRCONNECT_REPO_NAME}/ -name "AirConnect-*.zip" -exec unzip -d bin/ {} \;

mkdir -pv ./dist/
rm -v ./dist/*.deb || true

#docker build --pull --target builder -t airconnect:latest-builder .
#docker run -u $(id -u) --name airconnect-build --rm -it -v $(pwd)/dist/:/mnt/dist/ airconnect:latest-builder cp -r /usr/local/src/dist/. /mnt/dist/

docker build --pull -t airconnect:latest .
docker tag airconnect:latest ${DOCKER_REPO}/airconnect:latest
