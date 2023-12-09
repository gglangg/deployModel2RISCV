#!/bin/sh

input_mlir=$1

RISCV_TOOLCHAIN_ROOT=/home/cluster/riscv/toolchain/clang/linux/RISCV
QEMU_BIN=/home/cluster/riscv/qemu/linux/RISCV/qemu-riscv64
IREE_COMPILER=/home/cluster/workspace/code/env/iree-build/install/bin/iree-compile

$IREE_COMPILER --iree-torch-use-strict-symbolic-shapes --iree-hal-target-backends=vmvx $input_mlir -o $input_mlir.vmfb
echo "Source      $input_mlir"
echo "Generate    $input_mlir.vmfb"
echo "IREE compiler done"