#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
current_dir=$(pwd)
if [ "$script_dir" != "$current_dir" ]; then
    echo "Error: This script must be run from its own directory."
    exit 1
fi

model_url_path="$1"

model_url_path="${model_url_path#/}"   # Removes leading slash (if any)
model_url_path="${model_url_path%/}"   # Removes trailing slash (if any)

echo "Creating model" ${model_url_path}
# Create a directory for the model
mkdir -p ./models/$model_url_path
cd ./models/$model_url_path

# Export the specified model to ONNX format using Optimum CLI
optimum-cli export onnx --model $model_url_path ./

# Convert the ONNX model to TensorFlow saved model
onnx-tf convert -i model.onnx -o ./saved_model

# Set the directory for MLIR crash reproducer files
export MLIR_CRASH_REPRODUCER_DIRECTORY=./tmp

# Import the TensorFlow saved model to MLIR format
iree-import-tf --tf-import-type=savedmodel_v1 --tf-savedmodel-exported-names=predict ./saved_model/ -o iree_input.mlir

# Compile the MLIR input to IREE VMFB format
iree-compile --iree-torch-use-strict-symbolic-shapes --iree-hal-target-backends=vmvx iree_input.mlir -o iree_input.mlir.vmfb

# Output the source and generated file paths
echo "Source:       iree_input.mlir"
echo "Generated:    iree_input.mlir.vmfb"
echo "IREE compiler process completed"
