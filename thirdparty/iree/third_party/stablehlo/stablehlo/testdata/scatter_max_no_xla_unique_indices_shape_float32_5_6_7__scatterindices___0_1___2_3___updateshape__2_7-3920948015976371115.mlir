// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<2x7xf32>)
    %2 = call @expected() : () -> tensor<5x6x7xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xf32>, tensor<2x2xi32>, tensor<2x7xf32>) -> tensor<5x6x7xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32>, tensor<2x7xf32>) {
    %0 = stablehlo.constant dense<"0xB59CA83F680C2C4047317540CB989CC008A52AC02EED58C097CDA0C010E21DBFA961EB3EDA1540406B39F83EF00A92BFF09278C069EB2D3FA8336940ACCEFCC0962B803EA97AC7BF56A81E40392A5EC0D4EDBD3F5C84B83FC5CA88C01B17D740A9EBEFBF4FC970BF00B591BF627700C02C996B405079673F53AE5ABF14490240146074C060C10DC07EE10440E5A3E93FB9440940DB7DAE3F85B3E83F92E3893F67EB25BE3431A93F998D64C0769102401B7B17C0F9EA44404EA318C0E3E6B23F62198040DE918C3FA1E06EC06A2247C0880C893EFB0653C0C3046DBF50F95540D7C414404B886D40A9B6D6BE1FA3F13E220E204051C31AC01A73D6BF8764A1C0BAF11BC0395B68BF0712A7400D6A8E406178AABF570F3840DA7E083F1B96043D75901A3F5AB528C0A32458BF98670B40CC28CC40F883FC3F9D0226BF4599B43F38118DBF639DD93E0CD6C13EE75374C0ED3F89BFAA8EF03FD13A3D3FF62B58C04A891AC0E63668406E78E5BE20D84640DF3FD93E5FA111BFF3F567C0F665AABFA01C1FBFEAA8D2BD1277E5BF50E9503FBC4FA840F8DFC13FC5EA073E4A115840C725ADC0580F87BF59BD52C02A72DD3FAD6A00C02C4A0B3F7E0AC3BFDDB7094095B0A3BF10DC97BF448A22BF4AAF4D3E5950F83F9EC9F1404B6C153FB4DAA6C0FFBCB3C0439D5340F0DEA2BF322702C088C7BF406B14BB3E8450A4C0B01588BFF80AF53FE82DA8BC8964AC406C458EC0CF97F6BF4450A2BE2E2291C05AAA9F3F3E2A60BEFB0B7140C822B93DA010BF3F2BB062BF4437FE3FD08A493EE9C4C9BF44B180BFE69245C05A2FCABEB8D6C7C0C881E4BF7D71B73F0CDF6BC097412EC067EBA4BF3A344040A395713EA7E7EB3F69508F3F9D16F43F11256EC0E6B98E40DDB3563EA9798AC0F10466C0F97C934011E5773F118050BF6777B03F022BD84051D00C40EB2FEDBFEE0E3A3FEE832EC0AA54F7BED72FA93F2547B5BF51176ABDDD02FA3E02E3DEBFC61147C01A319640977E53C08A3D0B40B0C80E3FEDB8BCBE6BD9B6C0CD064EC02CEC35C0ABF50ABF46692EC0568EEA3F2C2E28C03C68C6BFA1890A3F3E319A405A5DECC0069C56C0369123BF113557401DE5944087921AC1552D27BFBA2FA43F00C3CBBFB640A7BF51B2803F074AB240550625409CA91A3E1D77C440FEEAE4BE"> : tensor<5x6x7xf32>
    %1 = stablehlo.constant dense<[[-2.46657538, 0.164475068, -3.12703395, 1.9243387, -2.82240582, -5.9424367, 2.4130218], [0.984735369, 3.96251297, 7.608675, 2.8891449, -5.10137367, 3.84897447, -1.18369055]]> : tensor<2x7xf32>
    return %0, %1 : tensor<5x6x7xf32>, tensor<2x7xf32>
  }
  func.func private @expected() -> tensor<5x6x7xf32> {
    %0 = stablehlo.constant dense<"0xB59CA83F680C2C4047317540CB989CC008A52AC02EED58C097CDA0C010E21DBFA961EB3EDA154040BB50F63FF00A92BFF09278C0F36E1A40A8336940ACCEFCC0962B803EA97AC7BF56A81E40392A5EC0D4EDBD3F5C84B83FC5CA88C01B17D740A9EBEFBF4FC970BF00B591BF627700C02C996B405079673F53AE5ABF14490240146074C060C10DC07EE10440E5A3E93FB9440940DB7DAE3F85B3E83F92E3893F67EB25BE3431A93F998D64C0769102401B7B17C0F9EA44404EA318C0E3E6B23F62198040DE918C3FA1E06EC06A2247C0880C893EFB0653C0C3046DBF50F95540D7C414404B886D40A9B6D6BE1FA3F13E220E204051C31AC01A73D6BF8764A1C0BAF11BC0395B68BF0712A7400D6A8E406178AABF570F3840DA7E083F1B96043D75901A3F5AB528C0A32458BF98670B40CC28CC40F883FC3F9D0226BF4599B43F38118DBF639DD93E0CD6C13EE75374C0ED3F89BFAA8EF03FD13A3D3FF62B58C04A891AC0E63668406E78E5BE20D84640DF3FD93E5FA111BFF3F567C0F665AABFA01C1FBFEAA8D2BD1277E5BF50E9503FBC4FA840F8DFC13FC5EA073E4A115840C725ADC09E177C3FD0997D40447AF340C0E738402C4A0B3F99557640DDB7094095B0A3BF10DC97BF448A22BF4AAF4D3E5950F83F9EC9F1404B6C153FB4DAA6C0FFBCB3C0439D5340F0DEA2BF322702C088C7BF406B14BB3E8450A4C0B01588BFF80AF53FE82DA8BC8964AC406C458EC0CF97F6BF4450A2BE2E2291C05AAA9F3F3E2A60BEFB0B7140C822B93DA010BF3F2BB062BF4437FE3FD08A493EE9C4C9BF44B180BFE69245C05A2FCABEB8D6C7C0C881E4BF7D71B73F0CDF6BC097412EC067EBA4BF3A344040A395713EA7E7EB3F69508F3F9D16F43F11256EC0E6B98E40DDB3563EA9798AC0F10466C0F97C934011E5773F118050BF6777B03F022BD84051D00C40EB2FEDBFEE0E3A3FEE832EC0AA54F7BED72FA93F2547B5BF51176ABDDD02FA3E02E3DEBFC61147C01A319640977E53C08A3D0B40B0C80E3FEDB8BCBE6BD9B6C0CD064EC02CEC35C0ABF50ABF46692EC0568EEA3F2C2E28C03C68C6BFA1890A3F3E319A405A5DECC0069C56C0369123BF113557401DE5944087921AC1552D27BFBA2FA43F00C3CBBFB640A7BF51B2803F074AB240550625409CA91A3E1D77C440FEEAE4BE"> : tensor<5x6x7xf32>
    return %0 : tensor<5x6x7xf32>
  }
}

