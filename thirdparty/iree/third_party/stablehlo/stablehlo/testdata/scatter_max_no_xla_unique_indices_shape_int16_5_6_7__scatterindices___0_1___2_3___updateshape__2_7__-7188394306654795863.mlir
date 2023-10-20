// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi16>, tensor<2x7xi16>)
    %2 = call @expected() : () -> tensor<5x6x7xi16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i16>, %arg1: tensor<i16>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<i16>
      stablehlo.return %5 : tensor<i16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xi16>, tensor<2x2xi32>, tensor<2x7xi16>) -> tensor<5x6x7xi16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi16>, tensor<5x6x7xi16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi16>, tensor<2x7xi16>) {
    %0 = stablehlo.constant dense<"0x0000FDFF03000000FFFF030003000000FBFF00000100FDFF02000000FFFF01000300FEFF01000300FFFF010004000500FFFFFCFFFDFFFCFF0000FEFF0100FFFFFEFF000000000000FCFF0000020003000100030002000000FDFFFEFF0200040004000000FEFFFEFF030000000100FFFF000002000000010002000100FCFFFEFF010000000200FCFF0300000000000000FCFF0400FDFFFEFF020000000000000001000500FCFF010004000200000000000300FDFFFCFF04000100000001000000000003000000FFFFFFFFFDFFFFFFFEFF0300FAFFFDFF00000000FEFF01000000FEFFFFFFFFFF0300FDFFFEFF000004000100FBFFFEFFFDFFFFFFFDFF0000000003000200030004000000FFFFFDFFFEFF0300FCFFFEFF0200FFFF00000100010009000100000000000000FEFF0200FEFFFFFF00000000FFFF0400000001000300FBFFFFFF0200010000000200010000000000FEFF0100010006000100050000000100010002000000FEFF0000FCFF0100010000000000010002000000FFFFFFFF00000400FDFFFDFF010005000500FDFFFCFF070000000200030003000200FFFFFFFF0200"> : tensor<5x6x7xi16>
    %1 = stablehlo.constant dense<[[0, 0, 1, 1, -5, 0, -2], [-2, -5, 0, 0, 1, 0, 0]]> : tensor<2x7xi16>
    return %0, %1 : tensor<5x6x7xi16>, tensor<2x7xi16>
  }
  func.func private @expected() -> tensor<5x6x7xi16> {
    %0 = stablehlo.constant dense<"0x0000FDFF03000000FFFF030003000000000001000100FDFF02000000FFFF01000300FEFF01000300FFFF010004000500FFFFFCFFFDFFFCFF0000FEFF0100FFFFFEFF000000000000FCFF0000020003000100030002000000FDFFFEFF0200040004000000FEFFFEFF030000000100FFFF000002000000010002000100FCFFFEFF010000000200FCFF0300000000000000FCFF0400FDFFFEFF020000000000000001000500FCFF010004000200000000000300FDFFFCFF04000100000001000000000003000000FFFFFFFFFDFFFFFFFEFF0300FEFFFDFF00000000010001000000FEFFFFFFFFFF0300FDFFFEFF000004000100FBFFFEFFFDFFFFFFFDFF0000000003000200030004000000FFFFFDFFFEFF0300FCFFFEFF0200FFFF00000100010009000100000000000000FEFF0200FEFFFFFF00000000FFFF0400000001000300FBFFFFFF0200010000000200010000000000FEFF0100010006000100050000000100010002000000FEFF0000FCFF0100010000000000010002000000FFFFFFFF00000400FDFFFDFF010005000500FDFFFCFF070000000200030003000200FFFFFFFF0200"> : tensor<5x6x7xi16>
    return %0 : tensor<5x6x7xi16>
  }
}

