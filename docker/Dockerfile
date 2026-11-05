FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python3 python3-pip python3-venv python3-dev \
    pkg-config curl ca-certificates git patch xz-utils unzip file \
    libssl-dev libffi-dev zlib1g-dev libxml2-dev m4 libclang-dev \
    && rm -rf /var/lib/apt/lists/*

# Mozilla 128 ESR-era Rust plus the Android target used by SpiderMonkey.
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --profile minimal --default-toolchain 1.83.0
ENV PATH=/root/.cargo/bin:$PATH
RUN rustup target add aarch64-linux-android
# cbindgen's dependency tree now uses edition2024; install it with current stable
# while keeping Rust 1.83 as the default toolchain for SpiderMonkey.
RUN rustup toolchain install stable --profile minimal
RUN cargo +stable install cbindgen

WORKDIR /port0ad
