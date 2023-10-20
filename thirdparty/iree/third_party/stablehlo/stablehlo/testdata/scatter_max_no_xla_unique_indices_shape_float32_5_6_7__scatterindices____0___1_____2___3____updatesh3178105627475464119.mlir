// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<5x2x2x7xf32>)
    %2 = call @expected() : () -> tensor<5x6x7xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf32>, tensor<2x2x1xi32>, tensor<5x2x2x7xf32>) -> tensor<5x6x7xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32>, tensor<5x2x2x7xf32>) {
    %0 = stablehlo.constant dense<"0x2B516E3FC29C653EA3D830C025210940AD86F63F97711FC0800D61C047528F3FE6DE9BC00C28CEBF0ADF9BBFCF5A3AC0A97F3D3F0E36703E2049A2C0B549C43BA88BE73EF3CF8CC0FF0F34BF6C5AAC3F307F39C0782A38BF7C9BB540BCFEA24032E92A3F15661240C3709A40EB4712C04C06A33F0844D53FE33104C022B1B03F4B991D402E490A3FDA60C53F3A6754402CE8A53E9E4B414023BBBDBDF17D18C0B6EE0FC065DED9BE94799ABE43543CBF1F8360BD6E13684007EA1E402D42C7BF867DA740759135C0E6420340B605A2400465BE40A5089640A098B3BF92A8F83F595D35C008AA33BF6093F73EA27A4E40B90737BFF45EC6C0089438BD488E613EE5B6C73F499877BE229EB4C065A468BF634F473F6C4E6440B68BB7C07A244940CD0C37C06C2372BECE4415C0A276173FC97ED43E0BA300C01D450F408FD4DBBF172E0740F1949BBE0A3D10C0305B80C09C840240945E4F4061DD3C40EED85B3E0B9AD4BF486915C00AB299BD08B3034089E6783F990D2D4042963ABFAA315A40E062E5BF8413693EC2CBC63E45A67240A071434073E600404D273B409549CBC04D4C67405FFB03400D91043F84AD913FFCF9FF405A877140C466BBBFEF94994033B40C40339252C022FC603FAFE6AF40D0954C3E203C9B404F18813F69BB86C0470692BFCF85303E814E63C0201F47C00F78D540EB75D4BF48C3A7BF8BF47EBF6931F3BF1AAE55C0A32F13C04DECC0C04CAA674010EE26BF8D9998BC545709BF894A3CBEC1B50F4080631CC0F00049C004538240CA01EFBF85FCD23EC38435C098F0BD3ED8339C40FD5833C06F4971404940B9C0C295F23FE8AEE13FEA459240EF93DD3F51C34DC070671FBF11A6CE3E2AD28DBFFB8231C0296DCFBF90F1A73F62FC1CC01202A1C06EC29BC031B75B408AAE9A3FE8B552402DAC8D3FEDC91C4032B3C7BFF2081CBF85CBD03FC7B5DABE963D4F3ED8B90040C04E643FB64776C08B5E9EBE96E6C6BFB50DE6BFF27A273F3BB46FC07D7F8EC0AA98DB401E1EADC047FEA43F962D8C40AE7FC5BE2B8E52BF1D5F4940D387934016D576C00645053FE7C947BE3618A5BF542680BFEBBD16402E4F51C0BB259BBF4A6CAEC04FF22A4083D5604076FDF3BF25B1C4404997054025590240E27992C03A54D0BF22AD66C027478FC04EC2833E"> : tensor<5x6x7xf32>
    %1 = stablehlo.constant dense<"0x5C49E33E8C2398BFA3F98A404AC5DCBFEAB1E2BFF8D539406F6E8640DDD120C059AD613D1205434063F39D3D731A0A402ED234BF0E82993FC35FA63FA9D283C0AD9E663FEAC096C06BD556BCC66CE23F29B157BF6FAD42BFB959AFBE3384843F238C203FAD039EC0634E2340B31497BF8EC6C2C078DB043FA50920C05F7A93BFBF381BBF89B382BFC0D89FBF193E37C0A05E0AC0309C1AC0FBFD113F314CAEC0D697B13F89BE6740A8D56E4010CC073FBB8F3C40F2329D4010AD973D27468D3F8A90823EBC513240BB538C3F4A1A914060564E403D404AC0B13A86BF7092CFBFD38FDA3F0833D0BF3EF13EC051B581405A3AB74071BE1640106784BFAAEE10C080703F403D5544BF688452BFCEC73CBEA1D50CC08281BABF0338A3BE5E1D9D40239142BF8DA52FBE7E73D2C0BCA281BE1C01F13F5837A33F44AC7BC0B08BC4C06D6D46BE8FF7AB3F80CA173F55754FBE81D5AF3FDAFC4DC0D8F43AC0C2D40540826587BFE34F8CC03635CE3FE1DEB040D5B92840273275C0C35F5AC0C691ADBFE3247C4007AF5D40077BDF3F37B32B40E2EF0AC092580D40798409C0682BCBBE865C203F2DFA66C085A563C067C2793F2EC33E3F7266B2BF815932C0C3788EC0F69FAAC0D8E8ACBF222005C046DF8DC088854540CCA62AC0BE5009401611AC405B27B7BF20B3953F4E5BCB40D78EC1BF4D4827BE1942E5BEC4AC83BF57BA0CC08E359AC01F25B4BF00A303401BA66CBD7B1F06C15130A63FEBD18FC088A888C0AD2A633F8768CA40DC1BC9BFAA816E3F"> : tensor<5x2x2x7xf32>
    return %0, %1 : tensor<5x6x7xf32>, tensor<5x2x2x7xf32>
  }
  func.func private @expected() -> tensor<5x6x7xf32> {
    %0 = stablehlo.constant dense<"0x2B516E3FC29C653EA3F98A4025210940AD86F63FF8D539406F6E864047528F3F59AD613D1205434063F39D3D731A0A40A97F3D3F0E82993FC35FA63FB549C43BAD9E663FF3CF8CC06BD556BCC66CE23F29B157BF782A38BF7C9BB540BCFEA24032E92A3F15661240C3709A40B31497BF4C06A33F0844D53FE33104C022B1B03F4B991D402E490A3FDA60C53F3A6754402CE8A53E9E4B414023BBBDBDF17D18C0B6EE0FC065DED9BE94799ABE78DB043F1F8360BD6E13684007EA1E4089B382BF867DA740759135C0E6420340B605A2400465BE40A5089640D697B13F89BE6740A8D56E4010CC073FBB8F3C40F2329D4010AD973D27468D3F8A90823EBC513240E5B6C73F4A1A914060564E4065A468BF634F473F6C4E6440B68BB7C07A244940CD0C37C06C2372BECE4415C0A276173FC97ED43E0BA300C01D450F408FD4DBBF172E0740F1949BBE0A3D10C0305B80C09C840240945E4F4061DD3C4051B581405A3AB74071BE16400AB299BD08B3034080703F40990D2D4042963ABFAA315A40E062E5BF8413693EC2CBC63E5E1D9D40A071434073E600404D273B40BCA281BE4D4C67405FFB03400D91043F84AD913FFCF9FF405A87714080CA173FEF94994033B40C40339252C022FC603FAFE6AF40D0954C3E203C9B404F18813F69BB86C0470692BFCF85303E814E63C0201F47C00F78D540EB75D4BF81D5AF3F8BF47EBF6931F3BFC2D40540826587BFE34F8CC04CAA6740E1DEB040D5B92840545709BF894A3CBEC1B50F40E3247C4007AF5D400453824037B32B4085FCD23E92580D4098F0BD3ED8339C40865C203F6F49714085A563C0C295F23FE8AEE13FEA459240EF93DD3F51C34DC070671FBF11A6CE3E2AD28DBFFB8231C0296DCFBF90F1A73F62FC1CC01202A1C06EC29BC031B75B408AAE9A3FE8B552402DAC8D3FEDC91C4032B3C7BFF2081CBF85CBD03FC7B5DABE88854540D8B90040BE5009401611AC408B5E9EBE20B3953F4E5BCB40F27A273F4D4827BE1942E5BEAA98DB4057BA0CC047FEA43F962D8C4000A303401BA66CBD1D5F4940D387934016D576C00645053FAD2A633F8768CA40542680BFEBBD16402E4F51C0BB259BBF4A6CAEC04FF22A4083D5604076FDF3BF25B1C4404997054025590240E27992C03A54D0BF22AD66C027478FC04EC2833E"> : tensor<5x6x7xf32>
    return %0 : tensor<5x6x7xf32>
  }
}

