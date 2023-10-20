// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf32>
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0xC1078BBD9E502B403279F53F9833894084C69F3E97EF0BC0F9257540D28E08C0B31B4440687B3CBF787591BF888818403816E83DE8EE2F3F722A38BC509E3B3E82C0E93E9F4A52BFD3F1A2BF755DB8BF5D056D406F8D743F528BC33D47463BC01EC2A1BF521FE73FE5C464400C74F0BE5A31C74000411540456B14BDAD64F1BF9C40983F9C48C84077FF3FC021C32D3FB3F9A840B65EFABF036011C10D2B2FC0436872C08B29CABFCC6C5BBE07C01E4004FC8D3F2259D8BF5B7291406830423F88D40941946FD63F64F4074026EE2A4096D7FA3F96AF1EC08B030B405119F73F7F7650BF984C4C3EBF9EA53F62AB4140385ECFBF48E79040C3109A40EDD6EB3E9606BD3F8AC107C0DA3F4DC0FC3D9F3E06CC9240DE1683401804BF3E9865FFBD3B7E8A3E2DD701C15B698BC0712B3C40F27088BF876E19C0D2D704C0D6856940AB24C940F68AAA402B9A813F456639C0DE830340041E253FF24595BFB8732CC01B3E09C0392229C0148BE4BE6EB3F73FD76F8740CFFC543EF3E40F40C3574EC0DD67CD3F642D45BF277068BF67CCB6C00F0244BFEC339EBF7CAECC3F8A9D60C0E8EA33C07D94B23FED6B943FA9D3A4BF2EBE8C402B51534046537F403B4DF7BFBDF67340903339BF8BF4F4BFEFAB1BC06809D240F06593BFBC1D70C061BAA940B270533E0681CF40436B4FC0D672BDBFDF558B3F6B18BA40BAD8BD3FF29392BFE24AD7BE4E8355409FAEE0BE9E34443F19AC25C0E7D5F03F3BF8A5BFBC314D40EF4990BFA3D267401C96BDBE65A2943F04211E3E6D37B5C0D7E82DC0127F85C0F002823FE81E1B409C409C406F55734001DDDC3F71CFBCBF2466B1BF2DDBF1BE39A741403782ADBDBA5280BFA748C53D4BF96740AA9E13C097F5913FE5DEC5BE91E257BFDD23A3BE5D5E21C03B9492BF84509E3F73FF5AC0F6B3853F07CDE3BFC09D28C0E929C63F88F2673FC67EBB409B3D40C093B266C0669F56C07B48B5BFBF765EC059977AC052475CBE44AE8540564960BF632D94C08165604094AADAC004D2863FC604B5BF3862BCBD31845740EBD41EC045284DC042B484C05674BE3FC02C8EBEEB23C5BF6EEC5840CAEF0DC069E059C0B65D03404248A8C0752F87BF9EB202407C8DC13F09BA723F268DA8BF78AD1BC09F5B6CC02347A13FA6D0D8BE78C2CDBF3144BE3F8662A3C0554153C0210096BF0911BC3F246C3CBFF0A6E53FB9E44B3E3EA1FABC54B3913FF8D78CC0231CBD3F1486A0BFDAF76740180BA4C0A8E66540C5F9F73F43EB08C0F4AE28C01C188C402B5A95BF534A04C072C018C03A5F713F6A7EBE3F0A350C405EBE4FC0026366C097A6A0C02630783F46B6F7BF8516BF3F748C1F3FCBBEF7BFF8BAF1BF659CB2407D07B0C079575EC088A266BDE4D6244087B0CFBE1AFBA940AB410DBFE2AA4240B9FD763F5349E4BFBBA2E240D6836140EE7ADDBF9B5889BF29B387BF74D7B0BFD40A90C04930D93F2C08803F7AEC51C0CBA7523F94E4F23FAC58CCBFBBAA0040AC19D0C0F109773FA0868B404EBC2D403C62D1BF32F9D7BE33B683409BA3D3BF66CCB23F5987E3BF6CF934C072D4183F02A22340DF310040BD74E2BF638DA6BEF37517C02CAFB7BE6EC15DBF70131540EB95523FDF93B9BF1782B6404961DEC053508340A5868CC015EA7CC010A18440051B8EC0667D80C02A553CC0250CCD3F89840840151C21402D528BC04A400B40815BEC3E745A90404160A3403E6120C0F87DCD3F43907AC0117F8540DFD09E4009A9AA3F9B745140EC4653C0F04238BF6922FCBF47D4E9BFF6423EC0B2057DC00CEC8740303ACD3FC4F534406B134B408E04BB3F7C18893F21833A405A87B2C0B642E0BFD8903CBF8F253CC0FF234F40858A563F694B0540C4AC0AC06CF1D140A178CC3F5C7DE83F378F3FBFC4900840D6495840C82E0B403230A5400774E6BE68B944C022F618C0DBAB04C063AD6B403DAF4A3F46B38C3F31620D40C7F0444089A8F6BFD7D28F403C25AE3E322CAEBFD6FE1640A8B61940741B2A3FC1142C3F48133EC0D0A1563FD6A803C0DD90C1C01A3BDABEBBA70240735E6D3F2F8202401879E1BF469E9CBF6A2F6D40A07335C0F72939BF287ADA3F78F859C0E287E23F3DA7E2BF3B97E240A82FE83F5E20DABFD7F0DEBF4F6F3FC030B590BD6F8620C0B7A45EC0868E69C05313CFC04C36E2C0480BA6400D35C1BFFE7332C0DBADAC3F7ABA26C0D0D62A3F096B32BF0D518040D6BAF23F3D0B0DBF1CD68F3E"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
  func.func private @expected() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0xC1078BBD9E502B403279F53F9833894084C69F3E97EF0BC0F9257540D28E08C0B31B4440687B3CBF787591BF888818403816E83DE8EE2F3F722A38BC509E3B3E82C0E93E9F4A52BFD3F1A2BF755DB8BF5D056D406F8D743F528BC33D47463BC01EC2A1BF521FE73FE5C464400C74F0BE5A31C74000411540456B14BDAD64F1BF9C40983F9C48C84077FF3FC021C32D3FB3F9A840B65EFABF036011C10D2B2FC0436872C08B29CABFCC6C5BBE07C01E4004FC8D3F2259D8BF5B7291406830423F88D40941946FD63F64F4074026EE2A4096D7FA3F96AF1EC08B030B405119F73F7F7650BF984C4C3EBF9EA53F62AB4140385ECFBF48E79040C3109A40EDD6EB3E9606BD3F8AC107C0DA3F4DC0FC3D9F3E06CC9240DE1683401804BF3E9865FFBD3B7E8A3E2DD701C15B698BC0712B3C40F27088BF876E19C0D2D704C0D6856940AB24C940F68AAA402B9A813F456639C0DE830340041E253FF24595BFB8732CC01B3E09C0392229C0148BE4BE6EB3F73FD76F8740CFFC543EF3E40F40C3574EC0DD67CD3F642D45BF277068BF67CCB6C00F0244BFEC339EBF7CAECC3F8A9D60C0E8EA33C07D94B23FED6B943FA9D3A4BF2EBE8C402B51534046537F403B4DF7BFBDF67340903339BF8BF4F4BFEFAB1BC06809D240F06593BFBC1D70C061BAA940B270533E0681CF40436B4FC0D672BDBFDF558B3F6B18BA40BAD8BD3FF29392BFE24AD7BE4E8355409FAEE0BE9E34443F19AC25C0E7D5F03F3BF8A5BFBC314D40EF4990BFA3D267401C96BDBE65A2943F04211E3E6D37B5C0D7E82DC0127F85C0F002823FE81E1B409C409C406F55734001DDDC3F71CFBCBF2466B1BF2DDBF1BE39A741403782ADBDBA5280BFA748C53D4BF96740AA9E13C097F5913FE5DEC5BE91E257BFDD23A3BE5D5E21C03B9492BF84509E3F73FF5AC0F6B3853F07CDE3BFC09D28C0E929C63F88F2673FC67EBB409B3D40C093B266C0669F56C07B48B5BFBF765EC059977AC052475CBE44AE8540564960BF632D94C08165604094AADAC004D2863FC604B5BF3862BCBD31845740EBD41EC045284DC042B484C05674BE3FC02C8EBEEB23C5BF6EEC5840CAEF0DC069E059C0B65D03404248A8C0752F87BF9EB202407C8DC13F09BA723F268DA8BF78AD1BC09F5B6CC02347A13FA6D0D8BE78C2CDBF3144BE3F8662A3C0554153C0210096BF0911BC3F246C3CBFF0A6E53FB9E44B3E3EA1FABC54B3913FF8D78CC0231CBD3F1486A0BFDAF76740180BA4C0A8E66540C5F9F73F43EB08C0F4AE28C01C188C402B5A95BF534A04C072C018C03A5F713F6A7EBE3F0A350C405EBE4FC0026366C097A6A0C02630783F46B6F7BF8516BF3F748C1F3FCBBEF7BFF8BAF1BF659CB2407D07B0C079575EC088A266BDE4D6244087B0CFBE1AFBA940AB410DBFE2AA4240B9FD763F5349E4BFBBA2E240D6836140EE7ADDBF9B5889BF29B387BF74D7B0BFD40A90C04930D93F2C08803F7AEC51C0CBA7523F94E4F23FAC58CCBFBBAA0040AC19D0C0F109773FA0868B404EBC2D403C62D1BF32F9D7BE33B683409BA3D3BF66CCB23F5987E3BF6CF934C072D4183F02A22340DF310040BD74E2BF638DA6BEF37517C02CAFB7BE6EC15DBF70131540EB95523FDF93B9BF1782B6404961DEC053508340A5868CC015EA7CC010A18440051B8EC0667D80C02A553CC0250CCD3F89840840151C21402D528BC04A400B40815BEC3E745A90404160A3403E6120C0F87DCD3F43907AC0117F8540DFD09E4009A9AA3F9B745140EC4653C0F04238BF6922FCBF47D4E9BFF6423EC0B2057DC00CEC8740303ACD3FC4F534406B134B408E04BB3F7C18893F21833A405A87B2C0B642E0BFD8903CBF8F253CC0FF234F40858A563F694B0540C4AC0AC06CF1D140A178CC3F5C7DE83F378F3FBFC4900840D6495840C82E0B403230A5400774E6BE68B944C022F618C0DBAB04C063AD6B403DAF4A3F46B38C3F31620D40C7F0444089A8F6BFD7D28F403C25AE3E322CAEBFD6FE1640A8B61940741B2A3FC1142C3F48133EC0D0A1563FD6A803C0DD90C1C01A3BDABEBBA70240735E6D3F2F8202401879E1BF469E9CBF6A2F6D40A07335C0F72939BF287ADA3F78F859C0E287E23F3DA7E2BF3B97E240A82FE83F5E20DABFD7F0DEBF4F6F3FC030B590BD6F8620C0B7A45EC0868E69C05313CFC04C36E2C0480BA6400D35C1BFFE7332C0DBADAC3F7ABA26C0D0D62A3F096B32BF0D518040D6BAF23F3D0B0DBF1CD68F3E"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
}
