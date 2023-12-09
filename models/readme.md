modelsource from hugginface:
cli:
  optimum-cli export onnx --model {model name} {export path}
example:
  optimum-cli export onnx --model google/mobilenet_v2_1.0_224 ./models/source/google/mobilenet_v2_1.0_224
    -support
  optimum-cli export onnx --model microsoft/resnet-50 ./models/source/microsoft/resnet-50
    -support
  optimum-cli export onnx --model facebook/wav2vec2-base ./models/source/facebook/wav2vec2-base
    -not support


hugginface model --------(optimum-cli)--------> onnx model --------(onnx2tf)--------> tf model--------(iree-import-tf)--------> iree_input.mlir(stablehlo)

onnx2tf:
  onnx-tf model.onnx -o output.pb

iree-import-tf:
  export MLIR_CRASH_REPRODUCER_DIRECTORY=./tmp  &&\
  iree-import-tf --tf-import-type=savedmodel_v1 --tf-savedmodel-exported-names=predict ./saved_model/ -o iree_input.mlir
  
  --tf-savedmodel-exported-names can be seen as a inference interface

test model list:
facebook/wav2vec2-base
microsoft/resnet-50
google/mobilenet_v2_1.0_224