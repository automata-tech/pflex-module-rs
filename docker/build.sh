#!/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SHORT_SHA=$(git rev-parse --short HEAD)
# Use the git tag if it exists, otherwise use the short SHA
# CIRCLE_TAG is set by CircleCI when a tag is pushed and a pipeline runs on that tag
VERSION=${CIRCLE_TAG:-${SHORT_SHA:-'0.0.0'}}
POETRY_HTTP_BASIC_AUTOMATA_PASSWORD=$("${SCRIPT_DIR}/../codeartifact-login/get-password.sh") \
docker build \
    --file "${SCRIPT_DIR}/Dockerfile" \
    --build-arg PYTHON_VERSION="$(cat ${SCRIPT_DIR}/../.python-version)" \
    --build-arg POETRY_VERSION="$(cat ${SCRIPT_DIR}/../.tool-versions | grep poetry | cut -d ' ' -f 2)" \
    --build-arg VERSION="${VERSION}" \
    --secret id=POETRY_HTTP_BASIC_AUTOMATA_PASSWORD \
    --target=final \
    --tag "mock-robot:${VERSION}" \
    --tag "mock-robot:latest" \
    .
