// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<3xf32>, tensor<1xui32>)
    %1 = call @expected() : () -> tensor<1xf32>
    %2 = "stablehlo.slice"(%0#1) {limit_indices = dense<1> : tensor<1xi64>, start_indices = dense<0> : tensor<1xi64>, strides = dense<1> : tensor<1xi64>} : (tensor<1xui32>) -> tensor<1xui32>
    %3 = stablehlo.reshape %2 : (tensor<1xui32>) -> tensor<ui32>
    %4 = stablehlo.constant dense<0> : tensor<ui32>
    %5 = stablehlo.compare  LT, %3, %4,  UNSIGNED : (tensor<ui32>, tensor<ui32>) -> tensor<i1>
    %6 = stablehlo.constant dense<3> : tensor<ui32>
    %7 = stablehlo.add %3, %6 : tensor<ui32>
    %8 = stablehlo.select %5, %7, %3 : tensor<i1>, tensor<ui32>
    %9 = stablehlo.dynamic_slice %0#0, %8, sizes = [1] : (tensor<3xf32>, tensor<ui32>) -> tensor<1xf32>
    %10 = stablehlo.custom_call @check.eq(%9, %1) : (tensor<1xf32>, tensor<1xf32>) -> tensor<i1>
    return %10 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3xf32>, tensor<1xui32>) {
    %0 = stablehlo.constant dense<[-0.388208777, 3.26010466, 5.85117722]> : tensor<3xf32>
    %1 = stablehlo.constant dense<1> : tensor<1xui32>
    return %0, %1 : tensor<3xf32>, tensor<1xui32>
  }
  func.func private @expected() -> tensor<1xf32> {
    %0 = stablehlo.constant dense<3.26010466> : tensor<1xf32>
    return %0 : tensor<1xf32>
  }
}