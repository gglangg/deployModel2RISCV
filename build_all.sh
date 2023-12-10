#!/bin/bash

set -e

# IREE github repo
IREE_GIT_REPO="https://github.com/openxla/iree"

if [ -z "${RISCV_TOOLCHAIN_ROOT}" ]; then
    echo "RISCV_TOOLCHAIN_ROOT is not set. Please set it to your RISC-V toolchain path."
    exit 1
fi

# install riscv-toolchain & qemu
chmod +x riscv_bootstrap.sh
./riscv_bootstrap.sh

git clone ${IREE_GIT_REPO}
cd iree
git submodule update --init

# CMAKE option
COMMON_CMAKE_OPTIONS="-GNinja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"

# option DCMAKE_BUILD_WITH_INSTALL_RPATH=ON is required in docker, otherwise remove it
cmake ${COMMON_CMAKE_OPTIONS} -B ../iree-build/ \
      -DCMAKE_INSTALL_PREFIX=../iree-build/install \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
      -DIREE_CUDA_LIBDEVICE_PATH=/usr/local/cuda/nvvm/libdevice/libdevice.10.bc \
      .
cmake --build ../iree-build/ --target install

export RISCV_TOOLCHAIN_ROOT=/usr/workspace/deployModel2RISCV/riscv/toolchain/clang/linux/RISCV

cmake ${COMMON_CMAKE_OPTIONS} -B ../iree-build-riscv/ \
      -DCMAKE_TOOLCHAIN_FILE="./build_tools/cmake/riscv.toolchain.cmake" \
      -DIREE_HOST_BIN_DIR=$(realpath ../iree-build/install/bin) \
      -DRISCV_CPU=linux-riscv_64 \
      -DIREE_BUILD_COMPILER=OFF \
      -DRISCV_TOOLCHAIN_ROOT=${RISCV_TOOLCHAIN_ROOT} \
      -DIREE_ENABLE_CPUINFO=OFF \
      .
cmake --build ../iree-build-riscv

cp -r ../iree-build/install/bin/* /bin
cp -r ../iree-build/install/lib/* /lib

# python package
python -m pip install optimum
pip install tensorflow==2.15 onnx-tf=1.10 tensorflow_probability==0.23 iree-tools-tf