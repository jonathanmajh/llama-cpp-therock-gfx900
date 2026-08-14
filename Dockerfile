# Use a ROCm SDK image as the base
FROM rocm/dev-ubuntu-22.04:5.3

# Install build dependencies, including hipblas and rocblas
RUN apt-get update && apt-get install -y \
    cmake \
    git \
    build-essential \
    pkg-config \
    libstdc++-12-dev \
    hipblas \
    rocblas \
    && rm -rf /var/lib/apt/lists/*

# Set the ROCm target architecture for MI25
# gfx900 is the architecture code for Vega10 (MI25)
ENV AMDGPU_TARGETS=gfx900
ENV HIP_PATH=/opt/rocm

WORKDIR /app

# Clone llama.cpp (or copy your local source)
RUN git clone https://github.com/ggml-org/llama.cpp .

# Build with HIP support
RUN mkdir build && cd build && \
    cmake .. \
    -DGGML_HIP=ON \
    -DAMDGPU_TARGETS=${AMDGPU_TARGETS} \
    -DCMAKE_BUILD_TYPE=Release \
    && make -j$(nproc)

# Final runtime stage
FROM rocm/dev-ubuntu-22.04:5.3

# Copy the built binaries from the build stage
COPY --from=0 /app/build/bin /usr/local/bin

# Set environment variable to help the runtime detect the GPU architecture
ENV HSA_OVERRIDE_GFX_VERSION=9.0.0

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/llama-cli"]