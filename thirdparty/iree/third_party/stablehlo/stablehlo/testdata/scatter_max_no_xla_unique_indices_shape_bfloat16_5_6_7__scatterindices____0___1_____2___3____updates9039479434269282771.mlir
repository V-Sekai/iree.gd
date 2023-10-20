// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xbf16>, tensor<5x2x2x7xbf16>)
    %2 = call @expected() : () -> tensor<5x6x7xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xbf16>, tensor<2x2x1xi32>, tensor<5x2x2x7xbf16>) -> tensor<5x6x7xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xbf16>, tensor<5x6x7xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xbf16>, tensor<5x2x2x7xbf16>) {
    %0 = stablehlo.constant dense<"0x32C0A64020BFCABF3440BEC00C40D1BF654032C042C0BA40D5401CC005C051407AC055C0A14097BFF1BF733F7E3F1EBFCA40823D82BE8DBFCDBF973F15BF9340AF3E03C0D5BFE03F80BFF8BF303F0B4082BF8C40503F1940D03EADBFDFBF8DBE14C0A3BFB9402740BA3F114001C03C3FF7BD6940CD3FF93EC63FA83F9FBF5F3E78C05F40CA3FA43D8AC04B3F2CBF77C031BF2BBF8D408A3F7DBEFB3EB6BE154039BFD93F98BF33403B3F72C0E13F92C0A93F1C40B2BE5340AD3F1840A2C08D3FF2BFB53FDABCE2C0AA3E41405C40D33CCABFBDBF293FA0409AC00F4074BF52BE10C0AF40D33F2FC0BBBF81C0904088BF0E40F2BF0BBF9F40193F3A404CBE9ABE933FDCBE12C081401DC0863E97C0833F11C0E53F4D402DC0B4BEAF40EBBFD03F9E3E09C04FBF6B3F64C037C0CAC02CC074BF0F40B34012405CC0183F07C0903F1C3FC23E8A40EABF6AC01940B1C097BDA13F8240053FB53F48BF20C077BFD93D93C0F63FB33FDEBF0ABF71C0CE3E673FA2BE8F3E313F01403BC0774097BF17409C40A3C07740DD3F03C0933F37C017C0454046BF914024BF0F3F68BFD23F0BBF713D61C0"> : tensor<5x6x7xbf16>
    %1 = stablehlo.constant dense<"0xB33F6C40EE3E123F223F773F18C020C03D3E2CC0173F05C00340C8BEF4BD5D405FC04FBFF73FDB3E15BE4CC02D3E3E4069C0A840213F9640D03F85C0B03F2D40A63F2240A0BD9A3FBDC00B416AC084BF093F4C3F47BE8C3EE1BDE6BFD03F5A3FA7BF79C0F4BF673F95C0893E034085C0424083BF0BC17DC0F03FA6BF8F3F38C012BF26BFC74049C0323F06409BBE44C0C7BF94406AC049BF0D4060C081C00340E83F19403FC0D6BE0FC0053F46C0673E863F98404C3E3640BA3F66BFA1BFEABF9E3F01C116402AC038C07CC080C0B9BE323E21410D4052402A4065C002C08C3F09BF5D401BBEFB3E57C021C005C0E53F1EBF8B401D406340CA3F20C061BE94C04CC0D4BFAE40304056400ABF403F19C060C0A13F02C083C0"> : tensor<5x2x2x7xbf16>
    return %0, %1 : tensor<5x6x7xbf16>, tensor<5x2x2x7xbf16>
  }
  func.func private @expected() -> tensor<5x6x7xbf16> {
    %0 = stablehlo.constant dense<"0xB33FA640EE3E123F3440773F0C40D1BF65402CC0173FBA40D540C8BEF4BD5D405FC04FBFA140DB3E15BE733F7E3F3E40CA40A840213F9640CDBF973F15BF9340AF3E03C0D5BFE03F80BFF8BF303F0B4082BF8C40D03F1940B03F2D40A63F2240A0BD9A3FB9400B41BA3F1140093F4C3FF7BD6940CD3FF93ED03FA83F9FBF5F3EF4BF5F40CA3F893E03404B3F2CBF77C031BF2BBF8D408A3F7DBEFB3EB6BE154039BFD93F98BF3340424083BFE13F7DC0F03F1C408F3F5340AD3F1840C7408D3F323F0640DABC44C0AA3E94405C40D33C0D40BDBF293FA040E83F194074BF52BE10C0AF40D33F2FC0BBBF81C0904088BF0E40F2BF0BBF9F40193F3A404CBE053F933F673E863F98404C3E3640BA3F833FA1BFE53F4D402DC01640AF40EBBFD03F9E3EB9BE323E21410D4052402A402CC074BF0F40B34012405CC0183F07C0903F1C3FC23E8A40EABF6AC01940B1C097BDA13F8240053FB53F48BF20C077BFE53F1EBF8B401D406340CA3F20C0CE3E673FA2BE8F3EAE40304056407740403F17409C40A13F7740DD3F03C0933F37C017C0454046BF914024BF0F3F68BFD23F0BBF713D61C0"> : tensor<5x6x7xbf16>
    return %0 : tensor<5x6x7xbf16>
  }
}
