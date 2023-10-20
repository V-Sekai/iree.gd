// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<2x3xui8>
    %1 = call @expected() : () -> tensor<3xui8>
    %2 = stablehlo.constant dense<0> : tensor<ui8>
    %3 = stablehlo.reduce(%0 init: %2) across dimensions = [0] : (tensor<2x3xui8>, tensor<ui8>) -> tensor<3xui8>
     reducer(%arg0: tensor<ui8>, %arg1: tensor<ui8>)  {
      %5 = stablehlo.add %arg0, %arg1 : tensor<ui8>
      stablehlo.return %5 : tensor<ui8>
    }
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<3xui8>, tensor<3xui8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<2x3xui8> {
    %0 = stablehlo.constant dense<[[0, 1, 1], [3, 2, 1]]> : tensor<2x3xui8>
    return %0 : tensor<2x3xui8>
  }
  func.func private @expected() -> tensor<3xui8> {
    %0 = stablehlo.constant dense<[3, 3, 2]> : tensor<3xui8>
    return %0 : tensor<3xui8>
  }
}
