#!/bin/bash

set -e

source ./.pipeline/airconnect.env

set -x
find ./airconnect-bin/ -type f -not -name ".gitkeep" -delete
