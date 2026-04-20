#!/usr/bin/env bash

# Builds the Docker image for the pflex mock server.
# NOT USED IN CI, for local development only.

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

USE_ECR=false

for arg in "$@"; do
    if [ "$arg" = "--ecr" ]; then
        USE_ECR=true
        break
    fi
done

IMAGE_NAME="pflex-module-rs"
ECR_REGISTRY="401732561735.dkr.ecr.eu-west-1.amazonaws.com"

if [ "$USE_ECR" = true ]; then
    FULL_IMAGE_NAME="${ECR_REGISTRY}/${IMAGE_NAME}"
else
    FULL_IMAGE_NAME="${IMAGE_NAME}"
fi

RUST_VERSION="$(grep rust "${SCRIPT_DIR}/../.tool-versions" | cut -d ' ' -f 2)"
IMAGE_VERSION=${IMAGE_TAG:-${CIRCLE_TAG:-$(git rev-parse --short HEAD)}}

echo "Building ${FULL_IMAGE_NAME}:${IMAGE_VERSION} with Rust ${RUST_VERSION}"

docker build \
    --file "${SCRIPT_DIR}/Dockerfile" \
    --build-arg RUST_VERSION="${RUST_VERSION}" \
    --target=final \
    --tag "${FULL_IMAGE_NAME}:${IMAGE_VERSION}" \
    --tag "${FULL_IMAGE_NAME}:latest" \
    "${SCRIPT_DIR}/.."
