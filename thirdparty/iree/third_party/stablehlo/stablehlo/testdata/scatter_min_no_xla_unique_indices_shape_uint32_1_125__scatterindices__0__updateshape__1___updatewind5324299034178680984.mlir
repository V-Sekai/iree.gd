// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x125xui32>, tensor<1xui32>)
    %2 = call @expected() : () -> tensor<1x125xui32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui32>, %arg1: tensor<ui32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<ui32>
      stablehlo.return %5 : tensor<ui32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xui32>, tensor<1xi32>, tensor<1xui32>) -> tensor<1x125xui32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xui32>, tensor<1x125xui32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xui32>, tensor<1xui32>) {
    %0 = stablehlo.constant dense<"0x0300000003000000000000000100000002000000040000000200000000000000050000000000000001000000020000000100000003000000030000000500000005000000000000000200000000000000020000000000000001000000010000000000000000000000000000000200000000000000020000000000000001000000000000000100000005000000020000000100000002000000010000000000000000000000040000000000000003000000050000000100000000000000060000000200000000000000010000000100000000000000000000000000000001000000040000000100000000000000000000000300000003000000010000000000000000000000030000000A00000005000000000000000000000004000000000000000200000003000000020000000100000002000000020000000100000003000000000000000000000007000000030000000400000003000000000000000300000000000000000000000000000001000000000000000100000002000000010000000300000003000000050000000000000005000000010000000000000004000000000000000400000000000000030000000000000001000000010000000300000000000000020000000100000000000000000000000200000002000000050000000200000004000000000000000500000002000000"> : tensor<1x125xui32>
    %1 = stablehlo.constant dense<4> : tensor<1xui32>
    return %0, %1 : tensor<1x125xui32>, tensor<1xui32>
  }
  func.func private @expected() -> tensor<1x125xui32> {
    %0 = stablehlo.constant dense<"0x0300000003000000000000000100000002000000040000000200000000000000050000000000000001000000020000000100000003000000030000000500000005000000000000000200000000000000020000000000000001000000010000000000000000000000000000000200000000000000020000000000000001000000000000000100000005000000020000000100000002000000010000000000000000000000040000000000000003000000050000000100000000000000060000000200000000000000010000000100000000000000000000000000000001000000040000000100000000000000000000000300000003000000010000000000000000000000030000000A00000005000000000000000000000004000000000000000200000003000000020000000100000002000000020000000100000003000000000000000000000007000000030000000400000003000000000000000300000000000000000000000000000001000000000000000100000002000000010000000300000003000000050000000000000005000000010000000000000004000000000000000400000000000000030000000000000001000000010000000300000000000000020000000100000000000000000000000200000002000000050000000200000004000000000000000500000002000000"> : tensor<1x125xui32>
    return %0 : tensor<1x125xui32>
  }
}
