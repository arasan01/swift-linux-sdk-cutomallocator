FROM swift:6.0.1-noble

ARG SWIFT_SDK_CHECKSUM=d4f46ba40e11e697387468e18987ee622908bc350310d8af54eb5e17c2ff5481
ARG SWIFT_SDK_URL=https://download.swift.org/swift-6.0.1-release/static-sdk/swift-6.0.1-RELEASE/swift-6.0.1-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz

ENV SWIFT_SDK_CHECKSUM=$SWIFT_SDK_CHECKSUM \
    SWIFT_SDK_URL=$SWIFT_SDK_URL

RUN set -e; \
    swift sdk install $SWIFT_SDK_URL --checksum $SWIFT_SDK_CHECKSUM
