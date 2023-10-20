// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<f32>, tensor<2x3xf32>)
    %1 = call @expected() : () -> tensor<2x3xi1>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [] : (tensor<f32>) -> tensor<2x3xf32>
    %3 = stablehlo.compare  EQ, %2, %0#1,  FLOAT : (tensor<2x3xf32>, tensor<2x3xf32>) -> tensor<2x3xi1>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<2x3xi1>, tensor<2x3xi1>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<f32>, tensor<2x3xf32>) {
    %0 = stablehlo.constant dense<[[0.543892622, -0.410562366, -4.815970e+00], [4.38091516, -5.92743587, -3.34699702]]> : tensor<2x3xf32>
    %1 = stablehlo.constant dense<1.38322711> : tensor<f32>
    return %1, %0 : tensor<f32>, tensor<2x3xf32>
  }
  func.func private @expected() -> tensor<2x3xi1> {
    %0 = stablehlo.constant dense<false> : tensor<2x3xi1>
    return %0 : tensor<2x3xi1>
  }
}
