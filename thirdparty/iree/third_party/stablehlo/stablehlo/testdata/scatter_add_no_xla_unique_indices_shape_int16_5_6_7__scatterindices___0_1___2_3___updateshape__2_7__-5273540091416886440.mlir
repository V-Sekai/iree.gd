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
      %5 = stablehlo.add %arg0, %arg1 : tensor<i16>
      stablehlo.return %5 : tensor<i16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xi16>, tensor<2x2xi32>, tensor<2x7xi16>) -> tensor<5x6x7xi16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi16>, tensor<5x6x7xi16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi16>, tensor<2x7xi16>) {
    %0 = stablehlo.constant dense<"0x0600FFFFFDFFFBFF030002000100FCFF0300050000000000FEFF0000FBFF000002000000FDFFFDFF02000100FEFF000004000200FEFF02000400FFFF0000FCFFFEFFFFFFFBFFFEFFFFFFFDFFFEFF0200040001000300FEFF00000100020001000200040004000200FEFFFFFFFDFF0000FCFFFDFF0000FEFF000002000100FDFF01000400FEFF0000FEFF03000200FFFFFBFFFEFFFEFF0400FEFFFFFFFBFF0000FAFF030005000000FFFF010002000100FFFFFAFFFFFF02000000FFFF0500050008000000FCFFFFFFFFFF00000100FEFF0100FFFFFDFFFFFFFEFFFEFFFEFF0400000000000000FEFFFEFFFCFF02000000FDFF00000000FAFF0200030000000000FCFF0100FFFFFFFF0100FEFFFDFF01000000FEFFFAFFFEFF010002000100020003000300FFFF0100FDFFFDFFFFFFFEFF02000000FFFF0400FAFFF8FF0000FDFF01000000FBFFFFFFFFFF0500030000000400FCFF0100FFFFFFFF010003000100FDFFFDFF0500FFFF0000FDFF030005000100FDFF0500FEFF0100000001000000FFFF0100FCFF0600FFFF00000000FFFF0200FFFFFFFF0100000002000000020000000000"> : tensor<5x6x7xi16>
    %1 = stablehlo.constant dense<[[1, -4, -2, -2, -1, 0, 0], [1, -1, 2, 6, 2, 0, -3]]> : tensor<2x7xi16>
    return %0, %1 : tensor<5x6x7xi16>, tensor<2x7xi16>
  }
  func.func private @expected() -> tensor<5x6x7xi16> {
    %0 = stablehlo.constant dense<"0x0600FFFFFDFFFBFF030002000100FDFFFFFF0300FEFFFFFFFEFF0000FBFF000002000000FDFFFDFF02000100FEFF000004000200FEFF02000400FFFF0000FCFFFEFFFFFFFBFFFEFFFFFFFDFFFEFF0200040001000300FEFF00000100020001000200040004000200FEFFFFFFFDFF0000FCFFFDFF0000FEFF000002000100FDFF01000400FEFF0000FEFF03000200FFFFFBFFFEFFFEFF0400FEFFFFFFFBFF0000FAFF030005000000FFFF010002000100FFFFFAFFFFFF02000000FFFF0500050008000000FCFFFFFFFFFF00000100FEFF01000000FCFF010004000000FEFF0100000000000000FEFFFEFFFCFF02000000FDFF00000000FAFF0200030000000000FCFF0100FFFFFFFF0100FEFFFDFF01000000FEFFFAFFFEFF010002000100020003000300FFFF0100FDFFFDFFFFFFFEFF02000000FFFF0400FAFFF8FF0000FDFF01000000FBFFFFFFFFFF0500030000000400FCFF0100FFFFFFFF010003000100FDFFFDFF0500FFFF0000FDFF030005000100FDFF0500FEFF0100000001000000FFFF0100FCFF0600FFFF00000000FFFF0200FFFFFFFF0100000002000000020000000000"> : tensor<5x6x7xi16>
    return %0 : tensor<5x6x7xi16>
  }
}

