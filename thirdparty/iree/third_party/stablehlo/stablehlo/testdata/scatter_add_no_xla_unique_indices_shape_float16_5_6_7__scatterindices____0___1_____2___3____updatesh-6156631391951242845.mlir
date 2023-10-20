// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<5x2x2x7xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2x1xi32>, tensor<5x2x2x7xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<5x2x2x7xf16>) {
    %0 = stablehlo.constant dense<"0x0BBFDFB121A143BB2940D541EEC39639BCBF8D3D3841074380C262C6F3C12F3D3CBEB23BB7C4AFBF39C30D446CBE7A3BA7B636BB59C2EC3E64C13D40244450C07AC0DF39EF36273C17BA51C0B440EB3B65C4963EA6BE09B9F7C5DEBC3B413640363CB33DF4BAF8C4B5C076BEC244B2BE06BF754540391ABBCEBA9E3862BDA7BFA73E2044F3BB9D40EB43E744D4C087AC39C55E40E7BBBF440F42E9ACACB90A40EDB384B05328F7BFBE3CE53C044225C080C5B83E46B98EBE1FBE2F3D76C028B0B0BC423C93BE873EB53AB543CB43F53811B4ECC64E326CC10B3B9AC5B43470C12C44CE3C52BD15C014C36AC5A7C64CB93BC5973E77B785BE3946254649C59942C43A313A2C3DB7BD4143693D7AC87245AEB98D3CB8319547EC4149C3853E123862C0AE376DBC8B41CDC58A4191BCAAC5B8B5E13AC5BD92BF48B165BDA432D9C6BCBE45C02E3872AEB6C280AF2CB4EB42FAC148C492C050C19D4250BD33BDDA405C4738BBF2BCC6C50642BF3CA8BEC1427A44FF42A541DFB825B307C639C4D0455F44174421C355BC073EE7BB0AC143BA3BBE743849451F4706BA0AC117C5CB4300C059BC"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<"0xA0BF06AE524191407C388543A040623E03314E396EBBB73E3CC1424127C56CBE20C577C26EBE7DC582C242BF57C19844174426BE13BD19C77B3DE2429FB5C3437A44124155BB48BF2EC43CBBE1B4AF4551BD27BB05C4CFC06C440142E3BEADBDD2AD9840C4421DC14639B6C3793F37B841455045E9B462C62544983A2440BF4227BAECC2F7C170BC09C1C4C36644EDBFE93DC4B1EABF0F451FC466414E459ABAE3BF8341E83FE03E11C124C79EBD17C35DC162403B418EC259C5C8C3C44235C119C090C142BDD443AD3E19BCC0388EBDF5B19D32754478B900ABEC3D903F00BD3045BC4038C03540A33D08C39BA9F3C384BE5FC3513D36C5F744183D7FB5A7C2833ED7C173C504420242EB39874015C0323E7542663D02BE"> : tensor<5x2x2x7xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<5x2x2x7xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0x56C371B44D41803D4841AD469CBE96401CBF1A40B93E3145DEC582C310C8F4B4AFC68AC052C669C7DEC6794046C487455943E0C071C45EC564C13D40244450C07AC0DF39EF36273C17BA51C0B440EB3B65C4963EACB4A04151C654411847A4445C3054B60CC5E0C551C11244DC4223C1C6C51B4214453A4025C1BCBABFBD24360C45463E5AB532BED4456044D4C087AC39C55E40E7BBBF440F42E9ACACB90A40EDB384B05328F7BF7046894667413AC86CBD0241A53DF03E99C054C036C5F5BC61C3A3C1824198B5A2405943AC3FAE4560C439C4804512C35EBCB1C18A4000BC2C44CE3C52BD15C014C36AC5A7C64CB93BC5973E77B785BE39462546D2C7AFC378B88BC18EBD1A3A3E46B3BF26CB383E5841DDBD7BBFCD44963E5834994220B864BE45BB2CBDF54160BD2C40C9BC2FC4223E3EB6C5BD92BF48B165BDA432D9C6BCBE45C02E3872AEB6C280AF2CB4EB426640A8BF65C46CB8B744D8C460BD32BEBB4596C4F02D7EC9FA47EC4004C0802A1B46A03841C1CC4090414AC5D6BF8B43EC4552476EC02CC1073EE7BB0AC143BA3BBE743849451F4706BA0AC117C5CB4300C059BC"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}
