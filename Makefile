all: mimalloc-build-push basic-build-push

.PHONY: all setup mimalloc-build-push basic-build-push

mimalloc-build-push:
	docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/arasan01/swift:6.0.1-noble-musl-mimalloc-linux-sdk --push 6.0.1/mimalloc

basic-build-push:
	docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/arasan01/swift:6.0.1-noble-musl-basic-linux-sdk --push 6.0.1/basic

setup:
	docker buildx create --name multiarch-builder --driver docker-container --use
	docker buildx inspect --bootstrap
