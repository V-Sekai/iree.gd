// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xf16>
    %1 = call @expected() : () -> tensor<20x30xf16>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xf16>
    %3 = stablehlo.multiply %0, %2 : tensor<20x30xf16>
    %4 = stablehlo.multiply %2, %2 : tensor<20x30xf16>
    %5 = stablehlo.multiply %3, %4 : tensor<20x30xf16>
    %6 = stablehlo.multiply %4, %4 : tensor<20x30xf16>
    %7 = stablehlo.multiply %5, %6 : tensor<20x30xf16>
    %8 = stablehlo.multiply %6, %6 : tensor<20x30xf16>
    %9 = stablehlo.multiply %7, %8 : tensor<20x30xf16>
    %10 = stablehlo.multiply %8, %8 : tensor<20x30xf16>
    %11 = stablehlo.multiply %9, %10 : tensor<20x30xf16>
    %12 = stablehlo.multiply %10, %10 : tensor<20x30xf16>
    %13 = stablehlo.multiply %11, %12 : tensor<20x30xf16>
    %14 = stablehlo.constant dense<1.000000e+00> : tensor<f16>
    %15 = stablehlo.broadcast_in_dim %14, dims = [] : (tensor<f16>) -> tensor<20x30xf16>
    %16 = stablehlo.divide %15, %13 : tensor<20x30xf16>
    %17 = stablehlo.custom_call @check.eq(%16, %1) : (tensor<20x30xf16>, tensor<20x30xf16>) -> tensor<i1>
    return %17 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xf16> {
    %0 = stablehlo.constant dense<"0x27C468B19CC25F3C51BA0138C546C63938BFB5BC4341B9449CC36041FA2E073F87C2FA3E71407730C4447FC26E404AC47C4209449BC11A45BA39DF3C49443FBE0EC4DC3C9A4338C24D3CDA3B2E43164168C7EC2BA93C8E3A7139CE4188BD23ADCCC3544188C2D93ED3B9E0C088BDF3441843A1B7E13B91C41B402EC1D83950C4763D06C2E5C39DC259AE39C117BC774463C1293F94C5BB3B8DC0F5C49BC149C2EBC222459C3F8A421746B0BD3B430FC11CBFEDC24E4466C405BA2EC071C562C63141E842D3BB703ABE4233422736ABBCB646B33CC443263F1139FAB9E1AF7CBF7CBDF34444380D3D4EB9EEC48540E7B697C062382DC25F4005BB333DEB467EC485442FBE84C51EC1C5B16B445D4522B602BC653D22C10B4089C053C245A491455CC5C0BBDF395A381B3CBCC4AA3E9DB45B449535114536BE333C2B46E0AFFABCAB3A37BC0AC85E377AC0CA2FDD463F243BBEF9C316C183437BC12FB6CD4346ADE33D2A3F0142E53515B9C3276D3C453B5247A53E77C26A43B8BF483E4FBEEBC06741D3C58F440DBE6C462EBE87B326C51240D93D00C3BBBBDF416FC230C4603BE542343906C4EC40E12F45BF0B4586C6A2C14B40E639DDC532C1402C833FF0C0103C5CC4A5C440BB3CC09040E2C04CC5A5BCB4360FBF91C2FCBFCA3A8CC51F480B448640773C70C53B44B9C3DC3F574483BFD62FA3C3B7C19635D7C1B9BF8446F9B067BF684087C0ADC00DB54EC117BAB43DBE41D53938C67AC3FBC0AF36B0BA9D40EC420AC00C2E74BB6DC4163D83C59EBDBDBDDC40813DDD422444F82DFDC0E73142C0BD42B9BC89AD9BC1AEBC3BBD693D9C3A56BF8CC58642F13F98C5A9C00A449FB58BC572C27A433848C4BFC132133E0F4409BCEBBACD3C073E02464AC40A387F2A3341F1C182C8CD30AD40AF45F53B933ED9C0D5C06A3F28418844DC3E923E92BAE9A433C4123BE63DB1C16540CDB86FBE94C170B3982719C50EC18ABE20C3CD3CC23760BDDEB43841663B88C573BE75C3DC3D9841DFBC744295BA47C1BCB895C08BC1F93CC2B861C201BD3B42A740ACBD1EC0CABD47C6E8B4E0B72A3B94C31041903B35311BC1854099B25A40D9BDB3BE454013413748DEC00EC081421B44104209C088C440C11DB9FB3A7EB930B882424DC500C0C7BEA03FC93AB843C7B882434733D6B88B423B3925BDBA43BA44DCC349C0FABCDDB0E641C83D74B97CBDD53ADF40A244D242FBC02CC10A410CB943BDC42F52472C3A7CB4C4C2BBC3BBC70CC39C35FF411F3B39C488433C3205C07BC0D3BF4240F63FBD3BD1C142C248AADD3F49BDC7B972355141E737A3BC4EC06ABC1DB4AD27DAC02240163B9AC31F3C9CC3D6423B3DD2444A43B3C337432D4261BE50C72D3F3129D23F05BC99BE74BC64C155C6904410BC543EF042FEBC8240BA3DFBC195BDA43621421DBE7546253ED63D57BD20447245EA44F2366E439241DDC0B53F39C116367FC5DEB957B936C0D5B9F243B64534C2ED3A86C492BFEA3D9336F54036BC9D376D3601C5D8450FBCF13C41449044D244A9C200408CC59DB5BB3C81C46441D6436AC09542A13F97C6F728F43D73A938C327C3443A6BAC4EB650C1E33C13B816BF2C36CEBE5E42EE476542E843A7415544A2BD454593BE5A442D3D224071BB9643C1B431C1AABD6E3F94C29CBF2B362BC26FA19EC068B9"> : tensor<20x30xf16>
    return %0 : tensor<20x30xf16>
  }
  func.func private @expected() -> tensor<20x30xf16> {
    %0 = stablehlo.constant dense<"0x008000FC0080000000FC007C0000007C008000800000000000800000007C0000008000000000007C00000080000000800000000000800000007C000000000080008000000000008086064D49000000000080007C0000007C007C0000008000FC008000000080000000FC008000800000000000FC0D47008000000080007C0080000000800080008000FC008074AB0000008000000080E854008000800080008000800000000000000000008000000080008000800000008000FC008000800080000000002FCC007C00000000007C00800000000000000000007C00FC00FC008000800000007C000000FC0080000000FC0080007C0080000000FC000000000080000000800080008000FC0000000000FC45BA0000008000000080008000FC0000008002D3007C007CA5280080000000FC0000007C000000802218000000FC0080007C62950080007C0080007C0000007C0080008000800000008000FC000000FC000000000000007C00FC007C0000007C0000000000800000008000000080008000000080000000800000008000FC0080000000000080E8D40000008000809D770000007C00800000007C00800000008000800000007C00800080007C0000008089300080008000FC00800000008000800080007C008000800080007C00800000000000000000008000000080000000000080007C00800080007C00800080000000FC008000000080008000FC008000FC00000000007C008000800080007C00FC000000000080007CB1EF008000000080008000800000000000000000007C0080007C00800000008000FC0080008000800000007C008000800000000000800080000000FC00800080000000000080007C000000005EB500FC0000000000000080007C007C000000800080007C00000000F63F0000008000800000000000000000000000FC00FC0080007C00000080000000FC0080008000FC007C00800080008000800000007C008000FC0000EC74008000800080000000000080000000FC008000FC00800080000000FC0080008000000000008000800080008000FC00FC007C008000000165007C0080000000FC0000008000800000000000000080008000000000000000800080008000FC007C00FC00FC00000080008000800000007C000000FC0000007C00FC0000007C00800000000000800080008000FC0000000000FC0080007C00000000000000800080000000FC0080007C0000007C00FC0080008000800080007C0000007C00800000007C008000800080000000003E540080008000FC0000008000FC007C0000007C00800080008000FC007C00800000007C0080BA2500800000000000000000008000000000008000800000007C000057B80080008000800080000089B00000000000800000000000800080007C000000800000000000000080000000000000007C00000000008000000080007C008000FC00FC008000FC000000000080007C008000800000007C0000F595007C007C0080000011B1000000000000000000800000008000FC00000080000000000080000000000080007C000000FC00800080007C00FC00FC0080000000FC0080007C0080000000000000000000000000008000000080000000000000C8F0000000FC00800080000000800080007C008000FC008000FC"> : tensor<20x30xf16>
    return %0 : tensor<20x30xf16>
  }
}