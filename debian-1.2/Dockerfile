FROM debian:bookworm-slim AS build
LABEL maintainer="hi@billgo.me"

ARG BUN_VERSION=latest

RUN apt-get update -qq \
  && apt-get install -qq --no-install-recommends \
  ca-certificates \
  curl \
  dirmngr \
  gpg \
  gpg-agent \
  unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && arch="$(dpkg --print-architecture)" \
  && case "${arch##*-}" in \
  amd64) build="x64-baseline";; \
  arm64) build="aarch64";; \
  *) echo "error: unsupported architecture: $arch"; exit 1 ;; \
  esac \
  && version="$BUN_VERSION" \
  && case "$version" in \
  latest | canary | bun-v*) tag="$version"; ;; \
  v*)                       tag="bun-$version"; ;; \
  *)                        tag="bun-v$version"; ;; \
  esac \
  && case "$tag" in \
  latest) release="latest/download"; ;; \
  *)      release="download/$tag"; ;; \
  esac \
  && curl "https://github.com/oven-sh/bun/releases/$release/bun-linux-$build.zip" \
  -fsSLO \
  --compressed \
  --retry 5 \
  || (echo "error: failed to download: $tag" && exit 1) \
  && for key in \
  "F3DCC08A8572C0749B3E18888EAB4D40A7B22B59" \
  ; do \
  gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" \
  || gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
  done \
  && curl "https://github.com/oven-sh/bun/releases/$release/SHASUMS256.txt.asc" \
  -fsSLO \
  --compressed \
  --retry 5 \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  || (echo "error: failed to verify: $tag" && exit 1) \
  && grep " bun-linux-$build.zip\$" SHASUMS256.txt | sha256sum -c - \
  || (echo "error: failed to verify: $tag" && exit 1) \
  && unzip "bun-linux-$build.zip" \
  && mv "bun-linux-$build/bun" /usr/local/bin/bun \
  && rm -f "bun-linux-$build.zip" SHASUMS256.txt.asc SHASUMS256.txt \
  && chmod +x /usr/local/bin/bun \
  && which bun \
  && bun --version

FROM debian:bookworm-slim AS builder
LABEL maintainer="hi@billgo.me"

# Disable the runtime transpiler cache by default inside Docker containers.
# On ephemeral containers, the cache is not useful
ARG BUN_RUNTIME_TRANSPILER_CACHE_PATH=0
ENV BUN_RUNTIME_TRANSPILER_CACHE_PATH=${BUN_RUNTIME_TRANSPILER_CACHE_PATH}

# Ensure `bun install -g` works
ARG BUN_INSTALL_BIN=/usr/local/bin
ENV BUN_INSTALL_BIN=${BUN_INSTALL_BIN}

COPY docker-entrypoint.sh /usr/local/bin
COPY --from=build /usr/local/bin/bun /usr/local/bin/bun
RUN mkdir -p /usr/local/bun-node-fallback-bin && ln -s /usr/local/bin/bun /usr/local/bun-node-fallback-bin/node
ENV PATH "${PATH}:/usr/local/bun-node-fallback-bin"

RUN groupadd bun \
  --gid 1000 \
  && useradd bun \
  --uid 1000 \
  --gid bun \
  --shell /bin/sh \
  --create-home \
  && ln -s /usr/local/bin/bun /usr/local/bin/bunx \
  && which bun \
  && which bunx \
  && bun --version

WORKDIR /home/bun/app
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/local/bin/bun"]

FROM nethost/debian:12 AS latest
LABEL maintainer="hi@billgo.me"

# Disable the runtime transpiler cache by default inside Docker containers.
# On ephemeral containers, the cache is not useful
ARG BUN_RUNTIME_TRANSPILER_CACHE_PATH=0
ENV BUN_RUNTIME_TRANSPILER_CACHE_PATH=${BUN_RUNTIME_TRANSPILER_CACHE_PATH}

# Ensure `bun install -g` works
ARG BUN_INSTALL_BIN=/usr/local/bin
ENV BUN_INSTALL_BIN=${BUN_INSTALL_BIN}

COPY --from=build /usr/local/bin/bun /usr/local/bin/
ENV PATH="${PATH}:/usr/local/bun-node-fallback-bin"

# Temporarily use the `build`-stage image binaries to create a symlink:
RUN --mount=type=bind,from=build,source=/usr/bin,target=/usr/bin \
  --mount=type=bind,from=build,source=/bin,target=/bin \
  --mount=type=bind,from=build,source=/usr/lib,target=/usr/lib \
  --mount=type=bind,from=build,source=/lib,target=/lib \
  <<EOF
  ln -s /usr/local/bin/bun /usr/local/bin/bunx
  which bunx
  mkdir -p /usr/local/bun-node-fallback-bin
  ln -s /usr/local/bin/bun /usr/local/bun-node-fallback-bin/nodebun
EOF

ENTRYPOINT ["/usr/local/bin/bun"]