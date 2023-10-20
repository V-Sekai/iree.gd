// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xi8>, tensor<3x5x2xi8>)
    %2 = call @expected() : () -> tensor<3x5x40xi8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i8>, %arg1: tensor<i8>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<i8>
      stablehlo.return %5 : tensor<i8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xi8>, tensor<2x1xi32>, tensor<3x5x2xi8>) -> tensor<3x5x40xi8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xi8>, tensor<3x5x40xi8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xi8>, tensor<3x5x2xi8>) {
    %0 = stablehlo.constant dense<"0xFFFD0400FDFFFF0103020000FFFE0606000100010003FFFEFDFE0401FC03FE0000FEFBFF0101FDFC0007FFFE0000000300FE0001FEFF04FCFBFE050101FF03030000000001FCFB03FF000103030300000003020000010004FD0007FA0100FEFDFEFEFFFE02FFFDFF0000FF01FE0300FF0105FDFDFE02000101FE0303FEFF040002FB00FFFFFC02FE0000010000030601010003FEFF00000302FD00FC00FCFB0002FEFCFDFFF803FF0202FF02FEFFFD00FC0201000002000100000000FE0000FE00FB0002000000FF07FE0005FFFE00FAFF00FCFDFB00F701FEFF000000FDFFFDFCFB000000FF01FF00FC0600FFFBFF00FD0202FB01000102020000FF00FC00FD03FFFB03FF020100FD0100FF05FA06FD00FA0202FDFE0000000200FBFDFFFCFC00040302020001000003FE00030100FE02FCFF000200FF00FBFFFC00FA0001FEFFFC04FCFC0002FE01030000FF00FBFD06FCF902FC000403030101FFFE01FFFD000102FDFD00FC010101FC00FFFF01FDFF00FC03FD040502FB000000FFFD04FEFE00FF03FE0000FD0001FEFE01FE00000100FFFB0000FFFDFF0202FEFD0203FE0301FE0003FF000001000302FBFD0001FF00FFFEFB00FFFFFF02FF0104FD01FD02020102FB00FF000203FCFF0101FEFE00FC020000FEFD000203FEFFFE0305FCFEFF04FE00000201FFF9FFFE0304FC010100030004FE0100FF00020102010103FC0302FFFC0000000303FFFE02FC0C000704020600FD000200FFFFFC00000103FF04020001010000FDFB0400F800030200FDFB000102000003000003FF02F9FD030002030104FF0002FF0001010000FEFEFA00FBFDFCFF02"> : tensor<3x5x40xi8>
    %1 = stablehlo.constant dense<[[[0, 2], [-1, 2], [3, -1], [3, 2], [-2, -2]], [[-4, 2], [1, 3], [1, 1], [0, 0], [-3, 0]], [[-4, 4], [1, -3], [-4, 1], [3, 1], [-4, 0]]]> : tensor<3x5x2xi8>
    return %0, %1 : tensor<3x5x40xi8>, tensor<3x5x2xi8>
  }
  func.func private @expected() -> tensor<3x5x40xi8> {
    %0 = stablehlo.constant dense<"0xFF020400FDFFFF0103020000FFFE0606000100010003FFFEFDFE0401FC03FE0000FEFBFF0101FDFC0007FFFE0000000300FE0001FEFF04FCFBFE050101FF03030000000001FCFB03FF000103030300000003020000010004FD0007FA0100FEFDFEFEFFFE02FFFDFF0000FF01FE0300FF0105FDFDFE02000101030303FEFF040002FB00FFFFFC02FE0000010000030601010003FEFF00000302FD00FC00FCFB0002FEFCFDFFF803FF0202FF02FEFFFD00FC0201000002000100000000FE0000FE00FB0002000000FF07020005FFFE00FAFF00FCFDFB00F701FEFF000000FDFFFDFCFB000000FF01FF00FC0600FFFBFF00FD0302FB01000102020000FF00FC00FD03FFFB03FF020100FD0100FF05FA06FD00FA0202FDFE0000000200FBFDFFFCFC00040302020001000003FE00030100FE02FCFF000200FF00FBFFFC00FA0001FEFF0004FCFC0002FE01030000FF00FBFD06FCF902FC000403030101FFFE01FFFD000102FDFD00FC010101FC00FFFF01FDFF00FC03FD040502FB000000FFFD04FEFE00FF03FE0000FD0001FEFE01FE00000104FFFB0000FFFDFF0202FEFD0203FE0301FE0003FF000001000302FBFD0001FF00FFFEFB00FFFFFF02FF0104FD01FD02020102FB00FF000203FCFF0101FEFE00FC020000FEFD000203FEFFFE0305FCFE0104FE00000201FFF9FFFE0304FC010100030004FE0100FF00020102010103FC0302FFFC0000000303FFFE02FC0C000704020600FD000200FFFFFC00000103FF04020001010000FDFB0400F80003020000FB000102000003000003FF02F9FD030002030104FF0002FF0001010000FEFEFA00FBFDFCFF02"> : tensor<3x5x40xi8>
    return %0 : tensor<3x5x40xi8>
  }
}
