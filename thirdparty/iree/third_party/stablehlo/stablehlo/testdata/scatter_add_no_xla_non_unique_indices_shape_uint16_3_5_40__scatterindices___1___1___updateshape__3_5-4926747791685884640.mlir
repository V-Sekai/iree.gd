// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xui16>, tensor<3x5x2xui16>)
    %2 = call @expected() : () -> tensor<3x5x40xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xui16>, tensor<2x1xi32>, tensor<3x5x2xui16>) -> tensor<3x5x40xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xui16>, tensor<3x5x40xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xui16>, tensor<3x5x2xui16>) {
    %0 = stablehlo.constant dense<"0x020001000100040001000300030005000200000001000300010001000500050000000200040000000000000002000400040000000300020000000100040000000300010004000700020006000200010000000000020007000100000000000000030000000100010005000200000000000000000002000400000002000400020004000600000004000400050001000000000002000000000000000700000005000100000002000100030001000000010000000300020001000000020001000200020000000100000000000000030005000600020004000200050002000100000003000300010000000300010003000100020002000000030000000300020001000000040003000100000003000000000001000000000001000100010005000200040000000000040000000000030001000300010000000300000004000000000000000200020002000000000001000100000000000100010000000200000003000400050005000000040003000300030001000200050004000800010001000000020000000200030000000000000004000000000003000200030006000600020005000000010001000200050003000400030001000300000002000000010000000100020003000100030005000100000003000000000000000200010000000100000002000100030001000100010000000100010002000300000000000100040000000200040004000300000002000100020000000000000000000600040000000100030000000100010004000100090002000700010001000200020002000000000003000100030007000100010003000000010002000400020002000200020000000100000001000000000000000200010000000000050001000600030001000100010001000400010001000000000003000300000001000000030000000200010000000000040002000000040001000000000002000000000000000000050003000600010000000000020001000500020000000100010002000400030006000400010000000200050004000000020001000000030004000200020001000500000000000100030004000000000002000100050001000000010001000400000000000100010000000200020002000000030000000000010000000300060003000200020001000000000001000000000005000000000001000100010002000300010004000100010006000100030001000300030000000100010003000100010003000200040004000100010000000100010001000200020000000000000002000300010000000200000006000100000000000B00020001000400000005000200000000000000040001000200000001000000000000000000000002000300010000000000010004000300000004000000020003000000010000000000040002000000020002000000030000000100000000000200050001000100020004000400000001000100010001000100040006000100000001000300040005000400000002000400030003000100050000000100030000000200030001000200000002000100020000000200000004000100010004000200000001000300000000000300000000000200020000000300000004000600010002000000060001000000010003000500000000000100050005000300"> : tensor<3x5x40xui16>
    %1 = stablehlo.constant dense<[[[2, 4], [2, 1], [5, 2], [5, 4], [3, 3]], [[0, 3], [2, 1], [1, 2], [2, 0], [3, 2]], [[3, 3], [2, 0], [0, 3], [3, 1], [1, 6]]]> : tensor<3x5x2xui16>
    return %0, %1 : tensor<3x5x40xui16>, tensor<3x5x2xui16>
  }
  func.func private @expected() -> tensor<3x5x40xui16> {
    %0 = stablehlo.constant dense<"0x02000700010004000100030003000500020000000100030001000100050005000000020004000000000000000200040004000000030002000000010004000000030001000400070002000600020001000000030002000700010000000000000003000000010001000500020000000000000000000200040000000200040002000400060000000400040005000100000000000200000000000000070000000500010007000200010003000100000001000000030002000100000002000100020002000000010000000000000003000500060002000400020005000200010000000300030001000000030001000300010002000B000000030000000300020001000000040003000100000003000000000001000000000001000100010005000200040000000000040000000000030001000300010000000300000004000000000000000800020002000000000001000100000000000100010000000200000003000400050005000000040003000300030001000200050004000800010001000000020000000200030000000000000004000000030003000200030006000600020005000000010001000200050003000400030001000300000002000000010000000100020003000100030005000100000003000000000000000200010000000100000005000100030001000100010000000100010002000300000000000100040000000200040004000300000002000100020000000000000000000600040000000100030000000100010004000100090002000A00010001000200020002000000000003000100030007000100010003000000010002000400020002000200020000000100000001000000000000000200010000000000050001000600030001000100030001000400010001000000000003000300000001000000030000000200010000000000040002000000040001000000000002000000000000000000050003000600010000000000020001000500020005000100010002000400030006000400010000000200050004000000020001000000030004000200020001000500000000000100030004000000000002000100050001000000010001000400000000000700010000000200020002000000030000000000010000000300060003000200020001000000000001000000000005000000000001000100010002000300010004000100010006000100030001000300050000000100010003000100010003000200040004000100010000000100010001000200020000000000000002000300010000000200000006000100000000000B00020001000400000005000200000003000000040001000200000001000000000000000000000002000300010000000000010004000300000004000000020003000000010000000000040002000000020002000000030000000100000000000600050001000100020004000400000001000100010001000100040006000100000001000300040005000400000002000400030003000100050000000100030000000200030001000200000002000100090000000200000004000100010004000200000001000300000000000300000000000200020000000300000004000600010002000000060001000000010003000500000000000100050005000300"> : tensor<3x5x40xui16>
    return %0 : tensor<3x5x40xui16>
  }
}
