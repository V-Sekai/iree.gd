// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf32>
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.constant dense<5.000000e-01> : tensor<20x20xf32>
    %3 = stablehlo.constant dense<-0.693147182> : tensor<20x20xf32>
    %4 = stablehlo.add %0, %3 : tensor<20x20xf32>
    %5 = stablehlo.exponential %4 : tensor<20x20xf32>
    %6 = stablehlo.subtract %3, %0 : tensor<20x20xf32>
    %7 = stablehlo.exponential %6 : tensor<20x20xf32>
    %8 = stablehlo.subtract %5, %7 : tensor<20x20xf32>
    %9 = stablehlo.exponential_minus_one %0 : tensor<20x20xf32>
    %10 = stablehlo.constant dense<1.000000e+00> : tensor<20x20xf32>
    %11 = stablehlo.constant dense<5.000000e-01> : tensor<20x20xf32>
    %12 = stablehlo.add %9, %10 : tensor<20x20xf32>
    %13 = stablehlo.divide %9, %12 : tensor<20x20xf32>
    %14 = stablehlo.add %9, %13 : tensor<20x20xf32>
    %15 = stablehlo.multiply %11, %14 : tensor<20x20xf32>
    %16 = stablehlo.abs %0 : tensor<20x20xf32>
    %17 = stablehlo.compare  LT, %16, %10 : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %18 = stablehlo.select %17, %15, %8 : tensor<20x20xi1>, tensor<20x20xf32>
    %19 = stablehlo.custom_call @check.eq(%18, %1) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %19 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0xA36D00C197C951C0E99CCFC0123A8B408A6426C01DE44EC0642350C076E50CBEF39A3DBF18A4534044A2C23FFB8C63C05BCA4BBFE82B4D3FE98362BF8C291D40EF9DEF3EE158FEBFEF5A8A3F3182A23F4F13ACC06A516840397E1CC0138E43BD44160A408968D6407A00C03DA736233F79B7CD3F78E782C0542587BFE8602540D25F08BFDF3C8B4033883D3F86966340734854405F358F40C79FA73F12CD05C094023AC0DC639F3F60C082403961FCBF4797173E3CFB1D3F6C7E16C0E6F2AD40C2EEB4BF1525F54076B42240950048C0AE8D8A3FAF6596409E89D3BC145CA5BF21922F40762029BFB802BA40D80169BFED930A4055CDDBBE8AEF7A4018F1EE3D141CAD4016F291C0CF1BF540C719B03FA5E100BF08DB8F40AD3F0B3B373208C0D171C3BE1769BFBE90BAB13F6DAA89C037BCFBBF48CC54C0687D134047F2513F5DA794BF65E91AC0A281DC3F5EFDB5BF96E1473F01D142BF173DB34068678CC08B76EC3FE2D6D4BE60E96340F143703FE61ED840907ED540268E4740D4AF8C4083BB37401B0831C00605A540791FAC3FCC9D953FDAFA06402F8C33C0BB73BE4072F079C0F79F87BF1FDE48C0D09F99C0F01C114021499A3FBCDBA03F5F09DA4014624CBF515ECC3F6077B4C02A9B5FBFB06D44C01708BA3ED6160A402DBA0CC00C63B8C0383F01BFA5467B3E5F9DD7BF8CA15CBF4087C83E81557DBFB09F71C06B1E64C03C6E55C0AB863AC02F248E3FD3CB9540A611F93FF4007540ABECA3BF7AFCA73F28EF873FD88180BF0206E4BB5C8BE0BF3687ECC01DFC0C3F85B172C0FA674B3FDF758FBFDF14CA3F636F0DC0BC0DF03D655FFBBE2F5993BF1EB7D2BFBDE100C0A10FFE3F0C6A5FBF05C417C04178A240C21E57BFF587FF40E66AB0BE73EF29C0C43C084028CF1740D7AA39407EA912C067FE953FE067EBBE41B1E6401260A1BF8297A0BD4E9AA0C088EEF7BFFE501C3F1BFB7BC0405F8B40FF0DE23FDD1DAD3FB67E5EBF66350B4067057F3E766A31C02517143FE86D98BF7580ACBF750D80BFBA00FD3F1C53EEBF3B0079BF4F4D9C3F75809E40DE9A6BC0B3E3093E47560E3E8CFF77C0014FEE3EE778843F4AB38DBF56780D3D3FE631C0A6AF6E3F39CB2D40329C083FF261B03F315601405ED298C04A3F1A40DF11324063D7A440E03B7FC02AC408C00276203F4A84B73DD160CDC02C39C33F0E458C404BDCCAC07F28E4BF196678408E26CDC08A626040AB6F82BD2DFFA8C00AA7544060B216BF167E79BFEB80C73FA83F09BECE188540B9A8FEBF858A86BEAF9C9EC088320A40734F5F40B49D95C0273E984008E0054026EA4ABEBBB8B0BFE56B314055589EBF1FC38C40117EDABE71EF78BF58EDC73FDB9896C0A99EB940CA510FC037A791C0956C914080B6CD3F6F1FA940CB705EC0FB0D1BC09DC3F2BF65A325C0C1D81340DFFADF3FD704E33F84BA024075574BBF4E280A3F70A77FC06FE4A9BF2EA9D1404F25B93F25025E40F0B871C0AFB680BF8D3B4CC039864940E302353F921717C0E15B4F3FDD7A76BF899C41C074AB8F40E7F6A63F53FA533F4E9443BF2AFA55C0C3EE5E3F3FC415BF252E83BF9B0E4E4034FB64406CF9C54061E72CC0C82B5A3F2BDEBD405726CC400E7E1EC1C736E93EE77C72BE9D4050BF57241DC07BD7AFBF505F8140C1D857C047771740E5D3EEBF4850193F8E69C140E954EB404A8CDD3E1B3C6C3FACDD0AC0D1289D3FD95CBE40CBBB39BDFC7567BF448998BF869D17C0BFDB823EF5F27CBFA5AB60BFEDA760407CBD45408E7FE9BFC4062C406D8A22C0590EE3BE57DD26BFB602BF407BE458C09029E83DF57A45C04BF1D0BF14210540B2A56B4081386140DB4959409BE5E63D93EF154049025040E9C52CBFB541DE3FC19B80BFB22F08C0293A5CC0A5F84ABFCC146FC0506545C040F17B3F471486BD2C887B401B26B6C05C57E1BFC407E73FA800F13F3E48D2BF2B442BC0050D863F114A9FBF28C11E3E16A89440A7D551C0AC4066BE8C9E2F4092780DBFC809C33FDD5380C0536046C0E1DDC83FA44A533FD4F8C93DC09216405608674027B79740984FC4BF584182C0EB10B2BFD05E8A40FC03A440E3DA703E7F05E440BBA65E3F08AE83C03B93EF3FDFF53C3FC11B813F3001513FA3A61B3F942EB040DBDB773F50571140BEE7B04014BD5FBE0D14A9C03B1A0C4062DDAC3FA32E8A4008940A40CEB081BF1E8058BF0B0A83C0EEC51440416AB53F023B7140BC581FBF39039F3E"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
  func.func private @expected() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0x375DBFC45DDD53C12849A4C3A80F1B42F334D6C083764AC198754EC160570DBEFE6B4FBF981B5A41A2660B4077E78BC1B70162BF2BDA633F28A080BFDD17B940D375F83E7B0765C026EAA63F92D2D13FE071D8C294BD96419C23B7C017A143BDA88E88407327CB438048C03D547F2E3FBD381940C112EFC149B1A1BF2BCDD240A2EA0EBF3B1D1B42DD534F3F5FFC8B4108505C41EB9C2F42CBD0DB3F88ED7EC0EFE311C16BE5CB3F36EFED41A86661C02D25183E9033283FDA7DA6C0BF7EE542F27FF7BF7CB684445E13CA40F1BB35C1973DA73F60DB5B42A28FD3BC8859D7BF6194F74072B335BFF8472743E74485BF12A38940BA9DE2BEB1B2C941F37BEF3D158EDF42A14C3FC20C908444B527ED3F266506BF89333342B43F0B3BF67884C0D039C8BE84E6C3BE269AF03FF2AC13C2563960C0DF185EC1E7B69E40D4486A3FAC65B8BFD199B2C07A792D4032CFF9BF71D15C3F192C56BFEC5F074380DF20C232EF4540CA05DBBE57B28C41FD8F8A3F3D52D643106FC543DF7634414F4D224237C20C41C157FDC0FD9CAD42BAE4E43F2C17BA3F05E881402FCA03C1173040435A94C6C12977A2BFBB3738C1523073C242CF98409074C23FD2ABCE3F8A8BE34342CC62BF247B17405DAB0CC3B7247DBF28D32BC1E626BE3EE98F884017768EC033011FC3DECE06BF26CE7D3E818826C0FCF978BFC8B1CD3E806094BFF55CAEC154278DC1234F60C10F1413C1DA35AD3FF7C35742426A5B4027D4B741E48DD4BF3B89DC3F3EF7A23FA83597BF7806E4BB1B6533C0A7C44AC46838143F0C4EB1C18B7E613F6970AFBF27911440C01590C08C9AF03DFECB02BF151EB6BF1ED31FC06B756BC08A7F6440AADF7CBFD9E4A9C0A350A0429D5871BF8299B744DEEDB3BEA587E2C06F8F8440F102AA40441B11412FA29CC0D9C1BA3FABC9F3BE34F7284496A7CFBFA6C1A0BD833A97C2A66459C07536263F8505CDC148C41B42A6A73540B4EFE63F4B957BBF50098B402ED5803E5BE1FEC0387D1C3F7319BFBFB0ABE5BFC38196BF538B624017FB48C0CC1491BF9725C63F1F9E8D420AB29EC1784E0A3EBACB0E3E77A4C0C1C001F73E8A6B9D3F2978ACBF887F0D3D086A00C1C266893F2CBEF040CC2F0F3FCCBFED3FEE326D40372A6DC202BAB0405CC200410FA6AC4243B8D7C119B185C0202D2B3F2EC3B73D433499C3DA1B0C401D332042C69C8DC33CD838C061DAC141511E98C30C2485413F8682BD3397C4C272975D41538D1FBFFA7391BFC3561140F2A809BEF2040042FD9B65C0461888BE451B8EC2A7CC884084EB8241CF8D56C275E96842713B7F40C53E4CBE1677EEBF1CE7FE40FCEFC9BF4FAF2242482FE1BE1A0891BF7DDD11401C3C5DC214402543687E94C0FB8E3DC2D2343C4279371940C65DC542472681C1A701B3C0346B50C01EABD3C0A19E9F408D8E3240641C37403E9972408A6861BF54F6103F4224D9C1985BE0BFBB24AF434867004052478041E1A1AEC17D8797BFF33242C1E81F3A41CC79443F6B15A8C0F6C9663FD82E8FBFA66424C1CE293242F081DA3FAF0B6D3FFA2A57BFEA3C62C17E327C3F00751EBF4C619BBF5CD547415B128F41211E73438163EDC06A8E753FFAB53C43316F9343969B1CC6C95CF13EB4C274BE49FE67BF9508B9C0409CECBF51E4E341E4F568C10616A940B5CF49C0D7A4223FB6D052439D534344D686E43E089C873F42468AC044BBC73FDAA63F4316CC39BDCC2784BFA14ABFBFFA7CA9C0A849843E1C1594BF7CA47EBFF7B48541E5652F412D2B41C08520EA40298DC9C06692EABE14EF32BF5D924343B8CE6CC1F0A8E83D2FAF2EC19F741DC0C42E7C40EECC9E41E3E48641D6476E41E662E73D0E05A540960A4E41E1303ABFEC043040C55D97BF987384C0618079C144EA60BF8E90A7C1E6732EC15C50933FCC2C86BD5896CB41874314C38E9534C0E3473D401C704D40393E1FC03B56E7C02EEF9F3FECB4CBBF26641F3E263750426C0554C1A23268BED6C4F7404AC814BFDBE20B403B91DCC1402831C1D40913407A1C6C3FAC4CCA3DBCB3A64023BD9341C41A6542336C0DC06E45EAC13A52F1BFF2F616420040A842FE14733E676F1B446ACD7B3F2DF1F4C1110D4B40B2974E3F4C24983F6E02693F7D6B253F4615F6423238903FE95D994077B5FB42E68561BE9D17C5C2EC0A8D40CF6AE63F411416424EA38940390C99BF283F73BFC015F0C13CFEA1403C8DF83F384BAD415ED629BFC894A13E"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
}

