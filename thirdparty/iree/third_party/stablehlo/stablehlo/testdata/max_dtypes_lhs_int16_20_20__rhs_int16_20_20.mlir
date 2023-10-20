// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi16>, tensor<20x20xi16>)
    %1 = call @expected() : () -> tensor<20x20xi16>
    %2 = stablehlo.maximum %0#0, %0#1 : tensor<20x20xi16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi16>, tensor<20x20xi16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi16>, tensor<20x20xi16>) {
    %0 = stablehlo.constant dense<"0x0000FEFF0000FEFF0000010007000000FFFF0000FEFF02000000FFFF0000020000000100000001000400FEFF0600FFFFFFFF0300FAFF00000600FCFF0200FBFFFFFF04000000FCFF0500FCFF050001000200FCFF0100FFFF000000000000FCFFFEFF0100FCFF0000FFFF02000100FBFF000000000100FEFFFDFFFCFFFBFFFDFF0300FDFF00000000FFFF01000100F9FFFEFFFFFF000001000400040001000000000002000200FEFFFEFFFDFFFDFF0000000001000000000004000200030000000100FFFFFDFF00000500FFFF040001000200FEFF040001000000FDFF000000000600FCFFFFFF010000000200010004000000FDFF0100010000000000020004000200000004000300FEFFFEFFFDFFFFFFFEFF0000FEFFFDFF01000300FEFFFDFFFFFFFEFFFEFF000000000200FFFFFEFF0500FCFFFFFF0100F9FFFBFF03000000040000000000FBFF0200000000000100FDFF0000FEFF000000000300FEFF000000000000FFFFFFFFFCFF040003000100FEFFFFFF00000000FEFF0300FEFFFFFFFFFF0000FFFF0400FCFFFFFF0300FFFFFCFFFCFF010002000000FEFF020000000200000001000000000002000300020005000000FFFF00000100FDFFF9FF0000FFFF010002000000FEFFFFFF000003000000000002000000F9FF0000FEFF0200FEFF0500000003000300000000000200050004000000010000000300FAFF0000FEFF0000FCFF070000000100050000000200FEFF050002000500FDFFFDFFFBFFFFFF04000000FEFFFFFFFFFF07000100FEFF0100FDFFFFFF050002000000FAFF0000FCFF03000200FFFF0400FBFF0000FEFF0100FDFF010007000100FEFFFCFF07000100FFFFFFFF04000000FEFF0100FFFF02000100FFFFFDFF0000030002000100060001000400000002000700FBFF00000200FFFFFDFFFFFFFEFFFDFF010005000000FEFF01000200030003000100FDFF01000300FEFF0300010001000300FEFFFEFFFFFF0300FFFF04000000FCFF0200FCFF050000000200000002000000F9FF0000000004000200FFFF01000100000004000400010000000000020003000000010004000300FBFFFEFFFDFF04000000010000000000FFFFFEFF0100FEFF"> : tensor<20x20xi16>
    %1 = stablehlo.constant dense<"0xFFFF03000000FFFF01000000FFFF02000000000001000400FEFFFCFF010001000200FDFF0100FCFF0000FEFF0200FFFFFDFF020003000300020003000000FCFFFFFF0600FBFF0200FFFF0400FEFFFEFFFDFFFFFF02000200FFFF02000400FFFF00000500FFFFFFFF0000FFFF01000000000002000100FEFFFEFF0200000000000100FEFFFFFFFFFF0000FEFFFEFFFFFF0000010000000100FFFFFEFF07000500FFFF0000FFFF0000FCFF0300FDFFFEFFFFFFFCFFFDFFFEFF03000000FEFFFEFF0000FEFFFFFF02000100030000000000FFFF00000200FEFFFCFF0200FFFFFCFFFFFFFCFFFCFFFEFF0100FEFF0400030000000000010008000200FEFF02000300FCFFFFFF01000300000006000000FBFF020002000400010003000000FDFF03000000FEFF030000000000FCFF0000050000000000FDFF00000000040000000200000002000100FBFF0000F9FF0300FEFFFEFFFCFFFEFF04000000FFFF00000000FDFF0300030000000000FAFF0000FDFFFDFFFEFF0100FEFF0400FEFF0000000006000000020000000100FEFF02000000070002000300FDFF0000FEFFFFFFFFFFFEFFFDFFFCFF0000FAFF0100000000000000FFFFFFFF04000100FFFF00000000FCFFFAFF0500FFFF0300F9FFFFFF00000100FCFF0300FEFFFEFFFFFF0000FDFF02000000000000000100FEFFFEFF0700FDFF0100FBFF010006000000FEFFFFFF0000FCFF0300FBFF03000000FCFF000000000300FCFF0000040000000600FBFF030000000200FEFFFEFFFEFF00000600FCFFFFFF00000300FDFF010001000100FDFFFDFF030000000100030001000200040001000100FAFF0000FBFF000002000200FCFF00000300F8FFFEFF0100F9FFFEFF07000200FAFF0500FDFF0000000000000400FCFFFFFF0000030004000300FFFF01000000FCFF01000000FDFF060001000700FFFF020002000000FFFF0400FCFF0000F9FF0200FFFFFEFF00000200FBFF04000200FCFF0000FCFFFBFFFEFF01000100FFFFFEFF030004000000FFFF01000000FEFF0000FEFFFCFF01000000FFFFFFFF010000000000000000000000FFFF0300FFFFFDFFFFFF01000300FFFFFFFF0000FCFF00000000FBFF03000000"> : tensor<20x20xi16>
    return %0, %1 : tensor<20x20xi16>, tensor<20x20xi16>
  }
  func.func private @expected() -> tensor<20x20xi16> {
    %0 = stablehlo.constant dense<"0x000003000000FFFF010001000700020000000000010004000000FFFF0100020002000100010001000400FEFF0600FFFFFFFF030003000300060003000200FCFFFFFF06000000020005000400050001000200FFFF02000200000002000400FFFF00000500FFFF00000000020001000000000002000100FEFFFEFF0200000000000300FEFF00000000000001000100FFFF000001000000010004000400070005000000020002000000FEFF0300FDFF0000000001000000000004000200030000000100FFFFFFFF02000500030004000100020000000400010000000200000000000600FCFFFFFF01000100020004000400000000000100080002000000020004000200000004000300000006000000FFFF020002000400010003000300FEFF03000000FEFF03000000000002000000050005000000FFFF01000000040003000200040002000100FBFF0200000003000100FEFF0000FEFF0400000003000000000000000300030000000000040003000100FEFFFFFF01000000040003000000000006000000020004000100FFFF0300000007000200030002000000FEFF020000000200000001000000000002000300020005000000FFFF04000100FFFF00000000FFFF0100050000000300FFFF000003000100000003000000FEFF00000000020002000500000003000300000000000700050004000000010006000300FEFF0000000000000300070003000100050000000200030005000200050000000600FBFF030004000200FEFFFFFFFFFF07000600FEFF01000000030005000200010001000000FDFF0300020001000400010002000400010001000100070001000000020007000100000003000400000001000100FFFF07000200FFFF050000000300020001000600010004000000030007000300000002000000FDFF01000000FDFF060005000700FFFF02000200030003000400FDFF0100030002000300010001000300FEFF040002000300000004000000FEFF0200010005000000030004000200000001000000000004000200FFFF01000100000004000400010000000000020003000000030004000300FFFF01000300040000000100000000000000FEFF03000000"> : tensor<20x20xi16>
    return %0 : tensor<20x20xi16>
  }
}
