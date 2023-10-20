// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>)
    %1 = call @expected() : () -> tensor<2x3x9x6xf32>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {pad = [[1, 2], [0, 0]]} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) -> tensor<2x3x9x6xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x9x6xf32>, tensor<2x3x9x6xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>) {
    %0 = stablehlo.constant dense<"0xA5AAA04082B68E40553266C0BA322940AF203CC03EB32AC01422F6BED23C373EB7838740C3F0943FACC4CEBF834F8DC0B365173FF79D65C05FBB30C037EFF9BE9B3A9F3FE8575140A96B3440D7FC3BC0CE103440BCB222405567B9BEE99956C00F4AE53FE07DC9BF1BB6C5BE9BF269407E1C17415577413F2674A7BF77E609C034971F40CB6A6440BDACF5BF5748ABC0589740C023659740A142E3BF155F73C0ABD50640DF9FBBC0130E02C04A7A603F86DB423FFBD766406C0C1040CAA31A3E803B0A3D548BBE3F09CB44C02E67953E0B6EBAC04BBF8B40B96EF43F0E2D2DC0CCEE1D4080418A3FC00B42403D994A400D5C51C0FD14EA3F5B77C3BFF76F2A403B8E233F1088094011CFFFBED1FB87C0045DA8BDB2F7FABFF7A18CBF96C3E53F17CB0FBE37A73DC0A6A4FFBF42F0F9BFC78716BFDF5F2A3FBBE103407F356640DECA4EBF4A8083BE7E362EBF191B26400342DFBF9494544027141140DFB51ABF3782583F6532B040B574E73F1F37AA3F9B0EA1C04F0D9ABE6574E5BEFE03C6404B4555C00619D8408AE960C00FA5983F26CA42C0EEECA6C01888563F39A3FFC02BBAA2C01C9D824026419D3F6DD1A1BE87E930BEDBD21EC073D856C0BD9A43C06C8032C0134C4D3EA39E37C01EE39BBED32242C01A3D88BE2364EDBF9455FA3E6D04003F95C0AB3F8D4544406C9A0BBF9E4E8CC042C4483E54ADD6BF08C0884086D33640ACB8EDBE1B979C40D488E93F341AA5BF4EAE8CC00BD8B1BF991B06C01439A33F6B1FAA400E1FB3BFC5DC39C050379DC0148E7340AB65EBBF84062D40C16F813EE8291640B52003BFA1CBC6BF8FBA7E4069529940185768C09C1B0CBF45022CBE770AE9BF4496A33F635F18C02FC7A840E50742BD453B983E3E5C744070E5374001FD273FB9A9D03F3F86123B16C97B4011619BC0513E83BE3D23EF3F71576A405276ADBF34B8853FE2257940D8762440FFA0ADBF85D612BFE9B5BF3FD148D33F2CDB90C0EFAFB7BF9BA212C05077DB408FC7C0BF7FF94A406E78A63ED7A47840984A4A40F8F274405947D8BEE9F9AEBF7C98D0BFFEE82B40AFA7BD401FCD00407693AE3F4B65DE3D4805CF3F13CD3AC02A2FE1BF919FE640440FC0BF302FA8401945D8BF4F4653C0BA015CBFAEF06E40CB2F0E400A4F3EBF75AC30BFE777F93FCD4E7ABE2E0104C015B512C027628C408B0950BECBD4BFC0BB01A5BFCF48FDBF660E2B4012DEA9BF11EF2CC0AF39F93E4179233F477988C0F810AC3F62E6E6BF90822BBF269922C0F31F6A404160564026C7403D2629A0C0543BEA3F234E3B4059B9D83F8BE246C084512DBFCF02E2BE9C81DE3F60B542BF24FF23C00EA659BE551D0F403299C7BFCA85CF3F081B0DC04D7880406AFA2240934BBA3F3BF5D740C96F87C04EB93BBFC06EA1BF6EB73AC0EDC19840AB021FC0F533AEC07F20CBC0A0A2FF3F945A30C00ABD92407057B8BF42306C3E58E38F3F090D873FBBF166BF88630F40C15E46BEA91A814015D70D40B80BBF3FC8E81C3F30588A3DF30042C0C1E432BFE481CF3FA615903EF99771407C1235C0594C59C0EB3ADCC0854A473D141DFFBF272F5440165111407F4594BF48393F3FA64CFA3F03AFEBC03102983E3B880CC02BFF0D40A4101B40FCD747BE313F443E5901F73FD5943DC0343C8D3F44AF4D3DE6DE31BFFE4B6540A67B004194DD7B40D07B8C4074B2CAC0B5EDDBC0E91647BE9FD307C0F13BDF3F427290BFEA308640383A993F8743A83FE0E0FF3F6A82CCBFD2143A3C9D969B404057833F462186BF4F59FB3D970B58406A4F59C0575B97BF9CEFDF3EAA7EA3C035268E3FB3C66DBFA41338C05EC7E43F2925A5BE75A0A14096714340D2D7113D7FC74FC04BD88E40BEC12E3FAAF074BF4A981FC10FBBFC3F541E3E40CFF5A6405F9BE3BF6FF33040130990401B87E6BF156987403664A0BF4DB0F43D006721408D7961BF43A936408BF9AA40517F71C0A8F2ACC0481CEBBF9EE230404BF70FC0F249713FFBDF2940F9439CC051D04540196BBA40FC6E894037A68AC07E85144029D96740DBE3B03FB363C13FAF40C1407DDBB5BF35242CC0B45E5B3F5439904065E11D40BC9FDE3FCEB2FA3FC98A49C05EE9BB3F14E8B340DEB9DA3FA03CA0BF36330CC097D51F400E1F2E4020B009BF0F61D03EA0C45AC0764C9DBD36EAF840132B2CC075849FBF3D6C1F3FCF0BD63F7E6CE13F98CEDFBFB4EC42C0F68DD5BF44E0AF40A011A4BE70D1CD3FB72D08C07F67303F1A330FBF0F8F93C0B3A0B340F6A458C06415D4C0D483D8BF7D38E2BF1EC87D40A1026A402EA7D840BDFE17C0B63EE23FB931AE3C27F32E402BCEFFBD6E9410C0348A4640C6E17DBF62F6E1BF1EBA96C0E593B2C097E32EC0A6457E3F129F41C0BBE48440F3B89B40AADB8B40B991874036D0FCC08F2E6BC04BCE95C0292B0CC00455A44063C798BD7FD5D43FBA55AF3FE5E6234045568FBE2B0DBFBF4232AD3E7278A4BFADA48E40DF572740DB8455C052090EC09777FBBDE2F268C0EA498D40D43C22C027E549C0B9828440D6E217404C94B8BFF97FCDC0403B103F371B41BFF957FCBECC79EB3F1AD23BC053FE7040B9D103BF6BE1A840B79558BF3232A2C042665BC0E02DE240E6F970C03BB65E405FA30B40F43A0140E2BCD0405DC929C099414AC028721740E85DFA3F9DEC0240E265543F736B72C0CA05694001E9763F75ACC9BFCF078C3FE325863F056C5ABE4DF2673E028A06BF034AF4BE0D8DDBBFF9C9E0BF48A901C1E35F7B3F36683DC052C45D40ED5C8C3F15FFB6C0E3CBC63F5E29B4C0B16C4BC047363EC0A93DFDBD04C0EDC076D4FDBF9388893F56EFC63D880CCEBE3A83453F9EA57A3F407E2F409574CA3F140C22BFCE90ACBF5444D2BE0C2D86408442933F8607FEBEACF66D40C8F09EC0FFDCC53F5CFD5DC001FEEF3EBA310F40847FFDBEE6CADFC0B3FA2840A77B4DBF19844440AF1DE53F9F005240BF1D92C06675653FA90001C0B0DC3E40B4818C3FE11275408E522540623257C039727A3F8AC05F40AB0489BE"> : tensor<2x3x9x10xf32>
    %1 = stablehlo.constant dense<"0x69AAD6BF6F7B523F39987140EBB061BF284FF33F54E99FC074F473BFE25263BFD7B720BFCF73103FE4032C3F3BD11E3FEDEE2FC0AC2288BF266B5D3E2E432FC01EC53140F7A0E9C0A49B5C40DD2A7F40B199A33F053FFCBFFE6B0EBD877085BE9224373F73A2FABFB9FD3CC0ADB816C096D7B33ECCAA65C08CB7A7C0ECFFDDBF45FD3A40004E06C0A7C4433FE3C7BEBF59D585BF230F4340CD62C8BEEDAE46C06EF582404CCA833E59CC0C40F2143BBF051BA63FD0EFD83E080193C0F83CD83F4264DBBF4185F73F32EE3B4016C233BF571353BFEC77F63F29D61840BA0068C040BF79BFF507543E97BBB6C0E2EF9DBF45452CC028FBA83F218732C00EE6D5BF10825C400DBED63F3C2229406A36F33F4F4121401D97E63E3C870240C4B11440C243C73F7BB91EBFC6263DC083678FC065A0ECBEEF2DB7403F178840BE56EEBEEF67D2BDC83859C0BA5292BF0BF6283F3BEDC5C013D905C0B58496C0F58D16C08DBD16C055F490C0FF5B88BC51CEE4BE2C03C4BC75A79340349C3940A5B478C0EAEA11BF10751A40F01E4940C0D470C082477E40BC8A934083D2B0409FC780406D5EE1BEBD8B3740A3011840EEC59D402D09193D66CCFABF1421633F353B80BFCC16BD3E44C78940BC60BA3E2EF2813FDDDE0AC0580D774036458DC0B591233F5901A7C0D7DBEDBFDB91F5BF3B6EB140D9631DBFA534B83F4ADDD5BF4C03AB40B6A885C05537D8C000524040070BC1BF80E591C0B9352CC01C36193FA02CC0BEC94C59BFC344F13FD35FEF3EDFB637C07B5495BF585A8B400D851F401C413640D412453E9DDBE1BF8A4C6FC08756814097F31ABFA3DF0EC07D64A4BC10306FBF82DE623F725AA540D48617C093C06ABFEA1B453FA0D1A03F182CC43F2F6AEA401CA9053FF2C86B3F678E46BF6B8ED23FF5C75C407F66BD402A13C5C0F1D513C0590C084032EA0CC0723C3F4022EC2ABFAAAACBC019858BBFF310704033F084BF6C583CC0B086C43ED4C41340FEE281C0"> : tensor<3x3x4x5xf32>
    return %0, %1 : tensor<2x3x9x10xf32>, tensor<3x3x4x5xf32>
  }
  func.func private @expected() -> tensor<2x3x9x6xf32> {
    %0 = stablehlo.constant dense<"0x1F6DEF410F2639419C1ED441BE72FB411FC89C42267256C20964D5423682A742E9F319C1A517B142AD838842708248403E95BD3F2E5BC041DEB79C42E4603C427545D3C0D0817B3FAA17C042EBDBFCC27AD6A4C1637FB742F32A6641D13BCA4221CF20C14486ED413C402CC1442C4CC2F45B95C2C6AD99C2652F13C2D41C2442426FA542354E95418057023FE42FB942EC9E1AC22C6A85C06C0ABFC08C98AAC19A385FC2BA880EC2DF8553C2CAE59241E28321C2F3AE2842F120324260310F42383AE6C16EC910C2513D20C2CFC9BE4155B8BEC1D811C8C012AC20C1F67868C25E1082429C854BC200E19EC0B481DA4238043A43936CAB4158664E425E076CC2D06997415CDFD74263180742193D7F425A75CE422BF0C742A4324942D08892427C5B1542822957C1D1E8D541015EFC415FDDE541E0366C41699CF2C1F0202C41E0A13DC15835AEC0EA6499C2C8750BC29065BDC20DAE3A42D095FCC120085240C5AD52C2E28E16434E79AE42FA2581C1F6EB9FC260DE08425B3C59C2720851C2E3A629C2E3C3954166B1C2C163B530C298ADDDC18934B1C0FC1B30C2C83E0A41F06BA4C16A8AA2C1608225C2DC81A141550FA5C2B69D554142A32142607528C231EDD2C2FF790AC181FE1943460870C2C6706AC15438D0C093EEAE4268C1A942BD318BC22AD655C2742F414228EB3B4298F30F41A4B187C18345EF4140B451C16C231DC1754015C2A43B4542233A0F438FDE95C1404DBDC25E9974C20254E741273DA741C4C56C423B03BFC28D7656423FA632C2706C9DBF8EBC434207A09FC24ED52B4280D3BE3FFEA3F0C036208842E8F50AC10920C9C1239E0042500E8B3F72ED1D41FB106640470C6AC1AC2A64C1BFD0BEC164D985C2495C96C20B50734227A583C141358FC17A866CC2A601D6C2B9705541A2DC0DC20CB393C2E293B2423949DEC2042B0E42827436C2140354C28D457D42129777C1C3DD1EC28D23C3429254B8422F9B0FC39CF2BA42082B94C14169CDC22D71AE42CA2722C23896D1C004FF5842301B1842604A35416AA139C2109DD3C2492318C251B20843B28917C18D1A6F426CEC9642887CA1C2A5C5B5426ECA2A42201DC2C2C6BA9542606E7B41633899C231FD15C1D25F80C26A4B87C2FF9359426F430EC1736C19C2DA67FCC1884DBB4038AA36C2F3AA5C4296ABCBC1BA945841E46B44418B93D8C1D8296742641A96C1E85314C279D79EC25F3624C2760F364108D55442CB3805C2CA879BC2FA7527C3A8DF9CC2CAF30D4147664CC26BF78A41D5FD0042F600D9C1E7FF11C3F6F55A426AA5ABC1E803B841DC5123C2423FB8C2B1B16BC2E38CBE419A8EE64128E904C2853B1743000DBA409B3D95C181428342E6C892C1DC4DA14119C11542B6B53742E8B56DC1EF320AC229F1C7C2201936C069FA3642402740C01844284140B8DDC13F77BF414C8595426BA650C201798DC20FD533C27C8C8541A8B088427C522641D35B70C240AD66C272065E42BD552141A1276742645852C3BE68B9C120D6C542A9E40A424842BC4040EBC742958137421CF2ABC19F4B154244789642C467684283A78BC2AFBD0CC28D4E5E42B4842A41CEB864C24C3A5E41BA8BAF4290314743A6E296C1A0DFD6C218E45A41F07444C27440F041CE13FEC265AB0E42696E86C2A014E0429C221243AF89ACC269D82D425A8E23C38C5E874254E709C1363470C29023C9413DB720C21FCED142681A6D41D42F51419A0203C2E80571C2CE05604270022E410C2A254160512BC3CAFDBB4247539D429C7286C1F8CA05C15945D0C0BF0F4AC221549542DD801842"> : tensor<2x3x9x6xf32>
    return %0 : tensor<2x3x9x6xf32>
  }
}
