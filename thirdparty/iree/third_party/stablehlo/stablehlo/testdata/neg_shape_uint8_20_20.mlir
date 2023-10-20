// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xui8>
    %1 = call @expected() : () -> tensor<20x20xui8>
    %2 = stablehlo.negate %0 : tensor<20x20xui8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xui8>, tensor<20x20xui8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xui8> {
    %0 = stablehlo.constant dense<"0x0404010200040003000001040101030102000101020101010103010103030303010603030602010200030102030400040003000201000205000000010001040401020003020101000300010301000000080701010104020300000200010200040603000500040200020002000201010303040204000201030301010102050104040300000000000300030001030204020304050100060005000700000702070000030207020201030004010403000602010107000006010202040201000201060104010500000107020501020203000500030501000003040000010602040101040000040101000205000104020100040001020003000004000100010003020305020000040101020402020402070203040103000500000302000002010500070000020000020206040400030402040400020102020000000101020001010200010302040502010304000100010200040200020101030100000003000404020004020101030000000204010101020400010201000A000201030401020501000300000001000200000002000504040201"> : tensor<20x20xui8>
    return %0 : tensor<20x20xui8>
  }
  func.func private @expected() -> tensor<20x20xui8> {
    %0 = stablehlo.constant dense<"0xFCFCFFFE00FC00FD0000FFFCFFFFFDFFFE00FFFFFEFFFFFFFFFDFFFFFDFDFDFDFFFAFDFDFAFEFFFE00FDFFFEFDFC00FC00FD00FEFF00FEFB000000FF00FFFCFCFFFE00FDFEFFFF00FD00FFFDFF000000F8F9FFFFFFFCFEFD0000FE00FFFE00FCFAFD00FB00FCFE00FE00FE00FEFFFFFDFDFCFEFC00FEFFFDFDFFFFFFFEFBFFFCFCFD0000000000FD00FD00FFFDFEFCFEFDFCFBFF00FA00FB00F90000F9FEF90000FDFEF9FEFEFFFD00FCFFFCFD00FAFEFFFFF90000FAFFFEFEFCFEFF00FEFFFAFFFCFFFB0000FFF9FEFBFFFEFEFD00FB00FDFBFF0000FDFC0000FFFAFEFCFFFFFC0000FCFFFF00FEFB00FFFCFEFF00FC00FFFE00FD0000FC00FF00FF00FDFEFDFBFE0000FCFFFFFEFCFEFEFCFEF9FEFDFCFFFD00FB0000FDFE0000FEFFFB00F90000FE0000FEFEFAFCFC00FDFCFEFCFC00FEFFFEFE000000FFFFFE00FFFFFE00FFFDFEFCFBFEFFFDFC00FF00FFFE00FCFE00FEFFFFFDFF000000FD00FCFCFE00FCFEFFFFFD000000FEFCFFFFFFFEFC00FFFEFF00F600FEFFFDFCFFFEFBFF00FD000000FF00FE000000FE00FBFCFCFEFF"> : tensor<20x20xui8>
    return %0 : tensor<20x20xui8>
  }
}
