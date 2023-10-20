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
    %4 = stablehlo.constant dense<1.000000e+00> : tensor<f16>
    %5 = stablehlo.broadcast_in_dim %4, dims = [] : (tensor<f16>) -> tensor<20x30xf16>
    %6 = stablehlo.divide %5, %3 : tensor<20x30xf16>
    %7 = stablehlo.custom_call @check.eq(%6, %1) : (tensor<20x30xf16>, tensor<20x30xf16>) -> tensor<i1>
    return %7 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xf16> {
    %0 = stablehlo.constant dense<"0xAABA79B449C3374168ADE741FA44E944EF376B3C5EC194BACDC18236C23FB7BF7BBA4FC35F3D034682BCE6C8333C8441C33CCF4478AF2F42E53962364EC41FB7DCBFBAC6B8B4ED3705C444C0AD3AE02B32417844EDC0B6BF9EC7003E84391D423BB7B0B6D7C0C0C102BF253DF8464F421E44D93C51C4E63F873BB8C61F3E03B9BB401DBD08C0C94852C5A6C1E2C4ED411FC22A45FEC01BC1FABF3D3EEE43F7BD3DC2C2AEEA3F68BA4EBF303EC3A5AC3DC6BFED3673BBB4C55EB97E38853CC0B6223D90C087BE673C42C30DC090331BB2F343B0C2693E07C4C43C38B82936EEC4B7C0D2B160C032C20D433D37C943F23960BC5B41FD3F90BF64426FBEF64022C41CBDD7411E402EC48FC53BC3F643493CF2C30DBA9C40803EE83C213DB04010C196437A456041823D9F44E1B9AD482445DB4523BC76BE1B40503BC7C7D3C66AB7D9BE80BCB84306416CBC984199BD05C5E43F60B79FC1044005453D43F7C683BC573FA1449143834247C41E48FA3D54B4CB40163C5CBEC1C031BB3E3E2CC098ABD2C0A23E233AEB3FBDC3B73F9940E8BC04C4853F3138BEBFA63FA74493BD4B28A542CCBEB2BC84C13EC1C03F33B82DC077B80A4039BA964184397A3CB341B33F87BF59BCD9C44341F0C039BFD7BD41421F35C23C883D82B959C4E3C38FB26A3D233E702878BD0F427043B73E5938ACBA013F78C536C434C52647B63F124082436EB2DDC4A34552B4F334BA4040441BC1A140D0B41AB91DB875B233BED1BCCDC140C06B45D1AC5141F2B9703FE43D8635394548BC183B223C493EC1375AB4A1406A4133C53341B8434D410BC2953FE7364DB7AF31E2BDD6C3543C8A44E1B713454C3AE439EF422640C8431BC1AA424034C2318840C6479B3E25C0C6C1DEC44B3D3A38BB3D7CC4EA34B63A7B405BBAFB3EC63BBB4133C34CBA35C258BE7DC62ABD0D436AC2A5C0DBBC83B5EF44C4C5E7C726BFC2C38ABABEBC723DB0C46FBFAC3DE9B8053EBCB5CABF91BEAAC535BEC7355E466746C434353AAEBFB1C2AB2F90C5AFC14F43594191C5EE3C033D3EC45CC11EC2D14435403ABFFABED1BA2CC578C673C4A23C16C05CB72C38EE3F053F0D40D8BCEE3A3DC3C2A99E39CCB696B67F45693FBBB0F638F2B88ABFFEBA27BDC4BA393B49C4C3424BB42B4129C2BA3DDA40D842F23EB23EB840BDC30F40483FF14352C35FC22DB51E3AC643024156C10CBA0B43D6B7C2B87CBD3A44AEC3C2C3F8C2803C7244D7BB1A3D6D437ABF02C1DB46BCC2893C46C3ACBA53C3083D4F383BC270C2964384B5E4C012C44CC48243A0BD8DBF6DC2044607C02D353F4632B61CC10CBCC644DDBA5BBD103E9941BCC1833876BA5AC5B4C6C1B92E4292C135435039093C7341E13A0CC5303C91429FC4E7C4553F4838E24058B83239264169BD653E08C2E0BBD645FCBD4F3C87342D45BBC118B648BA8EC007C4324463B60ABDCBC1373DD9BFDEC539C1E4C4563E7D2898BA832F914105B6A736BA3947477B36103C323452B5783C044883BE053BBD4463BB38C14A45C640F5C522C0453D90C4443C35BD34BB26BF0DC4A6C1534367C0D2BB2EC75EAD0F34863F9AC482BEC34331C52BBB5F41562EEFC0B4BFAEB6703DF9B818424BBF3DB6CB431FC6A8B82F3453414A42DA405E38A140E6B8F93F513E6CB10D46E042A0C036C283C2A5453535F240"> : tensor<20x30xf16>
    return %0 : tensor<20x30xf16>
  }
  func.func private @expected() -> tensor<20x30xf16> {
    %0 = stablehlo.constant dense<"0xEBBEBAD14DA5392B7BE6FB28272053201A48F0399FAA31BF3FA96F4B633076B086BF3FA59D36B61C97B95B94EA3A1B2ABE389B20EBE054280041E04B6CA2ABC938B0BA9AE0D01D48E2A399AEE23E326C4D2BBD2149AC77B0A298BE341B427B286BC9D9CA84AC63A9F3B186370D1A142855237E385FA22830CD3CBF9A773411C4D62CAAB7D1AFAC14CC9EAEA966A0EC2877A86F1F1DACB3AB09B038341C24D3B438A8A3E22230CBBF41B1533400FC9D355CB02A4AF4BC859D9FC2A5458C39A9CA923765AD5EB3003A5BA5B5AFBC5480D81424D9A6C633D7A3BB38D2C6614C47A0E3AC32D91DAE4FA8D82566495724E0401DBAAA2A0530BCB0D927AFB3322C42A3ADB72429552F04A3F69D6BA50F24823A15A49FC03A2D763356389637F92CE4ABB1243C1E992A213630210AC10315891F1A1D3DBB98B3662F3D3D5A98729A07C961B29EB974240A2CECB9D929D7B50CA02B301BC9C4A9E82F0C206625109A93B92E312921BA246A278BA25517CC3451D2A72C823BF6B3C4AC81BD36340DAFAEEC92AC05336E4020306CA47630452D56B8E8A3D230F4466AB094301621E9B57976FA2686B2F2B81BAA1BAB6630EAC608AFC1C5C62F40C0E0291B42B43989297C30CDB03BBA7EA0082B41AC70B124B53028A14FC0380D3621C23BA22DA443D773366E34DC7543B69A28FA24C4323B46E5BEF531439EDBA2459F9B197730982FD724B5D773A0B81D58D23950D92CAC22B3AB292D98D0B7C35BC79BD74CB495B83FA9ACAE6F1E95E8D12AE0C0FA300335144E301F87BABD3D423B2034644836D2292D732A4A9F4A2B7424E12AA4A8B2303A4A43C9945908B541A4513A792130C8D71F1A40034125262C2F5924B3ABEB26AC525D59802D5C181B3331AF52A971A0E836C8467135ADA15150C73EB12DFABF06325C3C71297DA51AC048A803B4809B6FB7D825C4A71BAD79B81ECE4320579D26989BB163A454BFCDB85736F9A0FCB09D3553C4B1346FCD56B03BB3A29D48B44F4DF01BCD1BBB50484086B0D5A68B60F39D94A93F25B32AF09D47381138B4A2A8AA79A89520DF2E6EB107B277BE669F909BD0A1263982AF24C90D471C30EB31B52F81B8283E66A55DF1C74186CA2BCB2B1E0931D6DC32443CC4C8B0FDBD7DB79DBE703D82A29F267AD26C2B61A874357C2C64261D32D432E02C6CA4AA2F4D31172439A5EAA763CF79405C24142CBEAAA2C0DD2541C8C0C435B6C82286A463A40DA69E39D42140BCB7370025E6B014AC5B1AB6A67E3953A5E5BE36A5053866463CA8ADA7B1241BCE60AC98A373A2D724C1B5C2B0B9A7B41CD7AF634F341C4FCCADABBABBB52056BEAAB69934D7296FA9934598BFAF9ECC9A61C15728ECA97925D542CB3B552A4B3EF89FF93A3B2730A159A033318746662C3EC64D43822B77B6D533ABA832BC271DC7B4663A8451631F71A987CC22C06BADD7A3F022DDCB01B845A939373DB0129D30AB60A00734AA7526BFD560F029B1CCF64A74415019864BA43BF052CCCEBD39E8176AB3EB3DD02015BD34ABED1EB52CD79C42AF003765A1993A42B77BBD9BB1B5A3AEA9362500AE48BC88999FE6AA53CF3041A16FB36124529F90BD9D2A076443AC7BB0DFCA5F362AC4872847B138CC5424779C12C5FF52C92A1E287C2C2546292D5BC40B3010346DDA9F1C4E262DAD47A86AA7B11D424F3C2C"> : tensor<20x30xf16>
    return %0 : tensor<20x30xf16>
  }
}