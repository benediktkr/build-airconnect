#!/bin/bash

set -e

source ./.pipeline/airconnect.env

docker push ${DOCKER_REPO}/airconnect:latest
