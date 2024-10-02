# syntax=docker/dockerfile:1.3-labs

FROM --platform=linux/amd64 ubuntu:latest AS amd64_builder

COPY build.sh mimalloc.diff /tmp

# Install OS updates
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get install -y build-essential curl cmake musl-tools \
    && /tmp/build.sh \
    && apt-get remove --purge -y build-essential cmake musl-tools \
    && apt-get autoremove --purge -y \
    && rm -r /var/lib/apt/lists/*

FROM --platform=linux/arm64 ubuntu:latest AS arm64_builder

COPY build.sh mimalloc.diff /tmp

# Install OS updates
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get install -y build-essential curl cmake musl-tools \
    && /tmp/build.sh \
    && apt-get remove --purge -y build-essential cmake musl-tools \
    && apt-get autoremove --purge -y \
    && rm -r /var/lib/apt/lists/*

FROM swift:6.0.1-noble

ARG SWIFT_SDK_CHECKSUM=d4f46ba40e11e697387468e18987ee622908bc350310d8af54eb5e17c2ff5481
ARG SWIFT_SDK_URL=https://download.swift.org/swift-6.0.1-release/static-sdk/swift-6.0.1-RELEASE/swift-6.0.1-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz

COPY --from=arm64_builder /usr/lib/libmimallocaarch64.a /usr/lib/libmimallocaarch64.a
COPY --from=amd64_builder /usr/lib/libmimallocx86_64.a /usr/lib/libmimallocx86_64.a

ENV SWIFT_SDK_CHECKSUM=$SWIFT_SDK_CHECKSUM \
    SWIFT_SDK_URL=$SWIFT_SDK_URL

RUN swift sdk install $SWIFT_SDK_URL --checksum $SWIFT_SDK_CHECKSUM

RUN <<TEOF
set -e

A_LIBC_PATH="/root/.swiftpm/swift-sdks/swift-6.0.1-RELEASE_static-linux-0.0.1.artifactbundle/swift-6.0.1-RELEASE_static-linux-0.0.1/swift-linux-musl/musl-1.2.5.sdk/aarch64/usr/lib/libc.a" \
&& {
    echo "CREATE libc.a"
    echo "ADDLIB $A_LIBC_PATH"
    echo "DELETE aligned_alloc.lo calloc.lo donate.lo free.lo libc_calloc.lo lite_malloc.lo malloc.lo malloc_usable_size.lo memalign.lo posix_memalign.lo realloc.lo reallocarray.lo valloc.lo"
    echo "ADDLIB /usr/lib/libmimallocaarch64.a"
    echo "SAVE"
} | ar -M \
&& mv libc.a $A_LIBC_PATH

X_LIBC_PATH="/root/.swiftpm/swift-sdks/swift-6.0.1-RELEASE_static-linux-0.0.1.artifactbundle/swift-6.0.1-RELEASE_static-linux-0.0.1/swift-linux-musl/musl-1.2.5.sdk/x86_64/usr/lib/libc.a" \
&& {
    echo "CREATE libc.a"
    echo "ADDLIB $X_LIBC_PATH"
    echo "DELETE aligned_alloc.lo calloc.lo donate.lo free.lo libc_calloc.lo lite_malloc.lo malloc.lo malloc_usable_size.lo memalign.lo posix_memalign.lo realloc.lo reallocarray.lo valloc.lo"
    echo "ADDLIB /usr/lib/libmimallocx86_64.a"
    echo "SAVE"
} | ar -M \
&& mv libc.a $X_LIBC_PATH

TEOF
