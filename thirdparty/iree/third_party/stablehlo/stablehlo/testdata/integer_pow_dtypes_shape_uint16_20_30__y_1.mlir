// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xui16>
    %1 = call @expected() : () -> tensor<20x30xui16>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<20x30xui16>, tensor<20x30xui16>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xui16> {
    %0 = stablehlo.constant dense<"0x000000000400020006000300000003000400010002000200000003000000000001000000010001000200000001000100000000000400020000000600010006000100010002000000030002000400010004000100000008000200050004000700040003000000000004000200010001000300020000000000000000000200000004000400020002000100000002000000000003000100020002000100030001000300010000000100000000000200000000000000020001000000050001000000000001000100010001000200000001000000010000000200060003000100020005000400030002000300070000000000030006000700010003000000030000000200040000000000030000000100010003000000030002000200030001000000030000000000040005000500000003000200030004000200010001000100000000000400000003000100020002000100000000000000030002000300030001000100010002000000020000000100030000000100020001000100010002000300000001000000030004000300050006000000020005000200010000000200030001000300050000000000050002000900010001000100000000000300020007000400020000000100000002000100010002000000040001000900010008000500030002000400000009000900010001000400010001000600000002000300020003000400020002000100050005000200020003000100040002000500000001000100000001000000020003000200010003000500010005000000020003000400020005000400010003000300020000000300020000000200060004000100010001000100030007000200070002000300000002000000030007000200000002000100010005000000030001000400000001000400010004000200000001000600060006000100000000000200050004000000010003000200020003000400010000000000030001000000010005000000030006000100040001000100040003000100000001000200030000000100030003000300000001000100010000000600020004000300040002000000010001000300020003000000030003000100020003000000020005000300010004000600020000000000030001000000000002000100090001000300010000000100020005000000060001000300030002000300000003000100010002000200040000000000030001000300020001000100030003000100030007000400020000000000000000000500010008000000070002000400060002000200010001000100010000000300010002000100000003000100020002000200010001000600060000000400010001000400020003000000000000000700000004000000000002000200030000000400010000000000010001000000000002000000020001000100060001000000020004000400000006000400060002000300080000000100000007000100030000000100060002000200000000000100040003000100040001000200010000000000010005000000000003000000020003000200040001000100020002000400050002000000040002000100000000000400020000000200010000000200000000000100020000000000020000000200030002000100030000000000"> : tensor<20x30xui16>
    return %0 : tensor<20x30xui16>
  }
  func.func private @expected() -> tensor<20x30xui16> {
    %0 = stablehlo.constant dense<"0x000000000400020006000300000003000400010002000200000003000000000001000000010001000200000001000100000000000400020000000600010006000100010002000000030002000400010004000100000008000200050004000700040003000000000004000200010001000300020000000000000000000200000004000400020002000100000002000000000003000100020002000100030001000300010000000100000000000200000000000000020001000000050001000000000001000100010001000200000001000000010000000200060003000100020005000400030002000300070000000000030006000700010003000000030000000200040000000000030000000100010003000000030002000200030001000000030000000000040005000500000003000200030004000200010001000100000000000400000003000100020002000100000000000000030002000300030001000100010002000000020000000100030000000100020001000100010002000300000001000000030004000300050006000000020005000200010000000200030001000300050000000000050002000900010001000100000000000300020007000400020000000100000002000100010002000000040001000900010008000500030002000400000009000900010001000400010001000600000002000300020003000400020002000100050005000200020003000100040002000500000001000100000001000000020003000200010003000500010005000000020003000400020005000400010003000300020000000300020000000200060004000100010001000100030007000200070002000300000002000000030007000200000002000100010005000000030001000400000001000400010004000200000001000600060006000100000000000200050004000000010003000200020003000400010000000000030001000000010005000000030006000100040001000100040003000100000001000200030000000100030003000300000001000100010000000600020004000300040002000000010001000300020003000000030003000100020003000000020005000300010004000600020000000000030001000000000002000100090001000300010000000100020005000000060001000300030002000300000003000100010002000200040000000000030001000300020001000100030003000100030007000400020000000000000000000500010008000000070002000400060002000200010001000100010000000300010002000100000003000100020002000200010001000600060000000400010001000400020003000000000000000700000004000000000002000200030000000400010000000000010001000000000002000000020001000100060001000000020004000400000006000400060002000300080000000100000007000100030000000100060002000200000000000100040003000100040001000200010000000000010005000000000003000000020003000200040001000100020002000400050002000000040002000100000000000400020000000200010000000200000000000100020000000000020000000200030002000100030000000000"> : tensor<20x30xui16>
    return %0 : tensor<20x30xui16>
  }
}
