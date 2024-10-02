#!/bin/sh

# ref: https://github.com/tweag/rust-alpine-mimalloc/blob/b26002b49d466a295ea8b50828cb7520a71a872a/build.sh

set -eu

MIMALLOC_VERSION=2.1.7

cd /tmp

curl -f -L --retry 5 https://github.com/microsoft/mimalloc/archive/refs/tags/v$MIMALLOC_VERSION.tar.gz | tar xz --strip-components=1

patch -p1 < mimalloc.diff

arch=$(uname -m)

cmake \
    -Bout \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=$(arch)-linux-musl-gcc \
    -DMI_BUILD_SHARED=OFF \
    -DMI_BUILD_OBJECT=OFF \
    -DMI_BUILD_TESTS=OFF \
    .

cmake --build "out"

mv out/libmimalloc.a /usr/lib/libmimalloc$(arch).a

rm -rf /tmp/*
