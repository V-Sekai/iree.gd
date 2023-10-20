// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xcomplex<f32>>, tensor<3x3x4x5xcomplex<f32>>)
    %1 = call @expected() : () -> tensor<2x3x6x6xcomplex<f32>>
    %2 = stablehlo.real %0#0 : (tensor<2x3x9x10xcomplex<f32>>) -> tensor<2x3x9x10xf32>
    %3 = stablehlo.imag %0#0 : (tensor<2x3x9x10xcomplex<f32>>) -> tensor<2x3x9x10xf32>
    %4 = stablehlo.real %0#1 : (tensor<3x3x4x5xcomplex<f32>>) -> tensor<3x3x4x5xf32>
    %5 = stablehlo.imag %0#1 : (tensor<3x3x4x5xcomplex<f32>>) -> tensor<3x3x4x5xf32>
    %6 = stablehlo.add %2, %3 : tensor<2x3x9x10xf32>
    %7 = stablehlo.convolution(%6, %4) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) -> tensor<2x3x6x6xf32>
    %8 = stablehlo.subtract %5, %4 : tensor<3x3x4x5xf32>
    %9 = stablehlo.convolution(%2, %8) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) -> tensor<2x3x6x6xf32>
    %10 = stablehlo.add %4, %5 : tensor<3x3x4x5xf32>
    %11 = stablehlo.convolution(%3, %10) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) -> tensor<2x3x6x6xf32>
    %12 = stablehlo.subtract %7, %11 : tensor<2x3x6x6xf32>
    %13 = stablehlo.add %7, %9 : tensor<2x3x6x6xf32>
    %14 = stablehlo.complex %12, %13 : tensor<2x3x6x6xcomplex<f32>>
    %15 = stablehlo.custom_call @check.eq(%14, %1) : (tensor<2x3x6x6xcomplex<f32>>, tensor<2x3x6x6xcomplex<f32>>) -> tensor<i1>
    return %15 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xcomplex<f32>>, tensor<3x3x4x5xcomplex<f32>>) {
    %0 = stablehlo.constant dense<"0x7DB92D409B010840EE3EFFBF1EA2AFBF4C4443C062EB60C04C2BBA3F66C3C53F82E1B040D854A5BFF769ED3F228485BF425D7C3F33E5CCC01EED95C0450741408DA0B4C098CFE73F2A75BDBF263DAABE94F351BF2B0026BD72324EBFDBB190BFAC5A0540B868CA3F5B1EC13F284A8DBFA82723BFA665A43FB52B59BFFABAA4BF10F7973F5D80473F404D05C00369A440B3722C4075BC634002BDAB3F1CA65C3F29C1A33EFC27A9BFAAF979C0B36D813E21D7B83FF656A83F080A2D40A24B28C0BDDA8E3FC836903FF9EEC53F14BBD8C0096898BFEDB00BBF5F1A453EAB0F473DCB75F83F2A1E65C0F75E733FEFE22BC0F1430BC0232CD83F644AB4C088F33D400BFD4440B5366040564F894006716F40BAA9AEBD3DD35BC056292BC0231977BE1547B640DA1E33BF7D18BE3FCF8A49C0960A70BFB5F0B0BEE5550440F5D1763E08750ABFABCCA3BE25706240EE0AEA3FE28BD7BF76A81EC04385113E08F67240C26EE0BFEA6985C0CDFC81403DA6C83FDB54E7C09AE63540810DD33F20BD343F4A174DC062D6D1BF27611140FE89213F51CD8840850FD9BEFCA3373F3D8FB8BF57F06CBF374E6DBFC3A4B3BF40918740B540AA40E17021C0418859BF7E67193FDE0B924092B2083E7FC7BEBF66668D3F4C90593E38957CBFB7330D4033E9104191231A3FBCA161C03AF453C04A52E33FA7C68EBFCD0C23C0F2A38EC0D98665407366AD3F17503DC0A2221F3FAB8A434088407E3FA44EFE3F2E1349C095CF8E3F6445043EEE006AC065563540209104C0839845C01F86923E6A6B84BCBCC33CC0AD00FA3FBBA946C0E7D04BC0D7F45EC03D0D38BE05B1ED3E7DD7F8BF4AB56D40E6B620403141B0BE86BD0F4004E512C09C38A03E20D556C00FBF8FC030B506C0C90984BF850195BFD90514C07DC795403454C13EF84B4240D3FF8340544A244010DC813F66D67E3F17BC9DBF4A1782407E61AA40F6679E3FD683833DEAF10240E56FBBBF80D8E4BFFB66AF3F29A362C041DEB03FA11DE53E95AA173BC93E54C084E930406EA9783FC2714240F8A5543F2A7B30403B890E3FF7D4DEC016BD9F409D1BEBBFE2F1B43FB3925240C7312340A96D1BBFD66A02C088E344404CC524BF9FECA2BE84C552C04A3B64BE4BDFFDBF41694940042E523F6B8C97BE7736B7C0AE03863FDF6F7FBFB5ADDD3F3C5D45C09F1A95BF0DF6D83E7298DC3F8F34B440F4E524BF50FD813F620B03402571A9BF90C7AF404524B4400D719E3EA71B75BFB2440DC0C674A5BF86D7B43FB72F83C0DD9F52BFEDBCC3402429A2BF2E29303EEE09893E4EACB9BF49E6523FB5F2084068680C3F340B18C001BA754052159C3F8CF73F40FF9787C0A08E0441BAB07C40E23D063F8FFD30BFF26BE8BE9C541FC0131BB6C0104BF83F4E0817406C265A40AFBA7D3E66DBE23F986E64C0C684BF3F4BD8A63F27E4ACC05E7407C0E10760C048E72AC040C301C0B1BA2CC0D8D078BFA2AEF63F3539BD3E6EFF9E40EA990F40E72C9A401C85B1BE801F313F808E8D3F5E0124C0EF91FA3DE4F63CC076B26BC0E7B82240E7B287BE1733A73E71C05FC0D0F88A3F7E468DBF687CE4BFEE329A40CF3A444080E8F9BE35BAA7BF489115406ABAF4C0E45CE63F0D6E4BC024F002C032F7FDC016C071406C798D3FACAA76409E4FE83D7A9D9040E3B19140E3BA9BBFC2E199C0A569DEBF67C1A2BEFC854B40241CEBBFAF8C883F1B004AC046416E3E4BB8DDBD5A95FCC05A49ECBEB16B9E3F8C72BE3F802CB23F1A97A33E6FF0673E0C4B5640EC8A3540410ED540FFC102C098ED763F24AA5B3FF98DD8BFE1DBD6BFC8D1BCC091C3A33F117C263F963C0740FBC34AC07E53623DB3D2E9C0D2A4C63EA0BCAD3FD8E874C0AD2931C067B4C4BE412495C05A17A7BD2E4006402B9A47C026DF524030C5DB40DE75213FD87AA7401D881D40B3856240169E8A407E505F3F5AA40CC02C9486BE66FC5BBF0F259AC0B63489C01167103D8E93DCBF169E2BC0DDE60EBF9B0ACC4031BA74C025203C405D5E8F407E84C93F1CF0C7BFC679FE3F80EA24C09ADCA1403F370BC074B22F3FD5473FC034A75FC0AF0D0940C197F4C0912E0D40CD8CF1BE4A4C18408107ADBFBDFE813F83C243403CD3963FCBEDD240DD551EC0B1F6903E595669C077E0663F06F6843EF4FFD23F3FF160C031E2ADC04F5C62BF7D85233F106657BF42920FC011ADF1BF922BDCBE4AACFD3F78ABA540EDAEDF3F59A94D4075B87CBF6C029F3EF0E5DB3FEF8981BFE7959640EE45EF3FCBE8ECBE2ABFA83EB52953C02F3236BFD3258840E35E813F5AA6D53E83193AC01AB6EE3F73EA6CC077D1C64008D65540912D88BFA15929406844C33F5CE181C02154A3404F018A4055831EC07495B1C028E774BFE9CB6AC0BD8994BFDE56A7BFE20E0B40954244417B5F9C40A0DE9B407C261A40CF5BA9403CC9E1BEBE67FDBFA2039C40D17CE33F00AA54C0B5BD013F9428263F94757DBFCED99D402E3B4B40845FB33FC439FF3DBFA516BF6D6BA240F2BFCDBF33DB29BFD1DBAF40A5BBB740A57451C0FD11F13E27994FBEDD341F40449441C06DCA76BE729A8F40A327544035264340148AD03F6C26C83ECDC433402FE79040BC4150BF01AE8940DEB771BF1F5C983F14665DC083B2ACBF70A8ABC05F49593FAF1A6D3EC39093BFA46C36BF4CC6A0404C748E4049E71F40B0251C401136D8408D4CE93D094AFBBDB681CA3EBC33B440DA217DC0F8B594406B8D2CC00DB4613EF34903C0E2432C40C7EF5CBF7A157BBFEE5A8BBE79582CBE0F118EC0C063CD3FF2FFF1C062727E3E3724D4BFF932D8BF69B7DB3FD36633C06A8D89BEE8373B40C8A281C0BF647E40D1312DC0DED304C1AB816A40A5E917BF5C7F12C05F8E0DBFD75F9640012C3240B9BF18404EDC68BF1571683F3A1A22C0761406BF0EBAB9C0F1FAADC0A547A1BF6C20423FE5CBBABFE3877640F5BED8C06843FEBF7350914044CD20402AB612BFC92C39BF622966408E5F743E51DE80C0CC2E63404FC954C0D0F59E40B3321AC0E156F33D0591654014B29D4026B31CBF4E6B4240409C36BF9FF086BF584700C09443AE406688B8BF0592D33F2D304440CC82304045B3AEC012BA15BFCE968DC00EED1540017B983FEA12CBC07BB06C3E7F17C03F9AC03BC0C004793FA2FE03C0B0D83FC08B9B974076E727C094A3223F1162A83E0CAC9E3E57B19B3EB1F1F6BF5587554084429AC0941087402B9D193FA92138C00D6F1A3F043937BF6C1ECBBFCF4109C0E78EA23FA639B2BF4612823E901A223EAFE5A2BE4C5039C0D378134068AAAD3EAD2786C08ADF12409052203F41690A40593398BFF998B23DC3B36A3FF3FFCA3F0DA698C0463C2D40758223BF289E1E404CBA274018D3E1BE9935DAC04F27DB3F50481740B54CBFBF0A41CF3FFBF45A40BA42CB3E7B240CC00F12A7BFE14BBA4036D26140DE9677BDBDCA92403C1FE4BF200E83BFE1BC2B405E8A414014838B3F3DB6E340C0F9913F0E7B453F0E291B3F5D1B5DBFF2AFDDBF799780C03770CEC03D46053FD9E0994077D2D33F4D89F0BFCD22363FE8B4B23E72C128C03E22FCBECD7E6D3FFC1606C08D58D53F25E93E3FA2FE8CC03235823FA34790BFB8CAD43D0C304D403C652FC04D51CFBED0BCCF3FBC32BAC0E1D085BFE44AD63FCDDBD0BFA77B154012F1573EC92291C0837D53406F983B40B46F0A409E5DB8BFBA3442C033B3153FE4E02140DCE8C0C0B9A6DFBF1E04B13F2D281ABFB615C63FB40291C030F4BABFDB59BABF9F09C53F948129405C4E8BC0DEF29B3F142236C0E1DE8C3FBBB950BF4EA828BF515E98C03FAD3D403CBE8A40883C8FC02429BCBFC3AEC33F5C5C54C0795BB1BFCB2585408DF686BFB87060BF3B5947BFFB52C2C0A4A232C069900DBF89A5B73C679911403697F6BF876013C07B2320406E6A77C002EF13C0846910C0EEFC6DC0AD5DBDBF94DC02C0ECD0D9BFE06234C091F8D4BE3A89A6C0E58A88BF63191CC0D2EF71BF210A2D40E9BE1440756A6840CEAE93BF95B4FC3F174E863F8C55853F587A50400F4943C0D22DCFC0E4A074BF6B98AEBFB618EEC0BDBCF0BD36A1C7BFF89A2040390A11C0107BC440CF6BA9C034A3F93FD4308440F5792B3EE1CBCABFD52F06BF42E2843F4C0E0F3F039B223FD1AD31403AF27E3EBDAE11404CCA8BBFF60525C01121F6BF1264233FD07A933FF2193BC007E0ACBF5109F63E84E1BC3FB8E391405F04F0406C829C40A51280C0583D19C11499A3BEF47C64C07C818540EB0360C00C005EBF1F59B13FC58234BF57D9FE40A821013D33AF5CC01033BD3E3F0F4A4003D6ACC0A282634021FF00C0D51D93C09AB605C055CB594044D9B6BFC74843BE828B86BE30340E3F5F7B4B40CEB5E1BF693E88C0C2045B3DB5D090BF211D5EC06F26B2401BE78140513382BF7C4787BF55A180BFDF3D70BE26F0B5BF6F4328BF67AB0CBED6D1BFBEEED99F40103C7DBF27A1833F736EF540F721193F8558E7BF1D925240A3435EBD118FA33FC3E4EB3E1C8FB6C00D062FC0A71649BF9ED6154037E000C098B9B83F1A482FC0FBA4DBC01DF4053E8CC9953FDC1984BECC5AB7BF3AD906401E2D74C058F6D13D95EAA2C069E283BFF35E1E40B8CCE1C04D9126402EF7A3BF546E97BFA9F60B41FD807F3E9A4E73C05B9270BF544ADEBE4DB309C03F81113FEAD04E401979EDBF7235ABC0C2834340067C2B3FD581823CAD441EC01979B43FE01FB440343141C06CCD5DBFF39D6ABEAC65BF3F08FC85409BCEA93F0807FF3F0FBEA93F9C763CBFB86BAD40DBDADD3F43C00CC0127F3840C3351C400C7DA3BE67EABABF49C2A83FBE9C07C06A2E93C0B9CDDFBF75B9C13FCB0422C09AF756C009994A40A62246C031FB503FB4135A40229C353E56EBDFBEC35DFC3F5CBED13F48F5B33FA17588C0A455193F824D41C09D2DD7C069D6C7C0CD41074070024240FADF7DBE1CD11B3F071B3F406A08E7BB688B0740CD1CE6BEBEE0943FBB20BB3FE5C98EBFFDBEE03F9B0341C06CA7B740338E8640E8EF9B3F454187C0558D6AC0678D4CC007645F3F19EED1C094FF13C09CCB4ABF78D63A3F252DE0BFFF6CD83F53D320C0228182BFCFD6C8BF55D08440937D83BFC8E5C6BF861CCBBF6C2DCFBFF32D1DBF06B31040636BC83FBAF7EDC0E018AFC079E69B40674F93C03654EC3F72A8DC4019BA853FFACE1F400170B9C0710D6DC081954C40350340BF81C2E8BFA3CDEA4056E430C0132CDD408EB049C0C8C010407D48A0BFE97FEC3FDD4AAF3F2F276EBF24258440C7787C3FDC4DFBBF97AA423F378DBEC0167937400E48674028C4A140E5472841B9A639C0C4820BBFD64FC5C01087B73F30395AC0E36E553E2AAB21C0D2485E4061F7AD4072A832405B2ECA3F84D520409A11F1BD69A58CC0F5B03EBF09A374BEFE97DC3F08B70040023287C02764663FD09872404559D33F3DE14C3FF23480BF10C2E33F7583D8BF43D0E9BE37D9B6BFC232B3BF1BEA2E401829BEC0B0CD5D406D8C7AC0A316B3BF8EF557BFAF679AC0D71877C0AFD6D53FD4D2D7BF4DE69A3F3C96F3BFBF5200C0AF20B8BEF114F03FACDD03C0DB0DDD407E571FC0DADD18BE1B1462C052ABD1C09189B4C0E9225DC05A195640CE1B76408C9239BEB4B552BFDC9126405E94B6403ACD52C015BDB1BFA2FD0840347D1F40DE1AD340D08EA6C0C6DC6840BF36AEBF145F56C073A321C0037DF7BFD55C1AC0D7DC6F3E3C4F03C042BDBD3F969D9CC0E2B7D540A746373F054A20C0B8029140E3557DC0BE02A8C0C57FE03E16661A4078C503C0191E94C0E97B8B3FE50BFABF455DA73EC4765E40C6AAAF407AB51DC071764A40707BBC3F69D83940841F0640787029C07FD4A4403CD20040692802C0DF5249408337883D25B8A240B8E6AFC083286CC08F20314082EB47C09E272DBF488DFB3E7E559A3F9D525BBFD39789C01E8C1FC085A61C3FCA54A3C058AA2B40794A9AC0E0FFBD3F3817F6BE2F82373ECDD71E3F5A885D401F8879405FD2CD3FF7291C3FA77BCA3F8A8D3B3D3F29B23E5A494CC04C2E1BBE7F7BF73DD85E963F12D36EC0A14349408896F23F1B162B3F"> : tensor<2x3x9x10xcomplex<f32>>
    %1 = stablehlo.constant dense<"0xCC33B7BF24BB6740D400E1404915AC3FE8DC9B401C6C18C0011717C082E19140C2B5BCBF69174F40FAE78BBF1B259240DD09D7BD580B67C0B186B2C09C76DEBF07E92B40BFB7B83F265E053FD532D6BEEA93473F02A57EC0DD63864054689FBFC631AB3EC5EAB03E07FCF2BF7009B13E32F8963F09AE4740573DA640C3263CC07E9E74C0FCAD0FC0059B89BFA643E0BF162D063F0B3C96C0AD74B7BF9FED1E40C4FE48C06B088DC028929140283C95404A9EE8BFD53600C0BEF971BEE0FD454049576D40623609C0B38915C032C513C0FFD70D3FA5A2C43FE946A33FF853ADC0EABE4AC04D9E29C0B3288AC0C69BC6BF3C568EC0C442C9408A92A03FBC22F13FD8925D40870129C016A2A13F2BC81AC0422859BEA83683BFA8260F3FED0F3DBF392CB240D03A854017B7233FDBA872C06AFF9F3FE76CCB3FAD3781405C8FCD3FE5AE0B40A97CB7BEF25E66C02E4E8CBF4FF58FC0769062C029D139BF578C48C062B8ECC06FF1BFBF6479E7BD2D52D0406165EDBF0DB8564007713CBFFC06CCBF009159400F9C98BEF694104028864BC03E9164BDFAF9CEBF51050F3F5F7224BF7B3841C0B16886402AD4524049DBB9C09E1936BE7BE966403D2BD03F80752340C1AAE83EFADC773E9A15503FEAA99BBCD4B6E2C0EE136140C90266C027111840FC43A1C06322953F37AC803F1AB9EB3F84E45F400BE88940115914C12379984011FAE9BF9CD841BF8EB85640EA082D40120E3FC0A91FE93F671CA0C0D2B15740F129E2BE745A9DBF0E21D2BF0C6CD340C17B1D3F9F4C074008D430C0755ECC3D22BB4ABFE5604ABFBB0562BF47B269C0619E844016B02BC0BAAF84C0BEB2B33FE3E859401BB9FFBC6570DDBE872330400F82ABC0502DA7C0A1FD11C08892154066EA9140CCBB24C0BEA29D3D6E204D3F891D7FBF99B14540650E8AC0B3E1234005691740D773C63F90579F3F07DD12C0BF04EABDB87CA2C0F883DCBFDA40DA3EC4BB25BF10B4673FB6AA593F198D19C026D96A406A75F33FA8223CC03ADE2140FC8A4AC09E2737C09A239EBF13D3054002150840A5060C40FC3BE73FD0A8E93F87AB19C00A8384C006CD8AC0FF7E87BFBFD606C09E5A04BE07B64640DA9458C0758AA9BFE27020C0FADBF2BEEADD0ABF169790BFAA6E234014273C3FB55287BF7FF7DE3FF540E3BFB81BD8BFF2C8F54024E97CC0565837C0931AE6BF27940840D71527C04D3E7E3F75B078BEAA1070C0447B683E3D4502BEEBF322C064B0433F0CB79AC0186AD7C0DAC235405EE7AFBF8E33DABF01D4C13FD169223F0C495B4049ABB6BED3B649C0B93F8B3FB08FEFBF8BCFC9BFF8D94140E80B89BFB8F706C1990518C0712FF2405B49C7BF9F7618C08D3F3040EC4283C0F63583BF05BF8F40B1FA75404C110EBF275F993F14C683BFAD1A2EC05C7BB8BE9D97E6C005BB82C070BEC2BF6F51E34083DC37C07E8CFA3FCF5FDEC0A3AA7C3E7954693F9138BF3FD2A129C065D42C404CAA40408C4563C0BAD7B5C08D00DD3F7007623F74FCE23F16B9E1BFBA75F83F65BF013F8D4AE83F374BD2BE4AA045BF695AB4BF7CE76ABF78BBA0BFC06CB43FCD70C93F7432873FDF0B2240E3E199C0FA5D50C082AD55C021651E40E6063A40B20AB13FEBE8B74087AF40C0408527C0ED14F9BF34C79F3FCC110540E3431C40DA2D7840BF2C3CC0B388323D5F8D19C0115FD73F3320D6BE3F8E95400E1116407CB88D400449993FBC2ADC3E97A18BC097CF81BFCE6C82BFC32649C09CD31E40BDD630BF3FB9184091571A3E0F10ACC010059DC087F280BFD9269D3FB9AD98407ED2EB3E65CBF7BE0D5B9C3F56F41A3F676684BF67C116405E4EA8403D4E91C09D6F054053F62DBF9C6A974072247BBFD328A3BF4995B93F6E7439C0A24A51C00FD8B7400E9224BF5238573E9204F6BFF2F022BF9108A63F61508F3F3F7158C0DAEB99BF19DA2E40613BBC4056A437C0AA9D80BE6D3B6CC0CC6477C0C97D68C02BDFFEBEB238D2C0BDECEA3EDD722FC09069BAC0C95F28C0"> : tensor<3x3x4x5xcomplex<f32>>
    return %0, %1 : tensor<2x3x9x10xcomplex<f32>>, tensor<3x3x4x5xcomplex<f32>>
  }
  func.func private @expected() -> tensor<2x3x6x6xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x5ADBB7C2F84E82412A9B1EC300445AC1BC827BC1472108429CDD1C425CBDDC41A63FF0C211BA1FC320D293412F7CDAC2D0B83D41082C204128FE93419A64614312026B426EB3B8C238800E42FA5D8542995256C2D2B78EC21940A142A3DC9CC18E085942935BE342FE62E842E616BBC2A3AF1D4324CF82429C4687C30CF21642C5BF59C27C1191C1BC266FC3E4E37E42783F1CC27CE7064340710F40381E50C2000BCD40308B3742E6629DC2587CB6C2FED87D4298FDE640564E07433B63E142D0A720C2E014F4405A9553C2801A93C2D00E6A40C76A1442202D4341982139C39A7AC54204FF66C162818942DD51ADC2B345ACC27416D94277493EC22850E642C0C3F9C2C7AD8442928E9BC2260762C2A2B38F42F874F9C276AAD8C26CE62DC3104738C26A254CC263484DC2CC198CC2E42CB442627B8842EFFD9D429B2C70C260ADAAC27F7AD4C26050714128A06440A8EAB3412F5A7DC28C160FC2801FEB4284F33242176C0FC23A48AA4225D41FC388D64A42192D9EC2E4F5CBC2DC6EE34100D23A40C3F29342D553D5C2E7593CC30B193B41E75E4043844D1C43E45F11C200FACC3EB2721FC22801AFC03AFFDF4204FC8EC1DEB5C7C250E0444100BC33C0223458C1A89EDEC2F39F8FC3AC336DC17A13DC42DEAEA8C2C2BAB942A8BFC141F4D1A2412C22FA4239481BC3BCFC02C15D1960422824D842F423D342F04FB742162ED241CC03F142DE10EFC19B7A2BC2FC140DC28A22BCC2C87549C3885C1E4143E0DC4221C14B42BC2381C2801578BE69F39441D00E853F623C8EC100EDE941FB2587C2D0A3AAC2538A2AC29A2A88C14AC4D442282831C3425D314360638842725E57C2509017C217B08942FD009CC251E14D43C883D142B33B88C2600B23C3C4CC88C1384FFB41203603437CEEBB42C2AEFEC17601FE41D979E142CBDAE1C1B20AB44209F9B642A68B3D42912DB2C298F73942A42FECC116328A42944805436A990FC2AA5F9DC268EA45C1D45374C220098A41A6800343322C99C1D06938C3AAACE4C2F44F0042F8FB42C394F2DBC114647D4254E51343B68522C3BCB99141673792C2F0D218BF3CBFBE427D909BC2BE6B8BC2B914CB42D6C068427DB90AC336C12A427B179942F4239342A04CD5C13F002CC3F048ABC24D6BE242DE0AEB42920F5FC2B517D342D05795C278F10EC15EDB4B43CDDF61C2484D2D43686343418ABFEDC26009A8C02005C6C1AAE983422C2618C2B44CCBC256150443204D22439A0A294344F937C218220743CA273C43E080E840AD1A6CC262C17CC376875FC23E93FCC2AEFA82C285B29EC2689400C180635BC120C128422C311E41484B6FC275D27342549478C1C39AF4C290590DC0693522433A7CBAC1E62221C18443CE4200B69EBE587E69C1AA539FC134103F4203A74042C702F842D047BD41C038E342BFDFE1C2BCEABF40C41F37C240984642EA7048C1E40C1F424307B34298555C42C390CF42E8F6CAC062F58FC2CE1DE8C218448542C36D2BC296EB0B43A01114437865C0C1907A54C1A08B0F42C999FC4223E650C3FD15D0C292D3A3C26076B4C020DDE83F6AE8D5412D8E6CC26486A1C247CF28C29B7709C3ECB64141E145154374F3ADC2DCAA23C2784C8BC238ECF540B256EAC18B13414218159942D257AE4128D4F942782995C20C4D63427EB06C42161BDF425656C3C2F80B65417C978841F67CFCC220B8A0C2D06818C298AA5FC2B8DA3D41A0EA5241902E8DC2083D05C357683F42C058AB40230F06424841F6C190F328C19AD5B241789C3E4198A84C410A41AF42C0F6BDC24C9E0FC348B5184254CD44C24007274212231D438836A941108F97C1C5BD10C346B84DC360D7EEC220E82342568F0943580F2EC2AABD4DC298B2ACC1E81E40414CD0C4C1607E72C2407F14425DE6E642A3BEFCC2F191EF42DF5AA6C2F05F6F4108A5D14296524D4234EC2D41CEF3B4C21F6106C25A7FCCC102213743BAC7204250AA9EC1B06AA6C2541C00436EA1EBC2E909E6C2C7F8B5C1D0910EC1F481C8C2060845C2EA3772C2409EC54056D6FEC2848B2FC24A8E5EC36CA00D4324E519C2136143C2F0614F428073AEBFE32B49426769624310E83241A02B5D42537D0B432ADB0343A1C71DC2CEB5A442ED475343C236A0C25C0A0DC20A1B41C3F045144288FCF0C2DBAF19C295A3F1C2058C3242C02DD341B026FC41A25927C368DEA7C1648CE3C2B2C45A4108D7AC41C0A87440B0C0B1C0381119439833D6C224DF11C3D0795DC11E8D16426D7286C10DE81543979ACDC22368E6C24CA2A342C603B0C2D2B5C9C1E89F36C2C0A14641264914432ADCAD41691B2242001BAF3E4065CEBFC4CD1D42270113C272952943C017C44112A960C1CAFCDFC2D4F93A42DE0517433CA29CC2E20621C339611043A3ED15C3B9DCC1426D9CE942"> : tensor<2x3x6x6xcomplex<f32>>
    return %0 : tensor<2x3x6x6xcomplex<f32>>
  }
}
