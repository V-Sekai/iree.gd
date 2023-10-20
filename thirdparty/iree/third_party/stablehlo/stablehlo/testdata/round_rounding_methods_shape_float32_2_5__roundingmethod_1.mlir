// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<2x5xf32>
    %1 = call @expected() : () -> tensor<2x5xf32>
    %2 = stablehlo.round_nearest_even %0 : tensor<2x5xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x5xf32>, tensor<2x5xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<2x5xf32> {
    %0 = stablehlo.constant dense<[[5.000000e-01, 1.200000e+00, 1.500000e+00, 1.700000e+00, 2.500000e+00], [-5.000000e-01, -1.200000e+00, -1.500000e+00, -1.700000e+00, -2.500000e+00]]> : tensor<2x5xf32>
    return %0 : tensor<2x5xf32>
  }
  func.func private @expected() -> tensor<2x5xf32> {
    %0 = stablehlo.constant dense<[[0.000000e+00, 1.000000e+00, 2.000000e+00, 2.000000e+00, 2.000000e+00], [-0.000000e+00, -1.000000e+00, -2.000000e+00, -2.000000e+00, -2.000000e+00]]> : tensor<2x5xf32>
    return %0 : tensor<2x5xf32>
  }
}
