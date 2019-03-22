#!/usr/bin/env bash

MODE="$1"
IMAGE="$2"
VARIANT="$3"
VERSION="$4"
SHA512="$5"

cd $VARIANT
tag="$VARIANT"

if [ "$MODE" = 'build' ]; then
    echo -e "\nBuilding $IMAGE:$VERSION-$tag..."
    docker pull $IMAGE:$VERSION-$tag || true
    docker build --pull --cache-from $IMAGE:$VERSION-$tag -t $IMAGE:$VERSION-$tag --build-arg SWARM_VERSION=$VERSION --build-arg SWARM_SHA=$SHA512 .
fi
if [ "$MODE" = "deploy" ]; then
    echo -e '\nDeploying...'
    dcd --version $VERSION --version-semver --tag $tag --verbose $IMAGE:$VERSION-$tag
fi
