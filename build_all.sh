#bin/bash

chmod +x riscv_bootstrap.sh && ./riscv_bootstrap.sh &&\
git clone https://github.com/openxla/iree &&\
cd iree && git submodule update --init &&\
cmake -GNinja -B ../iree-build/ \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_INSTALL_PREFIX=../iree-build/install \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
  -DIREE_CUDA_LIBDEVICE_PATH=/usr/local/cuda/nvvm/libdevice/libdevice.10.bc \
  . &&\
cmake --build ../iree-build/ --target install &&\
cmake -GNinja -B ../iree-build-riscv/ \
  -DCMAKE_TOOLCHAIN_FILE="./build_tools/cmake/riscv.toolchain.cmake" \
  -DIREE_HOST_BIN_DIR=$(realpath ../iree-build/install/bin) \
  -DRISCV_CPU=linux-riscv_64 \
  -DIREE_BUILD_COMPILER=OFF \
  -DRISCV_TOOLCHAIN_ROOT=${RISCV_TOOLCHAIN_ROOT} \
  -DIREE_ENABLE_CPUINFO=OFF \
  . &&\
cmake --build ../iree-build-riscv/