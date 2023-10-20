// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<1xf16>, tensor<2xf16>)
    %2 = call @expected() : () -> tensor<1xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<inserted_window_dims = [0], scatter_dims_to_operand_dims = [0], index_vector_dim = 1>} : (tensor<1xf16>, tensor<2x1xi32>, tensor<2xf16>) -> tensor<1xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1xf16>, tensor<1xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1xf16>, tensor<2xf16>) {
    %0 = stablehlo.constant dense<-3.472660e+00> : tensor<1xf16>
    %1 = stablehlo.constant dense<[-5.355470e+00, 3.744140e+00]> : tensor<2xf16>
    return %0, %1 : tensor<1xf16>, tensor<2xf16>
  }
  func.func private @expected() -> tensor<1xf16> {
    %0 = stablehlo.constant dense<6.962500e+01> : tensor<1xf16>
    return %0 : tensor<1xf16>
  }
}

