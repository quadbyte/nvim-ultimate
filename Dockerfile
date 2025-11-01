# Neovim Ultimate Edition - Test Environment
# Multi-stage build for testing all features

FROM alpine:3.19 AS base

# Install base dependencies
RUN apk add --no-cache \
    neovim \
    git \
    nodejs \
    npm \
    ripgrep \
    fd \
    fzf \
    curl \
    wget \
    bash \
    python3 \
    py3-pip \
    go \
    lua5.4 \
    luarocks \
    make \
    gcc \
    g++ \
    musl-dev \
    cargo \
    rust

# Install additional LSP and development tools
RUN npm install -g \
    typescript \
    typescript-language-server \
    vscode-langservers-extracted \
    prettier \
    eslint \
    @tailwindcss/language-server

# Install Python tools
RUN pip3 install --break-system-packages \
    pyright \
    black \
    pylint \
    debugpy

# Create test user
RUN adduser -D -h /home/nvim nvim && \
    mkdir -p /home/nvim/.config /home/nvim/.local/share /home/nvim/.local/state

# Switch to test user
USER nvim
WORKDIR /home/nvim

# Copy Neovim configuration
COPY --chown=nvim:nvim . /home/nvim/.config/nvim/

# Set environment variables
ENV HOME=/home/nvim
ENV XDG_CONFIG_HOME=/home/nvim/.config
ENV XDG_DATA_HOME=/home/nvim/.local/share
ENV XDG_STATE_HOME=/home/nvim/.local/state
ENV TERM=xterm-256color

# Pre-install plugins (headless)
RUN nvim --headless "+Lazy! sync" +qa || true

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD nvim --version || exit 1

# Default command
CMD ["/bin/bash"]

# Testing stage
FROM base AS test

# Copy test scripts
COPY --chown=nvim:nvim tests/ /home/nvim/tests/

# Run tests on build (optional)
# RUN /home/nvim/tests/run-all-tests.sh

# Production-ready stage
FROM base AS production

# Remove test files
RUN rm -rf /home/nvim/tests

# Set default profile
ENV NVIM_PROFILE=fullstack

CMD ["nvim"]
