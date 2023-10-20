// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xui16>, tensor<20x20xui16>)
    %1 = call @expected() : () -> tensor<20x20xui16>
    %2 = stablehlo.shift_left %0#0, %0#1 : tensor<20x20xui16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xui16>, tensor<20x20xui16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xui16>, tensor<20x20xui16>) {
    %0 = stablehlo.constant dense<"0x0000070000000300030000000000030002000300040003000300010002000200010001000400020002000100050001000200000001000200000006000200010004000000010003000100060003000100020000000500030002000000030000000200050002000500010001000100060001000000030004000100010002000400020000000500030001000400020003000100010003000000030000000200000000000000030002000100000001000500020003000500020005000100000002000400020001000100010000000100000003000000020005000300010000000000000001000300000005000300020005000100010000000300030001000000000000000200010000000100040000000200030001000400020001000100010001000200020002000100000005000300000002000200000000000500060000000000040000000100030000000300020000000100000002000000010000000000010002000200020003000000020001000000000001000000010001000100010001000300030000000300000003000200010000000600010002000800010005000200050000000500040000000100030000000100000002000300050003000500010004000400000001000200000000000000020001000200030002000400000001000500010003000100000001000000030002000100010000000300000001000300000003000200040005000100010001000000010003000900050003000500030001000300000002000400010002000300020001000300020002000100040002000000010006000100020001000200000004000000000001000000020002000000030003000100000000000200000000000500020002000000000000000100020006000400010000000200000005000100030000000000020003000200060004000100020004000100020000000000000006000200020000000200010000000200000000000000040000000000050007000100020001000000010001000400020007000000010000000400010000000500050000000100000004000000040001000300000004000300000003000000030000000400010004000200010004000200"> : tensor<20x20xui16>
    %1 = stablehlo.constant dense<"0x0000030001000200040001000000000000000600020004000500010004000200060000000400010000000100010002000100030001000100040005000300040002000000010002000400010000000100040000000200000000000100000004000400000001000200010001000000030003000500010002000000000002000000030002000000010000000000000003000200000002000200030001000100000000000200000002000400010003000100030000000000010000000400010003000000020001000000040002000200020005000400010002000100020002000200010001000600030002000200010001000100020002000400010006000100020002000200060000000400000002000600020000000600020000000200020000000100040002000200020006000500050001000200030002000000010001000300000000000300010002000000030002000200050004000100040001000500040004000400020003000100010003000000000004000100030000000300000001000100000002000100010001000000020004000200000000000400000000000400030007000100030004000500000001000000040000000000030000000100010001000300010000000100000000000100020000000300010000000000010000000200040000000000070000000200020000000000030000000100010002000200030000000000010005000300040002000000000003000300000002000100020003000200000004000100000002000100000000000400010000000100000003000700040002000000040005000100010002000300040003000000010000000300000003000000080001000600060002000100000001000000020003000100050002000000050003000400010001000000000003000400000001000000000001000400050001000200000001000300000004000400010001000400020001000200060004000100050001000000060000000300000001000300040005000000010004000100040001000800010002000000030002000100050001000100010000000300010000000500040005000200000004000100020002000000050001000100"> : tensor<20x20xui16>
    return %0, %1 : tensor<20x20xui16>, tensor<20x20xui16>
  }
  func.func private @expected() -> tensor<20x20xui16> {
    %0 = stablehlo.constant dense<"0x0000380000000C0030000000000003000200C0001000300060000200200008004000010040000400020002000A00040004000000020004000000C000100010001000000002000C0010000C000300020020000000140003000200000003000000200005000400140002000200010030000800000006001000010001000800040010000000050006000100040002001800040001000C000000180000000400000000000000030008001000000008000A0010000300050004000500100000001000040008000200010010000000040000006000000004001400060004000000000000000200C000000014000C0004000A0002000400000030000600400000000000000008004000000010000400000080000C00010000010800010004000400010004002000080004000000400160000000040008000000000005000C0000000000040000000800060000000300100000000400000020000000100000000000100020002000080018000000040008000000000010000000080001000800010002000600030000000600000006000200040000001800010002008000010005002000280000000A00200000002000030000000100000002000300280003000A000200080020000000010004000000000000000800010010000600020004000000010014001000030001000000010000000C0002000100080000000600000004000C000000030002000800A000080010000400000001001800480005000C000A000C0008000C00000020000800010008000600020001003000040002000200040010000000100018000100200020000400000010000000000008000000040002000000030018000100000000008000000000000A0002000400000000000000020040001800040020000000200000000A000100030000000000020006000200060008001000400008000400020000000000000060002000040000002000040000000800000000000000800000000000400107000800020002000000100020000400040070000000100000000004020000000500280000000200000008000000080001001800000004006000000060000000030000000800040010000200200008000400"> : tensor<20x20xui16>
    return %0 : tensor<20x20xui16>
  }
}
