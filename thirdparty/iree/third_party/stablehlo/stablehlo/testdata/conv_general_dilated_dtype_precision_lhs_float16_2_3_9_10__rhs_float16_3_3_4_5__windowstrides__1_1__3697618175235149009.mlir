// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>)
    %1 = call @expected() : () -> tensor<2x3x6x6xf16>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>) -> tensor<2x3x6x6xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x3x6x6xf16>, tensor<2x3x6x6xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>) {
    %0 = stablehlo.constant dense<"0x9C42C8C0D2419643B0C119391548E441D8B8A2BCDA4583BD38C3EE3CB8B19741C1C2AB4235B8D94250BA3CBE5345B6391C411843D4BFEAC11DC378342A45E438DFC0444124C79445CDBECABD64BD9BC75E38FC359742224632BAD0B8F941933C1BBB7BC4FB37C33AFEB8CC3C68B5D9C47E4080B8E2BECEB76ABC713D0AC5EA30C23CAD323EB05A33C2BB5EC61B3256C434C93E3F2BBF0BBC893F244486BF17AFD3C0A43C6640D5C3163312B8AA38733C9C336EB6B5C3C529E943373C004045B631B838C218C12FBA6C44C743B142653BD9BFFBBE8F3076C1D4C0214502C469B815378B34FB350E38173B003B8241363738410CBEE243753905374741EBBCD0C2C435233A184527C2BDBD31BD26B550C245B9D93E7944AE449F4302C4B3BCC428653D44467A327AC4B7C259411C3F4E43C3BF75C13BC299C5D7411040BFBB9840EAC2A3464F3A50C368C1DAC30EC1D9423F40A4B3CEC72ABC514294BF233F46403544313F2B37FC3C0BB81148FAC531481B40623CB0BC7F3A54407C1AC13D45C2DFBEE3C62248BF3E94417DBAA742E74047C14F43E7421744BB381245A240913C50C80131123A2138C03A12397944B1442E4389BF89C24E40B54279C4454153C0B83A3D41B542E44689C5CCC04F3D014766BD03BCA9BC5FBB434262C248AEF6C018C186C4823C1E3F8044913D1141D1C438C26DBDD4C3474116C1943C8E3932BF9BBD6C3B1D43B13CD4AE1E3CF5433CA9E3BD9CC4A0BCB93A13394DC47A4158B70B3DE23FB6BEF7ACAEC105C56CC52EB8643771444343943020BD3CC591C01C2A3342AA40353EAD43AC3EA0415D43D23927BE653D893F5EC009321DC47AC9B93D6CC4E73F1BB98BC23BC267BF9E4666C054C126413E411DBE75C465BC47BD2038454430B3033C20C18AB9F13B99BAD6C088C3FB3A97410CBC03452DC2FEC72044C0BA98C6B842C8C024C4BDC390BEC844FBA8E141F1445BC1AE3F1838C1398E286046EFBE1143CBC140B9B739DD3A31BAEC42A042A8BEFD41A1BFA7BE35459D37D3BE63BE8E3EE5BD7B37C8C372C1AABD5EC306350DC15EBF94C445C468404E324BB1833DDD4236482429953E83C18AC05DBEE2B289BAA6C3F7C3E1BCEF3C7544173438C016B13EC16D2C1FC3133D1EBC06C2D3C0EBBC603D28BD4E47453E93C04538913F9B2F203B933516BCF0BC1DA1D03C0C441B4230AA04BFFBC1863570432C3CB1B8AB3C0BB46CC2F03A51406DC4D3459045C44420B895BAB5C15E42F63C0EC2E2C66EBEE94527337AC5BFC43E3D5742783C5DC06DC17144174379B7B9B82DC29844DDBF7DC454C25BBE3E3EE4C259C3623E1DC0BB44F6C0484154C5B6BA553DDD33C337EFBF9438F04003BF983CCD427C4032C76F39C33EC6421D4137BD94C2353FE33B65BE12414EBF82BCD642BB3C01BE0B3C5CBD38C7F4B37F439841C62C9145D6BE29C47DC1E1C20A423FB5E24361BBB842D3448F325339923FD0B8B3C0803D2F3C53C037BE81424BC214B9B93D63C1CFC30531"> : tensor<2x3x9x10xf16>
    %1 = stablehlo.constant dense<"0xD6B4F746C5441C3DCBC64CC0923D09449FC480BC36B46D3E5DC46FC3B6ACBA3DD9B1BFC012B01644C13A2230A7C585BC20C0DE3FE4B45045B03C28C4AA3034C08114F5451642E83D953C22389EBE663C59C893C0F7C163C48095AA4256C5ABBD8B3A3AC1C6C41FC21E42F9429BC3DF36F531094034C93B40574480BD0DC060C314BE913F07BE103DCCAC7A4390B05A372E48AC4563C8B73B94BD5D3D48359F42B6446640A3BD57B92BC49FC18CC31644214416B3B3C42E44CEBCE73F60C40A4007BFF7BA13BD06C205BF983F1E43313F76C1353609BE2C3DD2C15C3F41BEF43FA6C1683C3DC1D6BE38C10FC051BBA4B96E4034314439DDC314397AC41C3E7542124136370ABA65C1604631C6833FA6BAC3C029C2193F1C40403C27C0634551C35B3F173A48B805B38E4104BB93412DBC103E6D3C43C5083ADE416DC03547CFB98140A9B96AC21844B42F0540554010B7B1C4ED430BC06A4993BDFD429DC088C01544B42C7D42923C"> : tensor<3x3x4x5xf16>
    return %0, %1 : tensor<2x3x9x10xf16>, tensor<3x3x4x5xf16>
  }
  func.func private @expected() -> tensor<2x3x6x6xf16> {
    %0 = stablehlo.constant dense<"0xFED242D53BD57BD90957B94EF1CAB1D47453994D74D93FD435D456D47CD4EBCFEC5532D3AA4C40D8CB4985D9C7CF69403C45AE55FB435F5636D4BBD661D01FD524482AD7ED4FB154104FCAD47252A54BBCD277D5E35432CE65CE0457AFD5E1CB1FC89F4F69D4CD48CB50494E614EEB5464D01154D14CF13E1AD64051624F585136D056C941D2A1D7E7D4F5CF1259F24FF95825CA4856E5C81E5482CE7DD56E5992D87E599ACCAB5139D4AB44AF4DD9CFD15413D046584950EDD37550ABD46752FDC98854225033CDEB4D8CD2B0D5B654924FFC41A1D291514E5733D29154D15681C837D6C554B5D12B4906D114CF72547DD5B953EB559DD5C9D4044A92D9BC48EB4E3FC5FD5840D4DACD5B585D4F56CFA34DAF4BC0D0DE426CD8AC3E435869C0714B054D56CCA0CC1F544A52A150A84D9D3D0555E250A1D41FD8075465CF1FD423D2453F3C456FD532D2FB4DD84255D1395815D53DD1FE5032D3DE5242BD0951C050F6555153AED18ED371C8683A3AD9B2559DCD5FD14E5750D4014C03D4D0D05C524D4DAB55E94ACCCB75D2F6D6084A8A53163BB2D1364C8556E9CF43C907C28B3ABBD197D42A55AFC71C48D8549CD5"> : tensor<2x3x6x6xf16>
    return %0 : tensor<2x3x6x6xf16>
  }
}
