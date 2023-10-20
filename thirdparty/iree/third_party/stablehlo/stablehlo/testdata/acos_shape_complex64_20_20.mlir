// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xcomplex<f32>>
    %1 = call @expected() : () -> tensor<20x20xcomplex<f32>>
    %2 = stablehlo.constant dense<(1.000000e+00,0.000000e+00)> : tensor<20x20xcomplex<f32>>
    %3 = stablehlo.add %0, %2 : tensor<20x20xcomplex<f32>>
    %4 = stablehlo.constant dense<(1.000000e+00,0.000000e+00)> : tensor<20x20xcomplex<f32>>
    %5 = stablehlo.subtract %0, %4 : tensor<20x20xcomplex<f32>>
    %6 = stablehlo.multiply %3, %5 : tensor<20x20xcomplex<f32>>
    %7 = stablehlo.sqrt %6 : tensor<20x20xcomplex<f32>>
    %8 = stablehlo.add %0, %7 : tensor<20x20xcomplex<f32>>
    %9 = stablehlo.log %8 : tensor<20x20xcomplex<f32>>
    %10 = stablehlo.constant dense<(0.000000e+00,1.000000e+00)> : tensor<complex<f32>>
    %11 = stablehlo.broadcast_in_dim %10, dims = [] : (tensor<complex<f32>>) -> tensor<20x20xcomplex<f32>>
    %12 = stablehlo.multiply %11, %9 : tensor<20x20xcomplex<f32>>
    %13 = stablehlo.real %12 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %14 = stablehlo.constant dense<0.000000e+00> : tensor<f32>
    %15 = stablehlo.broadcast_in_dim %14, dims = [] : (tensor<f32>) -> tensor<20x20xf32>
    %16 = stablehlo.compare  GT, %13, %15,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %17 = stablehlo.negate %12 : tensor<20x20xcomplex<f32>>
    %18 = stablehlo.select %16, %12, %17 : tensor<20x20xi1>, tensor<20x20xcomplex<f32>>
    %19 = stablehlo.custom_call @check.eq(%18, %1) : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> tensor<i1>
    return %19 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x9F4506BE2EE7FFBDCC5ADBBF74DC7340E7EEEDC04701903F77BDF840CA64273F387150C07ABA4440814E8FC0A25943BF7964894095F568C0F00D9FBF328CC63FB2B8173F6AC0DE3F794024BF51AF7D3E50D07EBF30C77E4089AA4A3F3DF8F4BFF139A33C80E86DBF65EA9DBF0B015240F6DA6B40F67F0EC013BBE33F46425ABE503A5B3F0B793CC07424AF40527F10C0284B32C089829D3E8EE74FC0F80163BFF58C7F4085DE5C4082B24340B0F69240EE9C0CC07B2B9C409370E83F5611AE40925ED43F0DBD1FC0275E5B3FF12F09C0B69421405381F94072B534C036FC843F133D78C0EEB57A40C004D03EBB8D6EBF184D5240D06903C0FE8618BF6B642FBFCAB91A40791DE73D29D091BF9C7511BFDDD1883E48F90240136BD3BD9EE618C00CC3C23F97B97240565EA1BFFA1E363E8DFD5740595DB53F0D396840A6CAC33FBF728440464D1EC0A8A767C07AD729C05195A6BF0C262340C710E7BF958176BFBB521140D94DDABFCC793540A6BB7DBDB6A3623F2776263F9E5DB6400F38D0BFC40B4FBFD2B26BC05246B7BF0F852640FB8C7FC0623C4C3F284626C05889523F016AE53E9B88F33E96A4B8BECE03BA3FED5B19C0CD5DBC405C462FC0B8BEFEBF547A2B3F5D9C2A40F00B7740AAA889C0324359C052FA6FC0F346A4BEAB3289C0F34F4740F0138CBE94E11140DBAAF1BF60637F3F0A01B0BF077713C0931E9240B7D9A840DE82B23F2FA4BEBF69739240A90FC540844859C0881B37C02688FABEA88F84BF5D6C6340E0050ABFCF57BD3F1CE1084019882340A7D087BF094F1BC006A8B1401CA059C04905F73FCCD4053F1DD09D3FCA3BE5BFE1ED16BFD290AB3F9D62D43FE59460C09B3E5640FC9312BEC827CBBD517775400CFC483F291307C042592340CF4DFA3F4F8A45407094013FC6F0F1401D4B2440CEE8B5BF6512F3BF2E37E6BF85FFD1BFA52BA13D2A017E408D47AD3E1A1B81C08F14B5BF6DC5C0BF34ADBDBF3C9C91C0ECAABFBF28E63BC01A5B8C3F2C3CF13F7FAA4D4001EDD1BF56CE24408151693F36D728C08B1D44C04C4E9CC0EE6A03C01A5C4AC00B004940F2485B40D07A86C05ED267C04C80294022CF0BC0B3B498BF5F901A400F79A440F8BEB6C080CA1DC0699AAEC0F22718C0C2BC1BC0365A49407FDF63BFF97B81BF45EA02C06304A13F11E77BBF58AD2F40319DA24086A03D40FFFC62C0599EFDBFC1ACB13F650332BEA32386C0D0B2B93E6A7675BF1650283F642C38BF2EE145C00C0160C0182701407FD879C06B42D5BFE921A8BEDB4157BFAB7500403ED99AC02B1E00C06B5B87C0D2554DC087A69DBF619D81BFABB4B740E3940940E032AEBF0EA681BF4F09DABF801AC1C033999940973C263FF35240BFF30701BFA225B040E4DD864038BBA240A6036EC06BAB9A3F2D18B43F7D9CBCC082F7ACBFD599ED3F0AC29B3FE8D2704070E6A33ED63092C0C6F2243F630860C0EDFD39BFDD0377BF7460403FBE4993C04BFF47C06816D4BF710CE9BF6407364004F81DC02A6304C04019953F621E38401DCB6CC0DF99154067CB733EA71689BFB6FE1FC022691C3F62FBF43E178CFEC04BC4E03FE1AC4BC09E847EBBDF3374BFC1602D3F39F9BC4088CB10C0B0D973C0DF55EB3E6CC5E9BFAE236A409C8593404BB11B3D178C78C0E355E33F3F187AC0DE84C1406066E6BE799788BF1D062040816388C0C7B480C0323907406E82FF3F2E016AC05BFEABC0673724BFAA2F8FC0B8BC5BC065B923C0791F32BEEFB0514079174040BCC84940DAED6240974539BE16D66EC02C81EE3F49A5993E8922B140538869C08A8EBFBEE3E5A83F2CE652C0BBC5F5BEB96F16C0CDB36D403FB071BFC6D3104074B067C0E2EEC4405D4142C01EE8DC40A7BB483F6126123FA37CC2402BB906C0E9189DBFBED4B0BF98A52340B2C2C23F03EF4C409AECA33F236DFFBFB3F9453E951AAD3EBBD0813F6471174059C09AC0428F73BFBD33E13F8548CD40D1BE91BE2B0BA0BEA5AFDCC0E63DBABF845FCC40AC3C2740A777C5BF9D80933F796CEBBF8FD11D4079D2C33FCE04593E3064953FFAA5EEBFB3194B409D6FDC4035DC98C075B5B33F11B3B93FE8EC68BF1D7E474020FC8CBE500BCF40EC1A8C404867014134A13EC02697D3BE77900A412DA0ACBF66EAFA3F1BAD25C007209DC099C8DABFD92DE1BFEBB25EC0F3388CC0B1A9873F180D08C07B4C4CC0AE20EE3F2D085240EF086DC0BB73D03F8B30DCC0F0D3FE3FD4D1C6BFC93B14418927433FA5CBD7BFAD27F7C0F9ADDD3F1237C7BEBD3EBEBF909D3B408EC73D40C6E9B4405C7FB33F60CC083FEFCFCE3F8D300CC0172FDFBF9002823F0166F7BEEC5F3B40626E203F00A52D40680F63C06028EB3CF0FDA04009482BC02F3104404AB20FC0B2E573406E453DC042E30940252B91BF7289DFBDE212AF4053B3B83EB15C3BBFF8FE8F40DA6B50C03457E8BFC076853D64D2C2408A0613C01ED1FB3F744B513FD3DA53C0B008B23E147E9440BC7D4F407C123140FB419040B7BC92407C19C83E3B920DC0554E3BBD09496DC08E53043FEF903CC0D312BB3FDE63064047AFA340E25EB23E931698407545C5BD13A3923F43366AC04FD5FE3F3FB2733F419A153F0DB08E40FB8F8DBF6E93EC3FFBA388C09DA39A405FFCA940E26681C0445BFEBF2E2F22C12A57313F7422FB3F6A4E18C0A4F456BFC66C2540307CF7BF801CC140F5B66040EF293BC0218B4BC0A25518C0051B644063983C3F28F25E4037198DBFF5DDE73FA4657BC0009A1B3EF945A1C078159B3D6B67A8BEDAAD403DC4EE013FD5E79EC04D72D63EE6F8B63F4D4DB1BF78BCA4407D6251C051685A40AD7CC8C0DF7D3ABFF7CC7EBEE7CA79407A6170BE797CC8C048811DBF7D7BDD3DF783BCC0E12DEC3D8FFA53C0EA0639C093013AC0CF7E71408BDE8DC0656D4ABF934724C07B3B9AC0B9341A40D29E183E2A243440D734CBBF83B4C540AC7C2CC0A2C88CBEFA70B0C0F84CA040187A58C04A2D94C0B5466EBE1BF35DC041240F3FA09628C03049633FE3AAF33F6F5BEB3D5B868E40ECBFCB401173C1BF737A263FF62E0AC09ADBEBBF59B584C0D0116AC0DCC7D8BEAE20F03F3AAEB2BE149BC1C04AE191C00EA9A7C04B8D82404836D63F0B511FC0739DEB3F6AD1A3BF0268BAC065B18B3F5A352D4044DB2140BFAA1B40BB0E603EDE6A40BF7F69163FDF2595BF3B7E8540DD9EB53F640A9FC075D7D2C05841983F331C7340BE9462BE9DF9F43FC32874C065719B40D177053F58448BC02F7A21BF89DDE3C0B36BC13F671603C04DE93ABF085F9A40DBEEBDBFBE1E3BC0FE9453C08CA9923FDB978F3F4485C2BC397C1BBFDCDB1540F6F03BC05E87904061AF5E3E29509740BF6A8E40B2A528C0F85BB5BFD3120D404F126D401B09963FC953A640BB82BC3F4B209DBFC0394E401FE16C40E9FD1BC0867D813FC09448C00DA150C0C7D0DB3F2C5FEEBD4B833DC0C987904074F319C0F6DA67406B3804BFE6EEE5C0B834DDBFDC95FE3F5379D7C0FD4F3DC0EE1967404080DB4075B0963F526A013F21585FBFE19931C02704B6BFD2FE1B3F8E060240EBF4A73E41E886C07799313FAE55A33F02C454BFC702A1C0DA820B3F3C3E93C00BC2FFBEC3093D3F8DD7A3BD63B43CC0C2265AC02F742DC0CA0B5540FBDC373D75B959408324543F5DD7293FC6C866C0FC82CFBFADA66CC0BD69183F337A9D4015D288BF2D7AB7C0EF14213FABF96BC0E8D19D40170B453CC90B8E40830F16408DC8D23F224765C09E0C8C3E69EBAF3F9DA62CC0D8669B403842BFBF3191E8BEE9B0C53F4A2031C000F81CBFA9BF87C07F329D406748A23F78938BBF62F908C05BFD67C0EAD5B93DF02A8F40748221C0F08D3640A550823E6F7C4E3F62A57940EB6669C03253794092F690C001679B3F17C84EC0410D7ABF112283BFB21C424024C9924001BDC5C0AC9D9640AD40394033EA0040A92831404633B0BFA1E194BF569AFA3FD6AA07419372A23FC57D223F3860F13FE48C0BBF49CB2840BB7A7DBFDA421FC0BA12C13FA94FBA3E45BA80C0EC787C402835473FB6840D3E37B0AAC0D79B0B401BC0DCC083E83740DBCA97C0C0D0DFBE225C1DBF7C2883BFCEA60B4014CA2340786A8440EB9FA83FB6E9BAC02B16094073B45140ECDA4440F85F943FD6EB06C057259B40F13AE9BFF36A9440C17DD5C0F91F43C04930BDBF1B542DC00875C5C03F13A4C0843C97BEFF7082BF495036BF3D3BC0BFBCF9944050BF6AC0F59AE93D347C25C04EC8BBC04542DABF72DFE5BFCA5598BE78333540449141BFA56ADEC01901C5C06489E8C007F22540E3CBA1C01D60BD3FB87AC23E276C5DBFDB2ED1BDE460DFBFB1D220407F848DC04AC4C33F28285D40897CA6BF0C7623BFB7F4723E5AEBF8BF356C8CBF230C6240A25F6E3FDB8ACD40889BBCBF27BFA140F1F3503F2B6DA84002D0E63FDE0C2DBF767A2F4031793F401D6672BF2C9F88BFF2C3B1C05AAC96BF3DCE203FC86098BFF76B1C3F"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0xF4C2D93F8CB5003EE4D3FD3FE67A08C0C85D3F40DB362DC0374CAD3DBF912FC02AD9174092480CC09AFE3D40917C0C407B05363FC9DE1A40D2000C403008B3BFCFF3A33F8ED9ADBF8DB30E4031E99DBE0D90E73F9B8B07C0B3889B3FDE25BB3F9931C73FF4A0543F8974F53F1B3AFBBF223F0E3FDA670940A09E123E697B983F5C8CA63F00FBEA3FC9EECA3E94DB1D4050884140547AD8BF3F3F3740EEA7F13FA5BD383FAFBF16C06AAB7D3FFFDF19C0CF62FE3F5A1718C0E364A03FFE861CC0F324813FABB1E63F2D229C3F951CC83F7341A13F2B2F33C066463140F400E3BFFDF31540FC9F19C0DF42A33FB5E55C3FDAE4123F3199024098E30340A8D5363FF3C2513DBA09C4BF176A214001BD5D3FF817BA3F9835BCBF6729CE3F2690CD3FE681993FB22407C0AB063B40DD0B3FBFEC9CD23E0423FDBFD060D23E5A5C03C02F5B0C3F07B91040A6CE1F40663A0C40F93D014078A9E1BFE73426403874B03F71B72C3FBB61DD3F0136BF3CBAFCD93F3C32573F51D949BFCC51903E4EDB1D401FD5E33F754E0240B6430340AE0CE6BFC90D3C406F5105C0401734407973D5BF1EB2943FA7CAFEBE040AE33F73C497BFE4FFF93F6B0023C0587D1F402E08F43F9264AB3F71C3DDBF9BCD583FB6B21C40DEFF1240F72C14400860D23F398B0A403458BD3DE245E73F9E5D383F6916E33F054F823F41EDA03FC8F40140972E15C00D78863E638018C0CC8AF03F897A11C09D16023F2805294020883D407866DD3F6129EC3FC71601C03D15EF3FEB3A9CBF3B50653FAF61F3BF67B4FA3F9D7FD83F970A0E3FD1162440ACB49A3E9624AABF11D5813FFDE5BE3F6D4BF53FB77A93BFC31D923FE8D603408162373D248EF03FD543CC3FC07903C0662E9F3F2050C53FF8712D3F7083EDBF45762F3E397BE7BF53D2A83E621F31C064080B402B2BC93FA8071740B673CA3FDF99C63F5A9605C03AA9BE3F1ACD0640D622114036B6B63FE78EF03FD11E114024920140D622F33F66038B3FCA0AC0BFF8D8F93E2A8BFB3F5BDCB93EBFFAD5BFE00F114053F10540782D2F40FFAD164000351640F1020CC0A123653F7CAB184010E41F4014360CC04DC1264067D0CA3FDA96913FDCD41BC060AC2E400D0F2140796D2E4007361E40BCB20D40F1FE04C05CD00A40FD02843FB12823403D9AC6BF0DE2F23F6494E4BFEBC2083FBA8A1DC05E9C2740B9940540C00D343E0781603F4E604340896907C0FC7D16402FE053BFA502E53FE65BEF3FBFB82640923E05C0E6952E40A9440840E923E93FD0EC483FFE8A973F4EC3164082440040F5970F4011A73040EFB7F43F3918DF3F72A01DC039D8193FBC58CE3FC09B0340297DB43F43CB1D407A072FC0F544873F5EEA473F7890D43F894B1AC01766623F654025C0C850344088C702C06D74AB3FCB0D2040520D0A40874AC5BF292EA23F642D05C02050C03FF37C0E40529DB23FA188FD3FA81E05408F2A743FC2CCB43FBB980F40E1C328408305F93F28BC0740A2BAF5BF9AE21A402EFDED3F41019A3FD612ECBFBE3B2440177E0AC01252B43FFBBB703F797B38404545CDBF786EC13F1B723140D2828A3FE63AFF3FF16BC93F8B31593FA9A5BA3F44DF1EC05A1F0640F2080C40E81AAD3FFF30B13FC62F683F78E81DC046D9C73F4B3B04408ABB933F322C0A408F379A3DCD471F40F1C6F93FE9BADBBF642F184005811D404A5F493F1041E1BF87690A40B14D2440DADCDA3F82A60D40E43B1F40683409407B8ECF3FB6AAF3BFA3B9523F508E0AC0319E593D984DF83F6FAB2A401C3807C04F3DC23F687B1AC07444424020B0FC3F7EFD993F52B6FC3F41E6E03F319CCD3F0CCE833E8A5E0140311A833FF4A50940E6C5EC3E366B2740570BEA3D351828C0023BBD3F808E20C060CA24408C47C83F9EB90240EC6AE3BFD72E923F0B57FCBFF1E8843F16D1C93F1987B13F13C6ACBEC378983FD817D5BF775F3C4030D41140BC29A73F13F225C0B027EC3F3E76A33E5F9F3B40EC0A2940C1BFC83E86BE27C0DEAD1B4044F6AABFBFF60B4035A1E9BF4D48373ED54181BFC802873F57C6C03F4639923F7E362EC099683640588C12C02DFD243FC3F3993F295FBE3DC566E73F6F46193F72D42FC0DACBB53EB20C36404E20CF3F55CE36C01F97084014F2C9BFEE28034044591A409E3D13404A0CCC3FEDFC0E402BB01A40180B923FAEF2CA3F583E26401FE3FEBF01175B3F52CA12402299AB3F8FD429404F96333F8757CE3F491DA93DE8DE3AC0E45BE43FACEA3040D24D873E0F31983F626A014086CEF2BFA3DE8B3F903A23C0C07EEB3EE05A82BFE96A773FD355DA3FA19523404A2FAFBFF1EADC3F9444E7BF02ACAD3F1366DFBFB18548405432F8BFB49EFD3E35761B4083855A3F5BEAE73FF5A12B3F8CE810400997053F81B9C73FC892CB3FFCAA19C0C8D8A33FC54A343FCB5B223FF4F01940BF4F46407E1F9ABFCEC2BA3E81F12340732AE03E9D9FB4BFC60A424081B9EFBF6A011E3F50241BC0579C833FC23A17C0F55DB23D364D0DC03B944740C246B73FF9DD3F40DC6EFFBF045D2A406E5BEFBF7CEC973FB22D1AC02AE5BF3F36FA10C0852AD13FB8707BBFDC6128400A3207C07D47423FEA4945BF29CF7E3EDE440D40BCD3953F41440F409A63563F44912AC020312B40C4390C4075AC4440049740C0021D683FC3A6E93F2BEAEE3F4421DCBFE04AF03F78DA22C0D3D1343F697A0D402EF51E406260044056CD583E25D0FBBF93B1A23E1099FC3F7B05933F99A60A400747C53F638514404ED9BF3FF8EBA53E2DB1C33F5809FABEBB904340288212C01A10553F6756B13FA97F123F88E81F40A7BE893FAC492A40AF2D15407080AC3EB97F7E3D6290024097B7424095B52140DDBEC63F0C541E40FFCBC43FF2E7F43F38AD15406CAE0640D9765F3F542F1D409B03ED3FAEC4DA3FFCF12A405BD317C0FCADC23FEC31E1BFD2E1E83FED4B23C0AA104240BACCD33FF69219409ADB2CC064720C40CC491C40D24DD13F70BCFA3F80EDAF3FFB67DB3FA531963FE86EBCBF11D7C53F5EC60CC0075F713EEF4024409BB5A63F9ADCC53F9874FD3F00AF0D408B664140C032FD3F0BB65B3E017FA23F88771F4051E12D40D05D1E40437025C0EB7C803F57C4E63F5206283FCA3FBE3F6E0A3D403ED11DC0DD0E453F561E00C03C42C93D6E62C5BF2E1A0E4057F02EBF4F12EB3F20E60AC05415A63F29FE154009813D4003B725C030FC763D7AC20040FCEA8E3F3EC4094003ABDF3DC33711C02D9B3F4083570A40198E3B404A202BC0DEB6304085D7B63FB9AD9B3E7D711340461012406A7E0B406BA55E3F7AA596BFE4A8CB3FAF42133F182B6A3F145501408A0F4A3D3E230CC0CDD3423FDC1224C072ED27405518E33F87D6853FCC490AC0CC24AD3F77F017C0AF61433F0059AB3F235D5D3F1A4512C034202E408CB4D1BFF5C11440F6FA0C40E60BAA3D66EA913F6A2C0940DA8518C0E4460940B1C50AC0DB28D23F790A2B4029131040409BD5BF015A2E40CEDC2B404B798B3F78942FC0E5280E3F621C5ABFE508EE3FD770E43FA5222940B4F987BF3AD93A3E2957ADBFE4543E403F7508C067AC2F3FA4F38A3FF8044240E98513C0A7F941404FAE0D402C5E3F3F9673F03DBC65114019D90C408D6B0F4074CB09C00D71C73FEB20F8BFF7A0633F7D4846BF303B2D40B6A90340BC773E40D487FFBF40525F3E493E1340B9F541405C091CC0D6360D407CD120C03FB9C83F928B0CC0BA4A243FF248DEBF2DFC43405DE8F9BFCD708F3F129BE83FF3AE9B3EBAE01340724DE83F144D9FBF72303A40D65BDA3FA1BE1140651F24C0CCC74C3F505B9A3F25E4054027CC08405987C63F640C0DC0B4CC11403E1B02C0CABCAF3F121040BFF6B2423FA28B174031115E3F17D61E40EBBD9C3FCC4CF93FB9C80D401B9A883F407E7E3FA1AA19C006251F40C77D2FC0958F203F5535F9BF2579F73EA336E73FFD5004407436C5BFC72A193E39AB35C050BEA33F7BFDB6BF738DE13F1E6FDBBF68B0F63F520ADA3FE6A89A3EADEE83BFF4EA164020011BC04FB1343FF18C58BE9ADF2F40031C1CC09F982F400AE22CC0200C4340CD8F0F4099F8FE3FF030773F61E7623F8E81F4BFA8DCA13E85A509C0AF4B3240780921C04924443FEB800CC036108D3FF62CCC3F3245BB3EF62B1540BC82773FC286324065082B405638F33F317DFD3F1EB42640AC4E454042781440147317401ACD643F133EF03FD68012C07EFE46405BB2FCBF5C9EFD3FA78D2340279012403F60CD3FF2B5D53FDD57E2BF29CBD63FA323294064571140DEA23C40ED338D3F9ED71B404145A53E41D581BFC47425402DD8443E18D309405725E9BFED493340108C0EC034C6BE3E5626FE3F22A60E40C15497BE273B25402580BC3F1BF3883E8E6BFCBFC385693E26B42440041A273E344C14C08894AB3EBBCA19C0B247E63F460DE1BFD6E8A43EDF67E83F3FFFE03F83B91B40A097204082D26CBF05BB2140E1476CBF"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
}
