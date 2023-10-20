// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xf16>, tensor<3x5x2xf16>)
    %2 = call @expected() : () -> tensor<3x5x40xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xf16>, tensor<2x1xi32>, tensor<3x5x2xf16>) -> tensor<3x5x40xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xf16>, tensor<3x5x40xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xf16>, tensor<3x5x2xf16>) {
    %0 = stablehlo.constant dense<"0xBD4100C171BF66C192B62A3830C5B6B9AA428E3625AB50BCD83A6341CA44DA32543E0BBC79C1B13B24BFC3AD92367D405EBCFDC2643D03C53C309444DEC02742ADBB404189C5CD3F9B3CAB3D7435B9B063C453390F3A3EC14CC59FC2013DBB36A92398C2C2BC0544213F85C323C199C115BAF6C188C58D3CC0C7A2493037D2BD84C34E4425C10332E0BEB84132395D3B45C78AC29DC3B6BF9644AEBCA5BC8A42E7B3C63A2E415BC6EEC2F641A3C1333C57C3C84014BC113A14C43D4833C6FA3D02C2B940603150BDF1AC45BC434098BE1BBE9F441B476BC452C488BC27456C45CBBA01BC663D433BD5C7CD2FF73D78C03A3879BBEB44FCC5E33F67403D3E3B3C5748B44016452945C24217BDFDC272C2374282C359C27B3BDAC025B523430B408BBE93C5C32D79B351C20BBDE640E4BB0F427FBCB242C0BA81C39AC2E24384BF69BFEFC8E3BC16C077BC773CBC3F0DC17AC0CA3AEEB8FC3C73400640912E0E3E45C09143553DC7BF1E41F32FC1B965BE04BE0CBA7F4096C6E1BB893938AA30BE543920C59AC18A3F56BE6F431CBE434501BF663E38C41B41B13FA9BEB0C4F1B8BABE94C01CBD324069B11EB30AC40E3AA8B883441DC0E8C0B537983A8F3EE6BB60BEACBB6F430CC470449B3C0441B9C15644A4C5B2401B407CBF1CC6673FC52546BD4B38754601B78E449EBF60C56A4083C5B7C08839E2391640B4BB529EBE381AC16B41C8C42D40A63EE2C0D4BD1C40CB40B848D1B572442F3F98426DBC81C47C2DC13FACC121C044B04E3F83B5CFC247C76B43C4C12041F7408FC2EFC15EC44A3C2445B3C14C44D3BFFC444B41A3BC80BB94BC6139EFBF73C04B44CCC3E0C03DBBD6C02DB0F242C930553942AF263EBF35D146F9BBD546AABFB0BC3640D8C24AC46CB1E242DEB9163FDC443E44963A16C667C497C1B2BD383DF6C354360BB89BB9D541BB40ADC4F8401F417CC37FC4DE4101316442563ECD41E238E7BCFF443B37173824BE1044FF4251C4C0C3E83AF3C4AABB2F3FB1BFB6BF58B88A2C41457830952994C76CC2AA2F08C4E9C3B83868BD75C1343DC8386F3B184152B42F4474C332BD622E483C2F40B63ED8C40E41AB415540043986BC334452BD5F3E57B54D43033F7CB8F2B5D3B934C2B6BBBCC47DC0AAB74FBF27ACC93AD1B878C7154415C021451BB5D036D1B657419CC1FC3C70C29DBC6ABC4CB673C38843403C60454346A5A5B9C2E43BA8BB00C06FBA623C0241A540ED4492B8734015BB3BC478A54EBFA633343E89BE3E41463FC5C39AAC03402B3DA4BD97B19FB97CC223C016384AC2BF41B0416B3D5044DF402CC5F0C4B4C23E4067B7DC3CEF4014C1D64196431841DEB15CBC7A385B43B93B4E455141B6418141443D1A3A6DC4F9C068BD6D4183C387444743D9471AC23EC828419B3C723F3ABDAA3D1E44D6C18C3848B5A6C2AD2DD34111C28EBC4639C3C054C47C44403099C15445E944F43C8544DA2C173894B9E1C6FC3D92B0BB3E4E40F045B33F98C488C07D3D59BB3A3E60456A3C5A354DAC983AF54484C0E4BD0DBEC842AFBD83BC89C686C6E545DB3A093085310DB0AE3D63453441C6BF81C7C53C53326BB6A2C15DC47540443E07BF6EBA43C251C39443453FB73EC640273EE83E8E2FAAB0E93F2D365E45D93FB940B13D53C6B64177BF44C26B3E40453EC16DBD22C5CEBE"> : tensor<3x5x40xf16>
    %1 = stablehlo.constant dense<[[[4.562500e+00, -2.307130e-01], [1.515630e+00, 6.015630e-01], [-8.085930e-01, -6.613280e+00], [8.664060e+00, -4.285160e+00], [-2.695310e+00, 9.453120e-01]], [[-8.781250e+00, 2.552730e+00], [-2.091060e-01, 8.374020e-01], [-5.687500e+00, -1.705080e+00], [-4.772950e-01, -8.095700e-01], [-2.123050e+00, 1.617190e+00]], [[4.082030e+00, 2.714840e+00], [-3.349610e+00, 7.796880e+00], [5.913090e-01, 2.232420e+00], [-1.041990e+00, -1.708980e+00], [-2.041020e+00, -6.167960e+00]]]> : tensor<3x5x2xf16>
    return %0, %1 : tensor<3x5x40xf16>, tensor<3x5x2xf16>
  }
  func.func private @expected() -> tensor<3x5x40xf16> {
    %0 = stablehlo.constant dense<"0xBD41543F71BF66C192B62A3830C5B6B9AA428E3625AB50BCD83A6341CA44DA32543E0BBC79C1B13B24BFC3AD92367D405EBCFDC2643D03C53C309444DEC02742ADBB404189C5CD3F9B3CAB3D7435B9B063C491410F3A3EC14CC59FC2013DBB36A92398C2C2BC0544213F85C323C199C115BAF6C188C58D3CC0C7A2493037D2BD84C34E4425C10332E0BEB84132395D3B45C78AC29DC3B6BF9644AEBCA5BC8A42E7B393C62E415BC6EEC2F641A3C1333C57C3C84014BC113A14C43D4833C6FA3D02C2B940603150BDF1AC45BC434098BE1BBE9F441B476BC452C488BC27456C45CBBA01BC663D433BD5C7CD2FF73D78C03A38E442EB44FCC5E33F67403D3E3B3C5748B44016452945C24217BDFDC272C2374282C359C27B3BDAC025B523430B408BBE93C5C32D79B351C20BBDE640E4BB0F427FBCB242C0BA81C39AC2E24384BF69BFCFC9E3BC16C077BC773CBC3F0DC17AC0CA3AEEB8FC3C73400640912E0E3E45C09143553DC7BF1E41F32FC1B965BE04BE0CBA7F4096C6E1BB893938AA30BE543920C59AC18A3F56BE6F431CBE434501BFA0C438C41B41B13FA9BEB0C4F1B8BABE94C01CBD324069B11EB30AC40E3AA8B883441DC0E8C0B537983A8F3EE6BB60BEACBB6F430CC470449B3C0441B9C15644A4C5B2401B407CBF1CC6673FC52546BDA93C754601B78E449EBF60C56A4083C5B7C08839E2391640B4BB529EBE381AC16B41C8C42D40A63EE2C0D4BD1C40CB40B848D1B572442F3F98426DBC81C47C2DC13FACC121C044B04E3F83B5CFC247C75EC3C4C12041F7408FC2EFC15EC44A3C2445B3C14C44D3BFFC444B41A3BC80BB94BC6139EFBF73C04B44CCC3E0C03DBBD6C02DB0F242C930553942AF263EBF35D146F9BBD546AABFB0BC3640D8C24AC4D3BDE242DEB9163FDC443E44963A16C667C497C1B2BD383DF6C354360BB89BB9D541BB40ADC4F8401F417CC37FC4DE4101316442563ECD41E238E7BCFF443B37173824BE1044FF4251C4C0C3E83AF3C4DCBD2F3FB1BFB6BF58B88A2C41457830952994C76CC2AA2F08C4E9C3B83868BD75C1343DC8386F3B184152B42F4474C332BD622E483C2F40B63ED8C40E41AB415540043986BC334452BD5F3E57B54D4346487CB8F2B5D3B934C2B6BBBCC47DC0AAB74FBF27ACC93AD1B878C7154415C021451BB5D036D1B657419CC1FC3C70C29DBC6ABC4CB673C38843403C60454346A5A5B9C2E43BA8BB00C06FBA623C0241C546ED4492B8734015BB3BC478A54EBFA633343E89BE3E41463FC5C39AAC03402B3DA4BD97B19FB97CC223C016384AC2BF41B0416B3D5044DF402CC5F0C4B4C23E4067B7DC3CEF4014C1D6419643184148415CBC7A385B43B93B4E455141B6418141443D1A3A6DC4F9C068BD6D4183C387444743D9471AC23EC828419B3C723F3ABDAA3D1E44D6C18C3848B5A6C2AD2DD34111C28EBC4639C3C054C47C4440308CC55445E944F43C8544DA2C173894B9E1C6FC3D92B0BB3E4E40F045B33F98C488C07D3D59BB3A3E60456A3C5A354DAC983AF54484C0E4BD0DBEC842AFBD83BC89C686C6E545DB3A093085310DB0AE3DA5C13441C6BF81C7C53C53326BB6A2C15DC47540443E07BF6EBA43C251C39443453FB73EC640273EE83E8E2FAAB0E93F2D365E45D93FB940B13D53C6B64177BF44C26B3E40453EC16DBD22C5CEBE"> : tensor<3x5x40xf16>
    return %0 : tensor<3x5x40xf16>
  }
}

