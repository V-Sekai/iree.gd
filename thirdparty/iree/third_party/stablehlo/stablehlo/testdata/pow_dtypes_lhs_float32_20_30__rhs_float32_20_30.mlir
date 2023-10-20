// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x30xf32>, tensor<20x30xf32>)
    %1 = call @expected() : () -> tensor<20x30xf32>
    %2 = stablehlo.power %0#0, %0#1 : tensor<20x30xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x30xf32>, tensor<20x30xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x30xf32>, tensor<20x30xf32>) {
    %0 = stablehlo.constant dense<"0x33934A409592EDBFD959B340A6448A3DDD6E1141DC7A2CBFADCF673F1CDE87BED03B27409C4A7FC0D66365C07ACD753F492001C04485CABFE98BCE3FA8431DC0752B243F5BC621C0955C8A40CAA022C04CDA093F48946140B8763540DEFCAD3EC0ADE2BFEA5E3040ADF6D23EBCBEDB3E7585D83F2E31A43F51DA2240B66629C03BE3B5C011594E3E57AABE3F6E75B5BFEEF315C02B03E53F8B40B43FA4C036C06402D5BF7072EC3F342B4540894002C025B260BF9C1B81C08FA76EC0C1822BBF7E3E1BBFFD51073E150C1FC0E5D8153F9ACEC0BF7A2AEBBCB5FD34C096DBC2BFFC4C7CBFDE5DE23E4AA02FC064B540C0F8909ABEE714BEBFB9B240C0E86FBDBE36E30BBF951F9F4046B28F400703E2407517A440062D92BF6A1923C0CC2927405FA26C3F334634403D2338408E3958C035B4A0C02A198A40642A0240D84970BFAE7BB33F6847053F94B82F405628833EEE25DB3D81614A40F76D1E40A327883FE21E1DBF9DE7C2C0C5919B407E62843F789F39408220993F51309840CA3077BE8297C83F97711DC09CEBAABE65A1C63E1E6F073E14127AC08FD4CB3F1135B8BF28860FC0F752B43F74250AC07AFF803F6B5101C0DFD2824035955440E48AF03F998C5DBF2E1C5DC0D6F987405C31C83FE0EC7DC0AB2188C06BB97540A3AE58407B18F23FFA33B53F8C903CC0026C95BFDA9706C08D39454089AA8FC074B587BF80344B40D71D63BEA18507C041738BBFD59BFD404E95A2BF590C28C00C4B4F3EC5F415C0949271BF37268940D388D8C0FA9909C0FAC36E3FE12A943F214E8E40FF55BA3F5D52F2BE630A183F19FF17BF987582BF77EEC1BF12D753C0F43137C0D2446E3EC88A823E6770CA3F85EE2FC05986AA40EA51D840D0FEB4BF19816BBFDA8C1EC0596EEB3FEC2093C0D95F0F405575EABFE4F822BF4B81274021C73C3FFA0F44BFF8AFE04064126FC0C506B23F98869EC0621E073DC46981BE2E6CE73D08AF81BCA11E6FC08DFAE7BF141EC240DCDC0EBF4E37A7BF5CDC98C080591FC008CE71C037259C4005AB633FD0E45EBF17E80FC0FAFD4840E3E1EF3F6BAADDBF1C90B5BF2671C0C046B8CFC0AC796E3FDC98AEC05833F3BFA9188040CE35E83F2DD78E40E93E4C40D679B9BFF4F55D3F3E311040C67BDF3D64B818BE6A137CC021B2133FE947933ED51A143F49BDF5BF16568A3FE9BDAE3D07B384C00BFEB7C0ECC21DC002ADC0408733CABED15D0FBFCC4279BF460E36C0E03AAE3F50699E3F072189C0FF729F3E33CB5540AE9D8640E9172F4044553340267979BFA751474004D99CC0C0730EC1CF9FA33F3BD8BF3EA5B80F40BC12063EF284FABFB1EE0DBFABD482C0C5645AC0111C0BBF361086C06E843DC000016FBF7DA6FCBD51DC3C408C84E4BE51DA5740942FB6C05E7FEFBF996BB1401EBF3C400A26993F7EE8443E66D9BA3C4DE431C006F825C08399A53FFD330B3FEC2D01BF83BF8D405615924083E4943F05EE48BFF0F8D93FB62C3440882E0040CF6CC4BE97CC14C01EE5BB3EA0663940E33ACBBFFBD73040D3A7323E13F5453F92E46E408CA913BE827388C0804FADC0BED0F23FC4CC223F138D81BF1D24F93F2059BD3EDD5D8CBFE694F2BEC0C103C1C4D374BF6F0ABDC0C6C02540A00646C04349E73F9580903F7E4A183F09F10A3F52A919C02908BC3FA56765404EBE4FC0F6E7DAC01C2387C05D8210C0108E6FC0F355F73F14B9853FF5FD5A4039FB213C2DE976BFA10704BF531EA53FD4CF8BC0DC6F77BF4F8B9EBED6EFC2BF2EC00BBE5B4C37403D172340638494C0A7F928BF306DBEBFCF2013C00D4DA7C030E6BD3F9BF88F403B1B8F3FABFBC1BE85F807C0FB81E0BE42747E40E3F7AEBF84D11BBF58B7A2BF0BF4C93EF0A99F3F6F0FB53F3E0240BF68E589BE878682BFED1E933F967D8FC0AB81F6BE9910D73ED80F4DC0B3F592402F20B83FC053234061174CC099D5864036C805C090BDB1C04D8EC7BF181A3F40600393BF61CCC33EE5C254C0915516C066CB8C4097D9053F126CA23FA6D3D7BE077FC1BFFB3FD73FA8F473BD8BA42B40A66E56C0E01A8340B0473EC0177135402FA9884047E8C73FFEF0B040D33F89C0C6C47BC0B6BBA140B27F50BF082D43BFE8A81CC15C12B53F4C3D1CC03B00D3C0C86CB2BF7E95FABF763D02C1A2E7E2BED4E00640309D87407B90E5C0CBA134C068DD78C029488D3F1E731FC05477E83E6B207E4019C77A3E03E9DE3FF3772ABFD6490B408778553FF5EB493F5F9011BFB9D8A3C0FC885A3F0E4C143FBF8BD33FAA8A34C08C630BC01D20D3BFCCFE933F4D793BBEAD3D8D3F33E7A03EB177E4C0BB0E03C08851FC3F97195DC06C6688408FD0274039797740237325BFF70D053F7CC4BEBF9997F0BE61A124C035BE0EC035CF1E4055B3473F86CBA3C07B59584081FA00C06A4D3C3F7BB4F2BFAB0C043F6B2F9D3EFC5A03BFECF5B33D74DB88BDE8E9B4C0E3FAC13FC20B65C0B622E1C09FA67FBFA8FEEB3FD43047405F346B3F0DC88E404E6F3ABFE439BC3FCAC289BFB857313F29D2F03F73E4DF3FD64D57BE070A834027EDA840D75AD53F158C9D40FE415D407D19F2BFB57AE83F43AD00C0331C0C4069D50940FAF6DC3E409FA2BFB79A0140E10B51C0F6F594BF943DA3BF5480A83F9A248DC0D712B440D21EF83F58E9EF3FED370BC0B04D44C030749D4039D57FC0A4200E4061C89EC067CD40C05BA99BBF880180C0E7FBFEBF703A4B3FFCAA09C08E3A55C0AB4DF2BF0CB4B33F83AC66C0E34C27BFF5A715C0070946BFEE1D51C02C99643F2BB797BF5E4CDABF024B80C070A33540CE88D0BF5BEB83C0120495BE75CF233B6B3910C07BFCA3BF5B61FDBF771F823F265FDE3F2A620D40455453BF2F4618C0B6B37DBF8C99173F37850BBEAB1BE33E128F1DC0A18BB4BEE14927C0503EC5BF36B1B83F4D8E0EC07C738BC00A33BF3F7007E93E564634C034D754C075A406C0B2262D4022DEA0BFC8930440AE7C9ABFB6AD9C3FDB87D3BE647AABBC5FF976BFEAE9893F774909C054B7A33EFA5053BFEC2CA93EA2D70E405638C03F40112740E3AA6840C9E9C33F5A13F6BFCA9651C0749F9D3FCBB121407F4B3A40578BEEBF041B004041A9B53DFDD37D3FC8DC783FE62CC4BF7A820A406B5557BF7C8436C01D2FC9BFD21894BEFF6283C0459C23C0609477C020DCC0BE138616BE3AABA6C0EC3C32409AAEAE40FE6612C037212B4135AB67406D5F46C07CB5C13DDBAEB9C0AAEDC73F6597BCBFA9EF2140784CD43FDFF4CE3FBB18874040B281BE182516C1D187113FFA9BBB40438E6EBF257F513D3BD1E13E7AFF92C03A0E31C055927F404336334003089CC03125FB3EEDEB7A3F403FA2BF2B4F3ABF4A2ED9BFB062873E"> : tensor<20x30xf32>
    %1 = stablehlo.constant dense<"0x701FB63F76125B4005AD79405E889FC053B1ACBFB27A6CBF2B7B3F405ED7C3BF40B1E0403BF3DC3FC3CC5AC0BE29DE3FF94C3D40EAD38940208C1C3EEB0E94C0474A7C3DEF74BDC0ECAEB83F0342BF40899371406FF94CC03DEF1D40039A6F3FF2F0FFBEE18C2F404D901C4001B1BE40A3DCCABF7CF1243F89813C3DEF5811BC825C86403388C73E683540BF5339F0BD44ADCABF9D30BA3FC8F837BFAF12A2BF7D28CEBF0A8EA73FF2A32FC08A0060C082B086406FE90A40EFACD13FDBF8A3BF34962840FBA03FC0969B613FF6894B40F6AD6CC0ACE86ABF936222C088BCDC3E93550C407CECD9C0DBF3663FC054663E523FA03E6ECA94C0EA1ADCBFD76AAD4082360E40250A55409319A7C08E00CEC09E70F83F7231B8BFE3FEB140909E23BFE4C502C04D66AE3FB165493FF275583FDADF5F402B55F1BF3AA72EC0E7D224BF50CC0041AAC49B3E663123C0DCD97E40ABC0B2C0E942A8C07034A43F2DA95040CD9F7E4037A57F40E81890BF838D86BE89C03CC07798DF3FD5063A3FE4667BC03EC43EC00B379FC084A16CBEEAF21C408693D5BF4590DEBF2CF80EC0281E71BF948EC03FEC19EABE199D28BFC35E3AC0C3499FC09566E5BF23C6DDBF140361C0E36B97BF40CF48C0668488400CD2F7C0F8EFCD3E73D1693F5B89963EE8CB17C0C3F06E3FDBA32A40FCDF92C09797C8BF763336404B4BCEBFF2D039C04A16A9BE4627A4BF7795C2C0706FA13ED05687C09A58A7C0E61184C09A14CC3F3381553F68AAFFBF523103BF076810BF4AD4A7BF4493F83FC8FA09C0BB68D640E6670EC0F940E3BE35F224C0A8508F40D844A940CC617140772704C06E387B3FD44A6D40F48A34C04AD648BF2B5A0040E9753FBFC3E7E7BF62F926BE528E2CC0572FA3BF3E0E9B404E3B4340758CAE3F272D4F40C39F4CC07CBF3140B22681C089641F40BAF686BE1B5E8B3FB8E0B43EEBE6C2BFEEF65C3FD01F4940890837402F0B9F3E7E8697BEB15C45C01BF38DBE20996FBE4DEAB6BF1281E33FD950354006EB4BC0BEEF2D3F4E936440A9F068BF020B22C0AACE85BE3AE2E43F177CCC3F62AB793FB4410DC0048AE2BFAB6AB8C0BDF00E4088FB91409E822E40208CABBFFF9C074006DF04C052B6D43FE6B184BD22A090BF3CAF9BC0064383BF875383BFFD7161BF60115DC0BF479AC0C2044A3F9F0314C0559AFF3F8DCDF9BF6D176ABFF837C03F62853E40E63EC0BF03897FC0B670EC3D91D055BF096191BF3D3AD53F35F6ACBF36BA29C0868E13C0BE6390404BDB22C03F5B1A4064F6DBBFBF3FC13FF264C8BFDF0641C00724B5C0C76252C08ECA804042969C3FCE780D40E23D24BFC123973F7B444940847FA3C073881840C86903C0BEEA81C06873263F1C9E49405AF65240CC9A1740A0CA72401178AEBF3E0BC4C072EE113FD700E03D8B100E40107101C0477AC2BF73D41E40B35B194066BC40BF22A22ABF1C5D53BE36C847C003CB5840FB672BC0B3B561C002705E40BA65FF406635873F316BE73F15CC27C07C61584030B4B6BFB00E48BF17701D40D9C25B40779F9DC0520120400BEF91C0CC69BA40804990BF893D0440ED42F23F0BA194C09E4C0A3F460E3CBEF74A053FD997EEBE1CB8E04074AA8140ACBE683FD6F493BEC94113C04366E6BDB46A0D3F9380143F74F75E40C2A40C4089824B408DEEE1C0F402BF3F988AA1C0979CE53FAC1D21C03D8EDF3F00A029BEA7AB06C053994EC053FAB8BFDD1C3AC0CBB55E3F20EF203E25016640A5A280C027973A3F1336333FC68E01C0DA3BDD3F2A6029C0042915401ED040C098F080C077CF8A401D3EB43CDC7764BFF09A03C0CCD6BE3FB8199A408EB2903B12AE5D40C21AB3BF3A1C193FE1BA90C0655327C00AAF00C1EF8A1C4097971F40C29882C081BBDEBF4A6F31BF140FEE3F29CCBC3FA3E1A1C0184F843FDA9356C0C79429C0A62127BF8CB8CCBE825604BFCC7EB6C0E208214095E4A73FB1E8BCC0C8876C40BFB3E2403901F8BFD02A88BF79E0E5BF175DC53F15D711C0709F703EA401F740D1C5763E35FF2840BD4032BE9030AC3F8CBC973E7E24BFBEAB8947400AF2ACC0D556AD3FC3B63B3FAC0AD5BE003612409F7E69BFABD8963FA54D44C013B11EC12363D43EBB9C8C40655A01C0389257405A44873FFA6402C12D58C840A25EA53FA77DB63EFEBC04C0ADBF9B3F6E52EFBFE36FDEC0DC4FB240C9CC27C00FC92FC00FAC2BBF4A396940F93E93C03D3B903EC2CE01BF0BC9BBBF977CC43F1BB08A4006AF6DBFF34066BF16E960BE0E291A40A69FCB3FC33E8B3D2B5A6A3FFBB7513FB21E44C0936E444010B66BC063857FC078D4F73F7EC805BD2A308FBFF19713C001194940CB839940ED0B5240B2A612C0043D4FBF699609405FFF97404FBF29C0D12E7DC079F931C00CA94FBF5A33FB3F424324C02405933F9D7D9BBE0E269DC060320D41DFA91E3E4FE2B3404EE22DBFCDBB35BFE0127C40912146C004954CBF98C392C0080F833E57C9E7BE65ADE1C0EE245DC034B94540C081B5BFA61E8FC0466C13BF3D68913F733ED4C0D04F813F1B07C9C0611B27C02E5EA84036EE90BF5C23803F603A3B407DD9CCC0C757BD3F175FCCBF44B50D401E8B5BC0E7582341D16A4540743A963F0C49B33F782B5D401DCB86404189DA3FE901A7C003CB313FC83223400C55BA40A81965BF85982040FA930CC0E5468A3EEA3739C07F6AB8C035FD19C0A2AED14088EDDFBF4C3F633F6D27684076381EC0B7A1CB3FA4CFA7BF49E184C083BA9A40DD55AFC0241880BFD5B202BFAE265ABF12259E40A818A8BFE8B38D408847D2408475A1BFC964A240C29AF6BE03867340154656404C9828C03B013E40D82D38C06156983F823C18C0C62507C16C1EDD3F21A82DC0399161C012092CC02C288DBEA6C79ABF22BE793F4D4A62405CC7BA3E87678DC0D5B73140BD82DDC07822A540B6E657C048E154C0F93879401AAEE53F6A1B6240AF528EC06EEB86408CB707C020359CBED20604BF8E17993F4DF2D9C0FC73A1BF6D88C03F73173D40E4341BC07444A13F231C34BF1B6DAABF52521BC0F1F32C409463C83EE92C3B40D838563FCCE7F53F06EF38C0EAD3B0BFC83C2EBF100D8B40D89F26C02D4C14C05AE681C04B9F1BC0CD708FBF5F828840D05B1BC071E3944084133740D3360DC0E716313E2E68A63F85B0913E192C81BE8C163240C3501C40814B2BC0F14A85C09A9836BFB78C43C052F80CC04B88F6BF2D2763C03E48483E64CCAFBCD9CFE83FDCB712C03F9AB5BF29178E40A22A41C0B1BF3FC036AFACBF03B332C07906C8BE2023DF3FC3EDCA3F3E699E3E15077DC0DFC72DC0779A0DC05A0CB84059A59A3FD5000B40AC2F063CAF1FC83FE09231C0782E0EC0"> : tensor<20x30xf32>
    return %0, %1 : tensor<20x30xf32>, tensor<20x30xf32>
  }
  func.func private @expected() -> tensor<20x30xf32> {
    %0 = stablehlo.constant dense<"0x03DFA4400000C0FF260F504478552749FE82503D0000C0FF343A3E3F0000C0FF7C4F54440000C0FF0000C0FFAC8F6E3F0000C0FF0000C0FFE2B6893F0000C0FFEE16793F0000C0FFB34D04410000C0FF52FAC53DA9EA903CEC6D51414E71BA3E0000C0FF780681415512EA3DE303D43B4291DE3E6F46963F2C9F853F0000C0FF0000C0FF1E20093F81CD3D3F0000C0FF0000C0FFDC2B1540942B483F0000C0FF0000C0FF37E90E40DBC33A3D0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF1622D6430000C0FF5E763A3E0000C0FF0000C0FF0000C0FF0000C0FF0000C0FFA3AD81430000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF3E54504300C3CD3963D46536D2FFBE410000C0FF0000C0FF0E980A3FC051963F8533834020FA12400000C0FF0000C0FFF905823DFD8A133E0000C0FF993173415CE4513F89E59B3D1499903BCDF28048B3F9193BF0BA4C409F8D9C3F0000C0FF0000C0FF6BA52C3E76BE7D3F4134313D610FAF3F70BF46400000C0FFA630863E0000C0FF0000C0FFE1D9C83D55E8E9410000C0FFB616B53E0000C0FF0000C0FF78DE5A3F0000C0FF7E467A3F0000C0FFD82FA43D6AE1FF3DECDFDE3D0000C0FF0000C0FF8694EF434E43003D0000C0FF0000C0FFFE1ABE3F750F633D8207E83FEEAE21400000C0FF0000C0FF0000C0FF07EF263E0000C0FF0000C0FF33B7683E0000C0FF0000C0FF0000C0FFBED0A6370000C0FF0000C0FFF01D873E0000C0FF0000C0FF474AE13E0000C0FF0000C0FFD4C0943F45952A401D07143D77B2583F0000C0FFA391C63D0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF1A91744241FC3A40197D20400000C0FFE9A2453DB9753B3F0000C0FF0000C0FF0000C0FF3357CD400000C0FF10CD59410000C0FF0000C0FF73A4A83C42C6EF3E0000C0FFC09205410000C0FFFEE81A3F0000C0FF5626B9370000C0FF9C0B023F0000C0FF0000C0FF0000C0FF7DE6273F0000C0FF0000C0FF0000C0FF0000C0FF0000C0FFB0B78F438E6A8E3F0000C0FF0000C0FFAAA9F740E7912E400000C0FF0000C0FF0000C0FF0000C0FFC8805A3F0000C0FF0000C0FFF7931F3EA41862400372373DB51EDC400000C0FF1D64963F0E749D3C9A231B410000C0FF0000C0FF47ECD540502CCB438C38263F0000C0FFA178953FADDCF3420000C0FF0000C0FF0000C0FFAF238A3D0000C0FF0000C0FF0000C0FF0000C0FF11F0D53F4EEE3F3F0000C0FFAFA16B41EEF666435EADD33C844235418F4F2E3E0000C0FF3FF02C3E0000C0FF0000C0FFE669E43EAB9A9D3C9D2E2C40AB14373C0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FFF4A30D420000C0FF6A5CC9420000C0FF0000C0FF06E82940D012903F129BBE3FF989E041B42B9C430000C0FF0000C0FFC7E0523F621EC03F0000C0FF4B4C1D3CDB522B43E0C12A3F0000C0FF6A8DCB4083D671458A4B05400000C0FF0000C0FF402E0A3DD65C603E0000C0FFE1F842415132233BE41A6340D75FD7410000C0FF0000C0FF0000C0FF484A70408A5ED93E0000C0FF656DB73FC4A7993F0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF8C73423F0000C0FF11846F3F40DE883FC4673D3F219BF33D0000C0FF486959406563FF380000C0FF0000C0FF0000C0FF0000C0FF0000C0FF4F89653F687D693F5A729A3C216A45440000C0FF0000C0FFEC39853F0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF713CC5407143AC3D0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF5208343F95EA393D9929973F0000C0FF0000C0FF0000C0FF2F70143E0000C0FF0000C0FF0000C0FFAEFCDD443BCBDB3FE8F717400000C0FF0000C0FF0000C0FF7FD4A53F0000C0FF0000C0FF38E0D03E0000C0FF7343903C22E8493F0704303F0000C0FF8D9D8F390000C0FF0000C0FF0000C0FFC2F763420000C0FFA70FCE400000C0FF0000C0FF1F1F1D41733F8C402B5E873F0000C0FF0000C0FF9D7D7C400000C0FF214A71400000C0FF9536173F0000C0FF16C16A3BB38BE440547EB13F5254FB3E0000C0FF0000C0FF19F8D7400000C0FF0000C0FF0000C0FFDDEB92400000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF48F5A63FBDEF4C3D0000C0FF0000C0FF0000C0FF9EE2DD3F0000C0FF3DF30B41F414CB3E3278C23B2B7F9F3D0000C0FF32942C3F6418A73F5FD8313F0000C0FF0000C0FF9E93933FA54E903FC4A956400000C0FF0000C0FF0000C0FF8829903F0000C0FF5C26AD3FB5108E420000C0FF0000C0FF49637A3F0000C0FF61A1103DF567A541104E24440000C0FF79598F400000C0FF0000C0FF0000C0FF0000C0FFF4E4E03C735CFF3F0000C0FF87AD2E410000C0FFE2E6333F0000C0FF5288CE4136EEF9370000C0FF04299B350000C0FF0000C0FF5189A4400000C0FF0000C0FF0000C0FF12B3953F271D193FB5A5E83FFAAEBA3B0000C0FFD52B143F0000C0FFBD219E3FBA3703406FD0C83C0000C0FFC96715392DB9543CB34A6B418473283EDC8D5D400000C0FF0796B33C0000C0FF5989923EECEDAE40FBE28E410000C0FF260D0D410000C0FF0000C0FF0000C0FF37C04B400000C0FFD294FE3861B2CA3F4BD09E400000C0FF0000C0FFE7065A420000C0FF16C79E3F0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0191503F0000C0FF0000C0FF0000C0FF7315243F0000C0FF0000C0FF0000C0FF0000C0FF0000C0FFBEF68C3F0000C0FF0000C0FF0000C0FFDB136D440000C0FF0000C0FF0000C0FF6C030A2F0000C0FF0000C0FF0000C0FFF929743F99FEF63FC26B1B3E0000C0FF0000C0FF0000C0FFA8D2CA400000C0FFC327A03F0000C0FF0000C0FF0000C0FF0000C0FFEF994A3E0000C0FF0000C0FF85CDFD4010B463410000C0FF0000C0FF0000C0FFEAA106420000C0FFE270AC410000C0FFEAAF703F0000C0FF0000C0FF0000C0FFA902693F0000C0FFFC080D3D0000C0FFF4BA7D3E7985113F30FA143F3288C73D54E30242D633973F0000C0FF0000C0FFD0F0BE3F93AD8C3D7F076A3E0000C0FF9833A341FE1609445C8D823FBE918F3F0000C0FF9289D73E0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FF0000C0FFAA3C4341BD6A2E3C0000C0FF23E33C3EF7D1A03C0000C0FF41C6BB420000C0FF4FAA8B3F0000C0FF5F28AD400885A03EA579013FA2BD15440000C0FF0000C0FF331E094065D6EA3B0000C0FF91E6B73B50D88B3E0000C0FF0000C0FFA3CCBE3C1ED9D13D0000C0FFFE88D83E1F19753F0000C0FF0000C0FF0000C0FF0BA39941"> : tensor<20x30xf32>
    return %0 : tensor<20x30xf32>
  }
}
