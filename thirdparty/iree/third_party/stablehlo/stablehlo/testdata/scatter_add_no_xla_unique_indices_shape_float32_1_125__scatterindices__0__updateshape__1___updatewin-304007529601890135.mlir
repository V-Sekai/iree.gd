// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x125xf32>, tensor<1xf32>)
    %2 = call @expected() : () -> tensor<1x125xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x125xf32>, tensor<1xi32>, tensor<1xf32>) -> tensor<1x125xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x125xf32>, tensor<1x125xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x125xf32>, tensor<1xf32>) {
    %0 = stablehlo.constant dense<"0xD36EC14054E1A23F9B8B8D405B3A4A3FA1F8FC3F25259F3F732BC93E6F1F0F40B1461740C076BA3F25FF03400C47BDC0531AB8BD93474AC0F354873D351BFEC0EFE2A33FB3924440D60F3DBF8B6278BFBBD05FC072603D40CAB3E940C80F99BF06821BBC4CF86D408B7F3AC04649834010DE6DBE0A181EC0C56BBCC0193C253F512931C0E0521A40029EAC3FFC2CDDC044A728BF81017A40C5B274C0FD4AF53F2DBA993F447318C09FD8F840A8F0BE3FF77508BFA18E2FC0BC990740BF622240594127BF1BCBD53E0A6D43C0FD0439BEFDCEF240ACBD1A3A8EC28040014F884086058EBF673B4D40C5CF024088E40CC06C1AB03E536E91BF0416CE3F189F31C003A31CC0F9F10540A69EE3BEB1DF9A40DE4B2EC0BFAFA9C07D89EEBD313A9B40EC4A32BF79EE5040D2F648C0C65594404415903F8CC825C0BE12B640DE56B73F65A20CC071C60FBFD69D76401C5F96C0F9CF39C0CA20F040FAE6963F461B633F33B12D3F0C45D6C01E747EBF1A0AAAC09A93B5BF3915074041BC944092ADDFC0E755BABED0A82A3E96B3A6BFD29772BFD1226440F25D53407DA4A8BF58ADC2BF03F99DC0EF7094C0A30B4EC0A75B08400CF481BFCA0AEF3D98FCDEC0C4D15140EF9D83BEEAE24DC06C1779BF649AE9BFE0EC30C039AA7EC0EA4533C0A5E2273F8CD5334086BDA53E157ADEBF4CF71640672FADC0"> : tensor<1x125xf32>
    %1 = stablehlo.constant dense<1.48225808> : tensor<1xf32>
    return %0, %1 : tensor<1x125xf32>, tensor<1xf32>
  }
  func.func private @expected() -> tensor<1x125xf32> {
    %0 = stablehlo.constant dense<"0x7CDDF04054E1A23F9B8B8D405B3A4A3FA1F8FC3F25259F3F732BC93E6F1F0F40B1461740C076BA3F25FF03400C47BDC0531AB8BD93474AC0F354873D351BFEC0EFE2A33FB3924440D60F3DBF8B6278BFBBD05FC072603D40CAB3E940C80F99BF06821BBC4CF86D408B7F3AC04649834010DE6DBE0A181EC0C56BBCC0193C253F512931C0E0521A40029EAC3FFC2CDDC044A728BF81017A40C5B274C0FD4AF53F2DBA993F447318C09FD8F840A8F0BE3FF77508BFA18E2FC0BC990740BF622240594127BF1BCBD53E0A6D43C0FD0439BEFDCEF240ACBD1A3A8EC28040014F884086058EBF673B4D40C5CF024088E40CC06C1AB03E536E91BF0416CE3F189F31C003A31CC0F9F10540A69EE3BEB1DF9A40DE4B2EC0BFAFA9C07D89EEBD313A9B40EC4A32BF79EE5040D2F648C0C65594404415903F8CC825C0BE12B640DE56B73F65A20CC071C60FBFD69D76401C5F96C0F9CF39C0CA20F040FAE6963F461B633F33B12D3F0C45D6C01E747EBF1A0AAAC09A93B5BF3915074041BC944092ADDFC0E755BABED0A82A3E96B3A6BFD29772BFD1226440F25D53407DA4A8BF58ADC2BF03F99DC0EF7094C0A30B4EC0A75B08400CF481BFCA0AEF3D98FCDEC0C4D15140EF9D83BEEAE24DC06C1779BF649AE9BFE0EC30C039AA7EC0EA4533C0A5E2273F8CD5334086BDA53E157ADEBF4CF71640672FADC0"> : tensor<1x125xf32>
    return %0 : tensor<1x125xf32>
  }
}
