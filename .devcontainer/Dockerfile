FROM mcr.microsoft.com/devcontainers/cpp:3-debian13

ARG REINSTALL_CMAKE_VERSION_FROM_SOURCE="3.22.2"
ARG NODE_VERSION="24.22.2"
ARG PNPM_VERSION="11.28.5"

# This host's network blocks plain HTTP, so Debian mirrors must be reached
# over TLS. Without this, every `apt-get update` below times out.
RUN sed -i 's|URIs: http://|URIs: https://|' /etc/apt/sources.list.d/*.sources 2>/dev/null || true; \
    sed -i 's|deb http://|deb https://|' /etc/apt/sources.list 2>/dev/null || true

# Optionally install the cmake for vcpkg
COPY ./reinstall-cmake.sh /tmp/

RUN if [ "${REINSTALL_CMAKE_VERSION_FROM_SOURCE}" != "none" ]; then \
        chmod +x /tmp/reinstall-cmake.sh && /tmp/reinstall-cmake.sh ${REINSTALL_CMAKE_VERSION_FROM_SOURCE}; \
    fi \
    && rm -f /tmp/reinstall-cmake.sh

# [Optional] Uncomment this section to install additional vcpkg ports.
# RUN su vscode -c "${VCPKG_ROOT}/vcpkg install <your-port-name-here>"

# [Optional] Uncomment this section to install additional packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends python3-pybind11 pybind11-dev python3-tk python3-venv \
    zstd \
    fonts-noto-color-emoji fonts-noto-core fonts-dejavu-core fonts-noto-extra \
    ca-certificates curl xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Node.js + pnpm: the runtime DeepSeek Harness needs (engines: node >= 24.9).
# Installed from the official tarball rather than a devcontainer feature so the
# version is pinned and the layer is reproducible without a registry lookup.
RUN arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
      amd64) narch=x64 ;; \
      arm64) narch=arm64 ;; \
      *) echo "unsupported architecture: $arch" >&2; exit 1 ;; \
    esac; \
    curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${narch}.tar.xz" -o /tmp/node.tar.xz; \
    mkdir -p /usr/local/lib/nodejs; \
    tar -xJf /tmp/node.tar.xz -C /usr/local/lib/nodejs; \
    for b in node npm npx; do \
      ln -sfn "/usr/local/lib/nodejs/node-v${NODE_VERSION}-linux-${narch}/bin/$b" "/usr/local/bin/$b"; \
    done; \
    npm install -g --prefix /usr/local "pnpm@${PNPM_VERSION}"; \
    rm -f /tmp/node.tar.xz; \
    node -v; \
    pnpm -v

# ajouter installation ollama et opencode
