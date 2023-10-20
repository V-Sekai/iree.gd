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
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2x1xi32>, tensor<5x2x2x7xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<5x2x2x7xf16>) {
    %0 = stablehlo.constant dense<"0xD1BA28BE8D3E944398B8EDAD194331C21FC4B238D1BBE03F093CACC0A3C4AEB8863D6242DCB4D3BB11C41FBE093A86C3DD3398BEEE43EBBD2D3CCEC36EBD66BDDBC479B03836923F44C32F39FF46364002C58040FBB79C4044C5E1C3AC3C4D4604423641B3BF8438B7BD2641F7C0A3C526444434AEC3BD3F7D3CEBC219C8833D21C57EA71D4450BABA44633D454447BA9BC08338E3340C402B4580BA2337E03939B7D643D2BF5EB92FC1493C17C3CEC17EC431BDB53CDA3F5EBA383FBB418D44EA3AF23E0C3CB4B428407CBCF74190C489BA10B0353F4AC06E455EBDA94496C1FFC1BC410544DEBA3643C5C57E3D7943A8307F40FB3C5EB814341341B3B95FC0E9473EB9EBC19B4282411A42C848983F1C4073405EBDEB39B6C063C1F5BF21C44944AA402742AAC188B7463FB1423037B7C4643EDE428AB794C0F3A822C04DC0E7360BB48AB8F6C43A3EF8C4F3C537BD4A404C3F77C033BD8CBD8A433D4013C43343BFBF293D91BC3E44903F804170C1F5B7FA423339384263B612C639452D3402BF3FC44438A4C232C11BC127428742963B573E4B463AC413C1BA4587452F42ABB8D3C0"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<"0xD3C15A415CC01340663E3D47F9B64BC37E3DC63CC1BF2DC1C0B6B8C278BAF74345C0D4382E415DC41FBE45C39B2E7E4150C41A3F32C1753F02C451C265C5A23B91C55D44043E80BA64BD4C345EC07242664063BF063871481B38BA33C6C891BD9CB6924346B991B88CBE8F3F9746B641DEC477B9B64197404738C0C42342A788E3B69CBFCE413EC2B73044C45CC0EA406F4131420A3E60C1944062C6C0BF9FBD95B823B4E342D041BEBCCCB489C0F4388BBFED3DB1AE48BC72BE113C90B8B5369AC450BC3AC112C416BEF3C11A418FC33AC12341873A3B40103A91C4F6AB6E37CB46D840E3B1D5398B4167BC02BF904426428FAE1DC08EC3B3B950C574B8B9B9A1C0AB3C01C1154548BCB03A3BB5C43DF44004BF85B89DC0"> : tensor<5x2x2x7xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<5x2x2x7xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0xF6401EC424C3B84759BB5DB930BEA549A9C59A39933F18C5CFB6D9478043A9C0E5C1B43F4BBA444439469045FC2C2AC93DBCDAC126C984C12D3CCEC36EBD66BDDBC479B03836923F44C32F39FF46364002C58040FF3F47C71A4F84C380C6DF4E86443CC03041DA303D42264876C534492C40BD40E2BF79375BC9D044C5423745C3424724BBC6F7BDC94FB143454447BA9BC08338E3340C402B4580BA2337E03939B7D643D2BF5EB94F4ADBB910C9A9C6CEC02A463943918C7B35DEC228481ACB133068C769C0C7B9A545F1C28144224A7BBF7C3AFBC2074238C28D35034C0FC8FFC1BC410544DEBA3643C5C57E3D7943A8307F40FB3C5EB814341341C23A3E397CCC7EB69445E5449BB488C2B4CBB83FB0BC763B2D4661BA28467B490E42244A774968C805C846C725B6B14312411AC0B134EF39DE428AB794C0F3A822C04DC0E7360BB48AB8F6C43A3EF8C4F3C537BD494B6B44923695BBB0C326C46DC3A6CC88495A324EC150440BC206C920BEC73F9B3C124481BEE74BD63613C5D4BE053657C47247D2B4A94732C11BC127428742963B573E4B463AC413C1BA4587452F42ABB8D3C0"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}

