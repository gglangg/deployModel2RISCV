func.func @abs(%input : tensor<f32>) -> (tensor<f32>) {
  %result = math.absf %input : tensor<f32>
  return %result : tensor<f32>
}

func.func @foo(%input : tensor<1x2x2xi32>) -> (tensor<1x2x2xi32>) {
  %1 = stablehlo.constant dense<0x00000010> : tensor<1x2x2xi32>
  %0 = stablehlo.add %input, %input : (tensor<1x2x2xi32>, tensor<1x2x2xi32>) -> tensor<1x2x2xi32>
  %result = stablehlo.add %0, %1 : (tensor<1x2x2xi32>, tensor<1x2x2xi32>) -> tensor<1x2x2xi32>

  return %result : tensor<1x2x2xi32>
}




@tf.function(jit_compile=True)
def recompiled_on_launch(a, b):
  return a + b

import iree.compiler.tools

SIMPLE_MUL_ASM = """
func.func @simple_mul(%arg0: tensor<4xf32>, %arg1: tensor<4xf32>) -> tensor<4xf32> {
    %0 = "tosa.mul"(%arg0, %arg1) {shift = 0 : i32} : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
    return %0 : tensor<4xf32>
}
"""

binary = iree.compiler.tools.compile_str(
    SIMPLE_MUL_ASM, input_type="tosa", target_backends=["llvm-cpu"])