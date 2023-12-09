#!/bin/sh

input_vmfb=$1
input_function_name=$2
input_function_args=$3


IREE_BUILD_RISCV=/home/cluster/workspace/code/env/iree-build-riscv/tools/iree-run-module
RISCV_TOOLCHAIN_ROOT=/home/cluster/riscv/toolchain/clang/linux/RISCV
QEMU_BIN=/home/cluster/riscv/qemu/linux/RISCV/qemu-riscv64

$QEMU_BIN -cpu rv64  \
  -L $RISCV_TOOLCHAIN_ROOT/sysroot/ \
  $IREE_BUILD_RISCV \
  --device=local-task \
  --module=$input_vmfb \
  --function=$input_function_name \
  --input=$input_function_args
# --input="1x224x224x3xf32=0" 
# --input=f32=-5