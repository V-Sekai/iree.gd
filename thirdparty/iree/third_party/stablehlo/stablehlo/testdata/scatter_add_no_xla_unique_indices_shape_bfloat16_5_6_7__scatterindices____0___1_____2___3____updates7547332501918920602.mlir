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
      %5 = stablehlo.add %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xbf16>, tensor<2x2x1xi32>, tensor<5x2x2x7xbf16>) -> tensor<5x6x7xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xbf16>, tensor<5x6x7xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xbf16>, tensor<5x2x2x7xbf16>) {
    %0 = stablehlo.constant dense<"0xAABFA63F8BBFA4BF1440D03E0F4009409BBF5D4052C05CC0B1407DBE5CBF0F40DDBF3AC07ABFA83F3C40D8BF58C0803FD4BF8E3FB03FE93EB04094C022BF643E4A3FF2B6BFBFBFBFC53EA9C004C141C02840C8BA7BC0E0BF48C0ADBEC740384001BF55C07BC09FBEB53F86C09BC0FEBF5D3F37BF5E3F4F4043C0064079C0F0BF983E67C0A63F853D81BF6640A5BF9A3E97BE6D40E43ECB3F203F6BC08C3E1D3F8DBFD8406B409EBE2F40B63F213F15C0A5C0CDC0094007C076BE974082C00DC0BF3E043E9FC07A4009C09B3F9F4086C0AABFBBBF0AC08EBFAC3F8AC0D2C03B4055C0B8BF36C0ACC0FCBFDFBF3E3F873F9CC03BBE87BECCBF5AC0453F754033401C40134013C0323FA5C0564051407A3E84C08D40A63F04BE893FE43FEE3FDABE5BC0A5BF4DBFC73F50BF1BBF9E3F35404F4015C010BE8640C23E69BF88BDA8BF2F4085BF90C01840073F4D409B40D6BFE53F73401FC00F40993F4BC021C01DC0C2BFD23FF33F8840D3C01D403BC0043F3440663FE1BDF93F64402E3F103FAA3F56C096BFD63FFE3FA4408AC028409A408D3FA1BFCCC040BFA0BFB74068BEC33E68C0423E"> : tensor<5x6x7xbf16>
    %1 = stablehlo.constant dense<"0x3940A8BF9940AF40CFBFB53F69C0EEBF1DC0DB3FC34087BF66C01EBF5840AFC0BB3E94BE21402AC058C088BEDB3FA1BF16C00E3F3DBE70C08EBF203E0ABFF23F51C008401E3F19C0B23F70404F3F2740C2BF02C1B9BF24404D3F7DBFE53C6BC080BF74403AC0CDBE493FDCBEA6BFCBBF81C02F409CC0A83F953FCB3F1741F1BF603E71BEF3400E40BABCADC008C01E40CF3F18400F401BC0843F6FC0C03F184082BFCFC0183F93BEEB3F14C0ABBFAB3E89C09EC08E3FA83F5140E8BD354056BF493F4240F03F43C08BC057408DBF4240C840F240CC3F98BFDABF24C096C0AD3ED53F48BFFA3F24404A402740BA3E28C091404A3D46C06EBF03C1C3BF164082C0EB3E273FA1BE56BE99402D3FB73E99408BBF0EC06540D63E"> : tensor<5x2x2x7xbf16>
    return %0, %1 : tensor<5x6x7xbf16>, tensor<5x2x2x7xbf16>
  }
  func.func private @expected() -> tensor<5x6x7xbf16> {
    %0 = stablehlo.constant dense<"0xC83F80BC6C408640323FE93FB4BF903E6AC0A540344090C0F83F5DBF21404FC0AEBF4CC0C53FACBFE0BEFABFD5BF84BE80C0D53F983F53C0B04094C022BF643E4A3FF2B6BFBFBFBFC53EA9C004C141C02840C8BAA1C0CCBF6AC0C73F3D40A040E83DB7C022C05C400E40CABFCCC022C115BFEC3FD63F104041C0CABF9CC0F83F27C080C00540BBBE14C00040A5BF9A3E97BE6D40E43ECB3F203F6BC08C3E1D3F8DBFD8406B409EBEA6BF854088C082BF80C09AC0394180C0B0BC8F406240803CB33EA9C0E3C0CC4006BF6640E640D4C098BEA6C028BFA23FA83E2CC1BFC0294055C0B8BF36C0ACC0FCBFDFBF3E3F873F9CC03BBE87BECCBF5AC0453FB540F83E8D3F2840D2C088C082C09540D140063EA6BF644005403A403C40A2BF1FC03C4091C0DF3FAE401241483FE6BFF0BE883EBABFFFBF10BE8640C23E69BF88BDA8BF2F4085BF90C01840073F4D409B40D6BF5D40414008BF9A408B4010BF0AC0A2C04140D83F99BF54406CC16E3F14BF63C05140C63FD9BEDE3F0641AE3F6C3FC4408EC059C0A8401A40A4408AC028409A408D3FA1BFCCC040BFA0BFB74068BEC33E68C0423E"> : tensor<5x6x7xbf16>
    return %0 : tensor<5x6x7xbf16>
  }
}

