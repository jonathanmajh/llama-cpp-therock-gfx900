# -------------------------------------------------------------
# Builder stage
# -------------------------------------------------------------
FROM ubuntu:26.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

# Install core build dependencies (added curl)
RUN apt-get update && apt-get install -y \
    cmake \
    git \
    build-essential \
    wget \
    curl \
    libcurl4-openssl-dev \
    pkg-config \
    libnuma-dev \
    && rm -rf /var/lib/apt/lists/*

# Dynamically fetch the latest nightly tarball and extract it
RUN mkdir -p /tmp/rocm_tar /opt/rocm && \
    # Scrape the directory for the latest non-test gfx900 tarball
    LATEST_TARBALL=$(curl -sL https://rocm.nightlies.amd.com/tarball-multi-arch/ | \
      grep -Eo 'therock-dist-linux-gfx900-[0-9a-z.]+\.tar\.gz' | \
      grep -v 'tests' | \
      sort -V | tail -n 1) && \
    echo "Downloading latest ROCm tarball: ${LATEST_TARBALL}" && \
    wget -qO /tmp/rocm.tar.gz "https://rocm.nightlies.amd.com/tarball-multi-arch/${LATEST_TARBALL}" && \
    # Extract
    tar -xzf /tmp/rocm.tar.gz -C /tmp/rocm_tar && \
    # Flatten the extraction based on the internal folder structure of the day
    if [ -d "/tmp/rocm_tar/install" ]; then \
        mv /tmp/rocm_tar/install/* /opt/rocm/ ; \
    elif [ $(ls -1q /tmp/rocm_tar | wc -l) -eq 1 ]; then \
        mv /tmp/rocm_tar/*/* /opt/rocm/ ; \
    else \
        mv /tmp/rocm_tar/* /opt/rocm/ ; \
    fi && \
    # Cleanup
    rm -rf /tmp/rocm*

ENV HIP_PATH=/opt/rocm
ENV PATH=/opt/rocm/bin:$PATH
ENV AMDGPU_TARGETS=gfx900

WORKDIR /app
RUN git clone https://github.com/ggerganov/llama.cpp .

# Build and install llama.cpp to /app/install
RUN mkdir build && cd build && \
    cmake .. \
    -DGGML_HIP=ON \
    -DAMDGPU_TARGETS=${AMDGPU_TARGETS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/app/install \
    && cmake --build . --config Release -j$(nproc) \
    && cmake --install .

# -------------------------------------------------------------
# Final runtime stage
# -------------------------------------------------------------
FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required runtime dependencies for the HIP environment
RUN apt-get update && apt-get install -y \
    ca-certificates \
    libnuma1 \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Copy the entire ROCm SDK from the builder
COPY --from=builder /opt/rocm /opt/rocm

# Copy the installed llama.cpp binaries and shared libraries
COPY --from=builder /app/install /usr/local

# Tell the OS dynamic linker where to find ROCm and llama.cpp libraries
RUN echo "/opt/rocm/lib" > /etc/ld.so.conf.d/rocm.conf && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf && \
    ldconfig

ENV PATH=/opt/rocm/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/rocm/lib:/usr/local/lib
ENV HSA_OVERRIDE_GFX_VERSION=9.0.0

ENTRYPOINT ["/usr/local/bin/llama-cli"]
