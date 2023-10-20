// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xf32>, tensor<3x5x2xf32>)
    %2 = call @expected() : () -> tensor<3x5x40xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xf32>, tensor<2x1xi32>, tensor<3x5x2xf32>) -> tensor<3x5x40xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xf32>, tensor<3x5x40xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xf32>, tensor<3x5x2xf32>) {
    %0 = stablehlo.constant dense<"0xED2210C07C9C84BCE121E53F8F543C40E410A440D77E00C06C7F98C0C57024C0830C92402D08F73EF7EFAA4009B88C40807B1EC07C3756BF60D6D83F9C23293F07A9943E47FFA03F54D93140A3B68ABFE06B8F3E70ADA1BF4F931CC07D3C85400AEFC33FA9D9AC3EAE61684005A675C06A4A68406BA761405889ACC04B4AC8BF907322C0993D6FBF2DEB88C0542948C01CE353C0FA163A3F13984D40012F42BF38742A3E5E8CBEC0BE4BFAC0C5880240143567BE889D21410BDA5A4072159AC0508ECC40ED61543F72098240859016402DC43EC0A9277ABFDE6DF8BFBF4F93BFB5C214403ECB973FBB6282406B5068C0B79E8BC05D1412C0CEFE793E7CBEC8BFF274823E89F983BF5FC7C4C063703CBF96355640A41A11BF346D4D4050EA3DBE6A5C3DC080E3D93F057B4A40212742C0E5D3B9BE87E536C059090A3EA2364B3F597743405FD56EC03B4B0AC03B396A40BEF302BFE595713F962344BE079B00C0B6E242408FBFD2BE4F0BDABF5BDD07C11A75DC3FCA219DC08DAA63407781953F79973440D2F20340ADD117C009BC0FC08EFB26C0AE7B5640232CC33F714E2DC0F8ADA2BCCD3DA6BFC20CCBBE1F6C59409D6ECABEB53736C07D000F405F59BDC00DAD1FC059F96CBE765685BEE76871BFE9E73DC0391101C09C8FA7BED3C8C13EB9126AC07A63DAC06F534840A3BBCE3FA8EA6C3E284901C05ADFE6BD83150F403E78C53E80D46D40692A8C3F4F7E61C0083F6A409B02FCBF334A85C06FC97BBFE27BFBBC0977B43ED03D6E4046DEF63F498E433F5E44A3C0F07814C09990DEBF5FAC26BF398B3640EDAEE2BE1C6377C0240F3EC0E1FF5BC01548783FB5F3D8BEAD81CAC035162FC0AEEC35400B8AC3BDDB3B23C02528363F2163AD3ED5F3553FCEE31E3F874E5EBD64877DC053E188C0FC43BABFF09293BE3045AB401C2938C0933089BECB7EF53FEDC437404338CDBFEB661FBFB68FE83F16BB0840FAEB0FC04AD22DC034E71AC00F0D623F1DF862BF52FE5740E0C23DBE2E129EBF700335C0318D97BC6AF69D405E2930C0C9338EBEFA32DC3FB50557BE61F49840659ED6C0621F9C40BEBF7B3EA928BA3EE02CC1C099DEA83EC8A006C0D64BEE3FC8ED9A406875533FCD24543F6CA31E402D7114C015D05340E8D4CAC0404663C0A5CFFDBF09AA46403E545940A6B3AA40FCD6A93F5413AF40A0D589C0B3F5A740750995BFB046394006FD05406C34F03FC26D5D3FA8DA80BFA631014006B62F40BC9221C0A5E8D0BF5674A33F31F30440EA7949C049DC32402C940840DE8B13C0A35AAF40156C82C0AA8D9BC093D910C015692C3F9AFC8D3D62F5073E93833340DC397540D6979BC06344E03F9A3EA53FFDDB83405DAD743F79581C40B667C2BE7B668140D881634012B8EEBFDD5C243FC84AE2BF751668C0B13AD0C016881EC04AB59D40C8909CBDE89F0840E064E7BFCB80DA3FEF6338BFF3C22040D5C28E3FC54456C0FD1F2FC09A1D003F0C931C40B87DFBBC0C022A3F7C68E4C0BB4C47BF149240BF64655740CDF6A13FA0A3493E1550E13FAD7FF53FD978F73FCEBEC140B552F1BF3D88234097F6403B267065C09F938040B62F8B40EA6E5F401691C93F15F43340402F2EBF7B731D40501A8E405AC025C0B86DCB3F6E38C23FF182EDBF376A64BE1BC3473EAC360041825869C0010F433EA764CC40ED8D61C0E38CDE3FAB5125400EB5BD40E1D328BF04442440345F19C0F2E2F03FDF7F73C05ABCB5BED526693F95A102C0F5A02F40FA22F3BF88E85EC05C23DDC04BD318C0CA0BE63F6761B7C025723E40484DAC3F53F080C0FF20443FFEB14640637D43BE5282D14047289F3CC65C37BF00C6B340E6432FC0FD9C8140D5B91BC0F46578C0EEAF564023F760C0E8DABAC0879A26405342BE3F99BA274066FA2AC074BD8EBFA25B15C03F245DC07662513FD7EB6DC0517B57BFCDF856C05C8ACE3EBBD7104178B801BF64BB18404454AEBE1AA912BF7D022240F030AD40C6BE75C02D5860BF4AB6343FF134F63DEC6B56C0D2293240D9F146BF4F80EDBFE76221BF714B57BFDBDE77BF352985C06F41C6BF2D04AE3F7F299B40FDD59840012A334005EA4AC0F8998AC01852694012114C40CE5B74C02D853ABE8A3779BF1BA87FC0CA40383F49B131BED569273F2F95EF3D645C49C0B2D2C5BCB461744088CBD8BB975D834026358040CD64EE3EC831A64022CBCEBF7884584095FADD3F57D852C0E5DFB93D7C369BC048A19CC0392D6E3FC4009B3D5E0106C0AB3E4EC0A8AD8BBF31E63EC084901FC01B94AAC0EBB466407DFA44405505483F383DDFBF99307FC0DE0324BE67F0F9BF62496EC039563B4051A71ABF464F8940BF6B3440C28E323DE27599BF1D402A40E9F1933FB4AB64BF362FD1C0129722405C77014018AB7B40FCECA7BF397563C01C1F2DC0158B61C0155D9340DF984EBF4394F0BE8964B9BF50E347C04E38B1401813B33E9306D6BFE129DC3F71CE8040AEB892C0DF466CC0511796BF657E20C09F338B401F779D402581C0C02D504BC0381C8CBE28614540D56E4CC013B0D7BF7727E9BEB9471F3FFD94C8BF1FC0B93EB2A150BE7E9B113F7B20233F873AF2C0393225BF3FA4DC3FB3119D3FAA703E3F955055C049E033BFF18D563F245C554050CF26C049A839C0D5BA1F3F798A89C0A4C2FFBDDA62B3C0A6B88340BEA69DC08B9831C01AEC6440484D123F64671AC06079B7C07C7EF03F93078CBF6708BD3FA5031DC029D81F407E1B5DBF77241140913C2440B3AC10BFCC93904092BA173F7D5E2A40F0BB0740930077BFDBBE0E40A7260E3E742C1D40DF7A0EC069DEFBBFF2E0673F2E21B8C0B42ED5C09324E73F934A62C0C34292C04BBDAE3E0DFC82404313E53E8C6FBABF107730C0BC79A23F56DEE8BF55134F4099FA2EC0F0A5A7BD1587C2BFA13F16402BF3EEBF4E925FBF9A0CBE40CFE525403BD31FC08C9B64C076F4C1BFFC3C41C058C35EBF42060E4050D86640B25B09C07437E1BFBB52F43E8F444740D484F63FA612C7BCC404A23F3B6A14C056AEF9C0EA7B0A406FB684402FABDC3F8B0C9B406FF251C0C78FAB40D1C1A4C001AA79C02351BC402927D5C08FCF0C3F788FABBD48E800C0C3C80B40160AABBE8CD0B33FE9C2E5BF88561B40D988ED3F48AEBD407C96BFBF3BB13ABE3C2814BE712BA7C005D59BBF4316BFC0F27E5D404B912F4048F73D3FE8EF3C3E63C3D8BF240C7FC01C9525405B4C9740DA357EC006AB66C053D3BFC085C4FC3EDADCC2C0A04B12404287174030AB893E5A5A1A40D3F4D3C0FA4C8BBD55AFCC40CED17F409DE401C0E7FDDE404CEFDDBFF049DBBE60551740E8D5ED3F6974E43F06E9CABF75DE1A40D97975BF984709BF27534140"> : tensor<3x5x40xf32>
    %1 = stablehlo.constant dense<[[[-4.1530757, -2.58221698], [1.6436317, -0.419511139], [-2.9442091, 1.4445678], [0.530891776, 4.13116598], [0.0613817051, -2.62803793]], [[-0.517536759, -2.76364732], [0.855332791, 7.18701744], [1.38369524, 1.61846113], [-2.5401454, 0.198725045], [-4.24050856, 3.25779605]], [[-0.772477567, 6.01819801], [-1.89968467, -2.01155281], [-0.380083561, -4.75117922], [2.866420e+00, -5.88117266], [-1.40849066, -2.67970443]]]> : tensor<3x5x2xf32>
    return %0, %1 : tensor<3x5x40xf32>, tensor<3x5x2xf32>
  }
  func.func private @expected() -> tensor<3x5x40xf32> {
    %0 = stablehlo.constant dense<"0xED2210C0FFE584C0E121E53F8F543C40E410A440D77E00C06C7F98C0C57024C0830C92402D08F73EF7EFAA4009B88C40807B1EC07C3756BF60D6D83F9C23293F07A9943E47FFA03F54D93140A3B68ABFE06B8F3E70ADA1BF4F931CC07D3C85400AEFC33FA9D9AC3EAE61684005A675C06A4A68406BA761405889ACC04B4AC8BF907322C0993D6FBF2DEB88C0542948C01CE353C0FA163A3F13984D40012F42BF38742A3E5E8CBEC0BE4BFAC0C5880240143567BE889D21410BDA5A4072159AC0508ECC40ED61543F72098240859016402DC43EC0A9277ABFDE6DF8BFBF4F93BFB5C214403ECB973FBB6282406B5068C0B79E8BC05D1412C0CEFE793E7CBEC8BFF274823E89F983BF5FC7C4C063703CBF96355640A41A11BF346D4D4050EA3DBE6A5C3DC080E3D93F057B4A40212742C0E5D3B9BE87E536C059090A3EA2364B3F597743405FD56EC03B4B0AC03B396A40BEF302BFE595713F962344BE079B00C0B6E242408FBFD2BE4F0BDABF5BDD07C11A75DC3FCA219DC08DAA63407781953F79973440D2F20340ADD117C009BC0FC08EFB26C0AE7B5640232CC33F714E2DC0F8ADA2BCCD3DA6BFC20CCBBE1F6C59409D6ECABEB53736C07D000F405F59BDC00DAD1FC059F96CBE765685BEE76871BFE9E73DC0391101C09C8FA7BED3C8C13EB9126AC07A63DAC06F534840A3BBCE3FA8EA6C3E284901C05ADFE6BD83150F403E78C53E80D46D40692A8C3F4F7E61C0083F6A409B02FCBF334A85C06FC97BBFE27BFBBC0977B43ED03D6E4046DEF63F498E433F5E44A3C0F07814C09990DEBF5FAC26BF398B3640EDAEE2BE1C6377C0240F3EC0E1FF5BC01548783FB5F3D8BEAD81CAC035162FC0AEEC35400B8AC3BDDB3B23C02528363F2163AD3ED5F3553FCEE31E3FC63128C064877DC053E188C0FC43BABFF09293BE3045AB401C2938C0933089BECB7EF53FEDC437404338CDBFEB661FBFB68FE83F16BB0840FAEB0FC04AD22DC034E71AC00F0D623F1DF862BF52FE5740E0C23DBE2E129EBF700335C0318D97BC6AF69D405E2930C0C9338EBEFA32DC3FB50557BE61F49840659ED6C0621F9C40BEBF7B3EA928BA3EE02CC1C099DEA83EC8A006C0D64BEE3FC8ED9A406875533F99DF30C06CA31E402D7114C015D05340E8D4CAC0404663C0A5CFFDBF09AA46403E545940A6B3AA40FCD6A93F5413AF40A0D589C0B3F5A740750995BFB046394006FD05406C34F03FC26D5D3FA8DA80BFA631014006B62F40BC9221C0A5E8D0BF5674A33F31F30440EA7949C049DC32402C940840DE8B13C0A35AAF40156C82C0AA8D9BC093D910C015692C3F9AFC8D3D62F5073E93833340DC397540D6979BC017F75A3F9A3EA53FFDDB83405DAD743F79581C40B667C2BE7B668140D881634012B8EEBFDD5C243FC84AE2BF751668C0B13AD0C016881EC04AB59D40C8909CBDE89F0840E064E7BFCB80DA3FEF6338BFF3C22040D5C28E3FC54456C0FD1F2FC09A1D003F0C931C40B87DFBBC0C022A3F7C68E4C0BB4C47BF149240BF64655740CDF6A13FA0A3493E1550E13FAD7FF53FD978F73FCEBEC140B552F1BF3D88234097F6403B267065C09F938040B62F8B40EA6E5F401691C93F15F43340402F2EBF7B731D40501A8E405AC025C0B86DCB3F6E38C23FF182EDBF376A64BE1BC3473EAC360041825869C0010F433EA764CC40ED8D61C0E38CDE3FAB5125400EB5BD40E1D328BF04442440345F19C0F2E2F03FDF7F73C05ABCB5BED526693F95A102C0F5A02F40FA22F3BF88E85EC05C23DDC04BD318C0CA0BE63F6761B7C025723E40BE9122C053F080C0FF20443FFEB14640637D43BE5282D14047289F3CC65C37BF00C6B340E6432FC0FD9C8140D5B91BC0F46578C0EEAF564023F760C0E8DABAC0879A26405342BE3F99BA274066FA2AC074BD8EBFA25B15C03F245DC07662513FD7EB6DC0517B57BFCDF856C05C8ACE3EBBD7104178B801BF64BB18404454AEBE1AA912BF7D022240F030AD40C6BE75C02D5860BF4AB6343FF134F63DEC6B56C03FB287C0D9F146BF4F80EDBFE76221BF714B57BFDBDE77BF352985C06F41C6BF2D04AE3F7F299B40FDD59840012A334005EA4AC0F8998AC01852694012114C40CE5B74C02D853ABE8A3779BF1BA87FC0CA40383F49B131BED569273F2F95EF3D645C49C0B2D2C5BCB461744088CBD8BB975D834026358040CD64EE3EC831A64022CBCEBF7884584095FADD3F57D852C0E5DFB93D7C369BC048A19CC0392D6E3F17C145BF5E0106C0AB3E4EC0A8AD8BBF31E63EC084901FC01B94AAC0EBB466407DFA44405505483F383DDFBF99307FC0DE0324BE67F0F9BF62496EC039563B4051A71ABF464F8940BF6B3440C28E323DE27599BF1D402A40E9F1933FB4AB64BF362FD1C0129722405C77014018AB7B40FCECA7BF397563C01C1F2DC0158B61C0155D9340DF984EBF4394F0BE8964B9BF50E347C04E38B1401813B33E9306D6BF48BD00C071CE8040AEB892C0DF466CC0511796BF657E20C09F338B401F779D402581C0C02D504BC0381C8CBE28614540D56E4CC013B0D7BF7727E9BEB9471F3FFD94C8BF1FC0B93EB2A150BE7E9B113F7B20233F873AF2C0393225BF3FA4DC3FB3119D3FAA703E3F955055C049E033BFF18D563F245C554050CF26C049A839C0D5BA1F3F798A89C0A4C2FFBDDA62B3C0A6B88340BEA69DC08B9831C01AEC6440A90998C064671AC06079B7C07C7EF03F93078CBF6708BD3FA5031DC029D81F407E1B5DBF77241140913C2440B3AC10BFCC93904092BA173F7D5E2A40F0BB0740930077BFDBBE0E40A7260E3E742C1D40DF7A0EC069DEFBBFF2E0673F2E21B8C0B42ED5C09324E73F934A62C0C34292C04BBDAE3E0DFC82404313E53E8C6FBABF107730C0BC79A23F56DEE8BF55134F4099FA2EC0F0A5A7BD1587C2BFA13F16409132BCC04E925FBF9A0CBE40CFE525403BD31FC08C9B64C076F4C1BFFC3C41C058C35EBF42060E4050D86640B25B09C07437E1BFBB52F43E8F444740D484F63FA612C7BCC404A23F3B6A14C056AEF9C0EA7B0A406FB684402FABDC3F8B0C9B406FF251C0C78FAB40D1C1A4C001AA79C02351BC402927D5C08FCF0C3F788FABBD48E800C0C3C80B40160AABBE8CD0B33FE9C2E5BF88561B40D988ED3F48AEBD4047802BC03BB13ABE3C2814BE712BA7C005D59BBF4316BFC0F27E5D404B912F4048F73D3FE8EF3C3E63C3D8BF240C7FC01C9525405B4C9740DA357EC006AB66C053D3BFC085C4FC3EDADCC2C0A04B12404287174030AB893E5A5A1A40D3F4D3C0FA4C8BBD55AFCC40CED17F409DE401C0E7FDDE404CEFDDBFF049DBBE60551740E8D5ED3F6974E43F06E9CABF75DE1A40D97975BF984709BF27534140"> : tensor<3x5x40xf32>
    return %0 : tensor<3x5x40xf32>
  }
}

