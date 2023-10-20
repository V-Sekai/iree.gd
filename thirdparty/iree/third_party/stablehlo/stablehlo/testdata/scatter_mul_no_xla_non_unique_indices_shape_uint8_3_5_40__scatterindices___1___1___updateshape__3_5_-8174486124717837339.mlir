// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xui8>, tensor<3x5x2xui8>)
    %2 = call @expected() : () -> tensor<3x5x40xui8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui8>, %arg1: tensor<ui8>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<ui8>
      stablehlo.return %5 : tensor<ui8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xui8>, tensor<2x1xi32>, tensor<3x5x2xui8>) -> tensor<3x5x40xui8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xui8>, tensor<3x5x40xui8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xui8>, tensor<3x5x2xui8>) {
    %0 = stablehlo.constant dense<"0x010304010204020000030400020204000103020402050501010006000102070107020301040003000401040504000101040402040002000403030101030301030202010202010006060205020101000000010201040100020402010100050201010305020203030301050300010300020200000004010001040402010002020201030203000200040101000001000307000000000201000301050000010401000202030102030400080602010402000100030200010001020200020302010001020504000100020002040002010100020101030202020301010202010101020001060200020201010100020600010105030100030301020202010303010402040203030003000307010000000600040102010102060503040000040101030102020003000301010602020200050402030200020401050003020304030201010005010303010302030004030101030200030200010204020200000201000202030004020101010203040004040305050201020103010202010002020102050000030003010205010004010201020001050000030101010201020101020201010204000100040002010201010001000201000005000404010300000201000101040003050202020300030202000000000300010000020301010103020100020104000100020205000001040200000300000301080002010100050605000606000304000101000105010405030302010102030002060001010301000304000503000400020000010505060202010100080001010002000004010403070200050002060401030104020403060001030200050105000204070307"> : tensor<3x5x40xui8>
    %1 = stablehlo.constant dense<[[[1, 5], [1, 4], [2, 4], [1, 1], [4, 2]], [[4, 0], [0, 1], [2, 1], [1, 4], [0, 0]], [[2, 1], [0, 0], [1, 0], [3, 1], [1, 5]]]> : tensor<3x5x2xui8>
    return %0, %1 : tensor<3x5x40xui8>, tensor<3x5x2xui8>
  }
  func.func private @expected() -> tensor<3x5x40xui8> {
    %0 = stablehlo.constant dense<"0x010F0401020402000003040002020400010302040205050101000600010207010702030104000300040404050400010104040204000200040303010103030103020201020201000606020502010100000008020104010002040201010005020101030502020303030105030001030002020000000401000104040201000202020103020300020004010100000100030700000000020100030105000001040100021003010203040008060201040200010003020001000102020002030201000102050400010002000200000201010002010103020202030101020201010102000106020002020101010002060001010503000003030102020201030301040204020303000300030701000000060004010201010206050304000004010103010202000300030101060202020005040203020002040105000302030403020101000504030301030203000403010103020003020001020402020000020100020203000402010101020304000404030505020102010301020201000202010205000003000301020501000401020102000105000003010101020102010102020101020400010004000201020101000100020100000500040401030000020100010104000305020202030003020200000000030001000002030101010302010002010400000002020500000104020000030000030108000201010005060500060600030400010100010501040F030302010102030002060001010301000304000503000400020000010505060202010100080001050002000004010403070200050002060401030104020403060001030200050105000204070307"> : tensor<3x5x40xui8>
    return %0 : tensor<3x5x40xui8>
  }
}
