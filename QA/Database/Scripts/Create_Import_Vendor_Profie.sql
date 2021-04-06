IF NOT EXISTS (
		SELECT 1
		FROM dbo.SYSTM000Ref_Table
		WHERE SysRefName = 'VendorProfile'
		)
BEGIN
	INSERT INTO dbo.SYSTM000Ref_Table (
		SysRefName
		,LangCode
		,TblLangName
		,TblTableName
		,TblMainModuleId
		,TblPrimaryKeyName
		,DateEntered
		)
	VALUES (
		'VendorProfile'
		,'EN'
		,'VendorProfile'
		,''
		,2241
		,'Id'
		,GetDate()
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM dbo.SYSTM000MenuDriver
		WHERE MnuTableName = 'VendorProfile'
			AND MnuTitle = 'Vendor Profile'
		)
BEGIN
	INSERT INTO dbo.SYSTM000MenuDriver (
		LangCode
		,MnuModuleId
		,MnuTableName
		,MnuBreakDownStructure
		,MnuTitle
		,MnuDescription
		,MnuTabOver
		,MnuMenuItem
		,MnuRibbon
		,MnuIconVerySmall
		,MnuExecuteProgram
		,MnuProgramTypeId
		,MnuOptionLevelId
		,MnuAccessLevelId
		,StatusId
		,DateEntered
		,EnteredBy
		)
	VALUES (
		'EN'
		,2241
		,'VendorProfile'
		,'01.09.03.03'
		,'Vendor Profile'
		,0x504B0304140002000800210A8652CC29177C5C0100008802000011000000646F6350726F70732F636F72652E786D6C7D52DB6AC230187E9592FB3689E7855AD91C0341B13061630C46487F35CC262189569F6D177BA4BDC26AB54599EC32FF77C8F71F7EBEBEE3D13EDF043BB04E6A354434222800257426D56A88B67E190ED028898561425B48AD3660BD04179432E558268668EDBD61189BADDD44DAAE7026306C2007E51DA611C5A8E17AB0B9BB29A8900B662EFDC1C04D6A0D36ECBD930DB1288AA86857D4162114BFCEA6CF620D390FA5729E2B01B54A9846E42A868BCADE54092EB5CDB9779589E1E293AFE068D6C339789E71CFF17114A16966819238134C58E05EDB642685D54E2F7DC085D05BE5637C81C6E7299C0A9005657A76EAB5465EDAE3C7C5134A5A84F6433208E9DD827658973042DE8E5E57FA6A351BEEFCAC5CD95242F670482693E7E03E4DD3F97CFA3EEBA4D38F726DD9589B438CFF929B40F9B9F66FA2160D492724BD05E932DA67A47D91A836A82259D8C9E34925B45BFDDABCABD7F52D25BF504B0304140002000800210A86520B738179B90100007604000011000000776F72642F646F63756D656E742E786D6CA594CF6E9C3010C65F05F9BE6B586DDA0A85444A52453D548A94438FD5600C588B3DAE3D40B6AFD6431FA9AF50F36F592552D43407187DF6CCCFDF8C0C7F7EFDBEBC7ED24DD449E7159A8C25DB9845D2082C94A932D652B9F9C4AEAF2EFBB440D16A69280AF9C6A77DC66A229B72EE452D35F82D5A69C25E894E0305E92ADEA32BAC4321BD0F38DDF05D1C7FE01A94610BC6FA1720AD84438F256D056A8E65A9841C51A13C899F411F6BB072A169F12FAE34B8436B37016E8154AE1A45C7D1D9C9541287D69D4967C8E6E468284A2747E9E063A9E85ECBEF74B3B69BECDFD7EF9D833E841558BD8F77EFB0B52BEDE500DF44BB05D3815FE7F85FCD9E8D2BB9781B60770268917EA90C3AC81B99B161EE513F3E176CB8CD3916C721DAF1F5E086E0A6E07F467DDA4193B1DD9E457C5ABAF5CF16F99CCF4FE539E261B85A8F048E42B62A32163EA63E35A08385EFF77803E2301397E4CFA6585327EC68C94B4113968E562E671BF9440F50C91962ABAFE0C25E234B0A9FEE7E3F1EE754559F4942BB8A1C8950AFBA96504897B18FBB5196887426AB964619CFE7096C8631C81F2D34DF544175000D79DE829073D5D4C3629F2F93E6EB0FE4EA2F504B0304140002000800210A865228B65512E1020000720A00000F000000776F72642F7374796C65732E786D6CDD55C16EDB300CFD15C3F7D64EB0155D50B74833042DD065C1D2EDAED84CAC559634496EDAFDDA0EFBA4FEC2285972133B6B072CBBCC174B14F5F8F4484A4F3F7E9E5D3C542CBA07A5A9E0593C384EE308782E0ACAD7595C9BD5D1697C717EB61969F3C84047E8CDF56893C5A5317294243A2FA122FA5848E0B8B612AA2206A76A9D6C842AA41239688D60154B86697A925484F2D80216227F0F2B5233A3ED54CD959FFA99FB4D05373ADA8C88CE29CDE2096174A9688C9672CCF5B6257124BFE3CA3D61593C1CB6A689EE1919E1EB60047EF479611197B44040A28E16633B05A2CD5853D27AE0CEC4334BBA7C6577667F770072060F26444A7D746BBFA11C74774192355C2A2077978042427779430BB199A0224AB0B03608C7ACA554A8B4C59DD5D51213DADDAECB2298720644D943AE28C329A98DE8E08CD174F5284BE07D1C4972EAF46318EC53CD20203416D4F9ED3B27A83B85DB88195C1950C8F7247D5EB2413CDAB657D7ECA2525E38BE4A9B1B17C4F93358193F54745D9A67FF1C7542ED6BC2162DDF9D63D874776D5FF360B1C021E5D2A77C3BC949AF805D83E076F328919D248AAC1591A5A5E696AE8B2C9E3BA645B3CB26CF6EE4A46A533DB3FDC33C9B6F53D74DBE36E6AA19A8669078D87EE8BCC4D839EAB8137AF25A687F96681E9847B6F942CEA1A257B42880FF1D897E589BCCA8A9D89018A2A1F8C883C3243D3087618F03163A282CDDBBB8456E4A8809D596087ED3A977A883D5DE6C0CBA77C36FF818B2B4BE5B5C6EFFAC1EA2DB66E75E19CC9235747170ED9A64E33BA2895A3C90B8F59C00631F48E32EE40BBEB6FE9BE5417ABACF61298C11D50B08AE1F5F8048760925DB2751A1D84DFE5A92F788DA97D1E9172D6825F137D85F67B769DC17F412DF30BC4A9FF5DAC9BA7D5DB2F88D1BE025132E255D12BCA8FD64A590871FBB826A4A294D77853E386E9B9F832387C41E1C98E28B5EC0D5BF83FE7278E8A45726FF639371773FA3683B8D364BF7DC57D10DD5EDCBE9E1C2489FFF02504B0304140002000800210A86520804E60B730000007F00000012000000776F72642F6E756D626572696E672E786D6C0D8B410EC2201000BF42B85BD08331A4B46F41BA6D49BABB84A5E2DF3CF824BF20C799C9FC3EDF717EE3A15E502431797D1DAC56409197449BD7675D2F0F3D4F637374E2134AB7AA0F24AE79BDD79A9D311277C0200367A0DE562E186AC7B299C665C9852388F4130F73B3F66E3024D2CA4C7F504B0304140002000800210A8652E741AA3DB80100006B04000011000000776F72642F73657474696E67732E786D6CB594C16EDB300C865F25D07D71E236D910D42DDA43900DC87A705F40B1685B882C0A121DCF7BB51DF6487B85D14E04AF29B04BD19BF8FDA47F9212FCE7D7EFBB871F8D999DC0078D3613CBF942CCC016A8B4AD32D152F9E98B78B8BFEB360188988519E7DBB0E9325113B94D9284A2864686393AB0AC95E81B491CFA2AE9D02BE7B18010B8B43149BA58AC93466A2B864F2A1D9C91FD932C8E95C7D6AABC960E66DDE6244D26B89164CC8252B6865EE421277451FD9C465DB684BBDED56025F10CD7E57002FB68D5B3523B908AE7BC4E28B07192A6537E1E94D3AC6C201367AA0FDA68EAF7A840B0D47AFD66018D2E3C062C69CE250996A52E605C818896CBD52BCF6B27E46BF05A018F6A20A7DEC0162DE5FA27F000DFDA409A3F390EF98E16FEDB01EF90AD9FF9265F7A075B90D47A081FE5A6F03BD2D668B7D7DEA3FF6A1558FA38375D96E0D9414B823DBF28EDB11B577D7918EF354E5EBD25E3F3A11EF6D2B9731B876A9909A3AB9A96432571A4A43F8EC1A14A2F5A3A6AE9591B035914DC35675F0E134B23FB27EF26B29B89DD46763BB15564AB89AD235B0FACE627E08DB647DE483C0EBC4463B003B59BF437282E24FE35EEFF02504B0304140002000800210A8652E873B14F34050000C219000015000000776F72642F7468656D652F7468656D65312E786D6CED595B6FDB3614FE2B84DE57C917D97150B7487C69B7266D91641DFA782CD1126B4A14483AA9DF86F671C08061DDB08715D8DB1E866D055A600FEBB01F93ADC3D601FD0BA3E41B6953BDAC6ED102B1014724BFEF9C8F87878792F2ECD7DFCF5FBC9D50748CB9202C6D3B95739E83701AB090A451DB19CBE1075BCEC50BE7615BC638C1488153B10D6D279632DB765D11A86E10E75886533536643C01A99A3C72430E27CA4842DDAAE735DC0448EAA01412DC76AE0D8724C0E82837E92C8CF7A8FA49A5C83B02CA0F83C2A3CE28B0E1A892FF1113D1A11C1D036D3BCA4FC84E8EF06DE9200A42AA81B6E3151F07B917CEBB0B169525648DD82F3E73E28C118EAA0591478305B35EF7EB8D9DA587EAD4C33AB0D7EC357A8DA5C5020141A0665B5903FBBBADDDAE3F076BA8E9A5C57AB7D9AD554C82E6A1B646D8F1F3AF49A82D09F53542BFDFD142A9A1A697BE2532CD6AA76E12FC25A1B146687A3BDD7AD32414A8989274B406F7FC46ADB398F2023364F4B215DFF2EBFD66758E5FC25C2DD3A6065259967709DC62BCAF00C52A83242992930C0F2150B80E5032E004ED912856499841CA84EAF6AA5EDFABA9DFFC5B2FAEA651816D0C1A7DD61788F5BE5C12120127996C3B1F29C38E8679F6F8C7678F1FA2D33B8F4EEFFC727AF7EEE99D9F6DB4CB90463AEDE9F75FFC7BFF53F4CFC3EF9EDEFBAA842074C29F3F7DF6C76F5F9620A58E7CF2F583BF1E3D78F2CDE77FFF70CF86DFE130D0F14724C1025DC527E88025F9E42C2EF080BF22E52806A25376D248400A39C906EFC9D8805F9D00051B70179B81BCC155F1B0222F8D6F19A20F633E96C486BC122706729F31BACBB87D62570A775A2CC66954E29F8F75E001C0B1D57D6765A97BE34CE53FB11AEDC4D8907A9DAAD58708A758A27C8C8D30B6F16E1262C4779F049C093694E82641BB40EC8139220369675D26895AA08955A35A7A2342FB37D02EA356075D7C6C42D536016A358AA911CD4B309690D855434275E81EC8D82AF470C20323F042AA458F3065A8176221ACA46B7C6248BEA2EA4E4906ECD3496242B924232B740F18D3A15D36EAC4906476DD248D75F08762A43216D07526ED3A98B967F2B65A1048CB57FE06C1F21577FCC7AAF0DA93251F1973EB1EC1CCDCA3133A049CCE8F09A3E027247D61F55FA9FBFE1BAFFBAACC3EF9F6FE7B56F17738B16FB2D53A5F0A5CADEE1DC643F27E14F72E8CD3EB38DF4067B5FDACB69FD5F6E7ECF23751D19745DCD56FF60B3B49E99DFF90507A282714EF89A2FC0B35C5B0AF3A8B46415A3C6964B1BA9CFB33801187E21A71263F21323E8C21537E2A858B48CC6C4702654CA813C429355E9C40E3649F85D3DE4A65F1A0AB18209703EA085A0CA8134B4EBB1B4DED616EE1A1684542D7E017765F5E87EECED451B3E968D65E5247C5DB9890964DC856E5B9425C6D79D48E4490BF19F1EBB3D70B22008AC37CC1E666293EC0819C999BAFFAC633A034C06624AAB609B7EA9BCB0043879E89A60E3D456308F15AFF8673A0D52A4981AA5D4973EB6DE480BB5E4C686AB6D089DAA1355F990A924CD9147985051AA56D2790B390FFAFFA937121BB20E229AE189AC94D88C41C5192A8AD602C084D979A2AD5A6F7EE896A79EF4EA4DCD5C5C4C3A14A82929E65538DCDAC58875F179D37D858E93E8CC31334A0637E002A5A7EB392872E24422EE21812AE65F532942B056BB60D8D1772CBED09348B6176D218157E8A2FAE177AB489145257A7E5DAA23888FA1B39915FCC5A299B65C74AB3BC8ABDB95B004D57AD44976FAF75AD2DEF45A7C5EB9F0B9ABCAD1279B51279A587C8266F1834878DB2F855CBD775B387C26A46BBDAFD68D15AF907C9BCE7C27F504B0304140002000800210A86529BC13E5CCF000000B00100000B0000005F72656C732F2E72656C7395904B4E03310C86AF1279DFF19405AA50D36EBA61872A2E60259E9988E621C7E57136163D52AFD080106A51916019E7F7E7CF3EBE1F96EBD7B833CF2C35E46461DEF56038B9EC431A2DEC75982D60BD5A6E7947DA12750AA59AD692AA8549B5DC21563771A4DAE5C2A9FD0C5922697BCA8885DC138D8C377D7F8B72CE804BA6B9F716B673308F6F85FF42CEC3101C6FB2DB474E7A65C08F4423938CAC16F0258B47FF55EF1A170C5EB17159F83F46BFEF8A91953C29E1077356A4758B06AE6752CDE7A1D5EB67E45B0A2FEEBE3A01504B0304140002000800210A86524DBB813A3201000013040000130000005B436F6E74656E745F54797065735D2E786D6CB5934D4EC3301085AF62795B256E5920849A76016CA10B2E609C496B11FFC83329EDD9587024AEC02469B340A52DA26C2239F3DEFB9E2DFBF3FD633ADFB85AAC21A10DBE90937C2C0578134AEB97856CA8CA6EE47C367DDE4640C1528F855C11C55BA5D0ACC069CC4304CF932A24A7899769A9A236AF7A09EA6A3CBE562678024F19B5197236BD874A373589870DFFEEB1096A94E2AE17B6AC42EA186B6B34F15CAD7DF98D92ED08393B3B0DAE6CC4110BA4500711DDE847C2DEF8C427916C0962A1133D6AC732F51652A9CA601AC7D6FC78CE81A6A1AAAC81C1DFA6C5140C20F211BB3A1F264E5B3F3A59C437EE05125B2FDF64883EDD02695B035EBE429F7B061F88D8F11F0D76C9473BB07D914244BEDB097EDF617F795B77C6F40889EC39DB267E71D07F277FDE7A17333055F7C4675F504B0304140002000800210A8652CCEE7FCCE2000000B10200001C000000776F72642F5F72656C732F646F63756D656E742E786D6C2E72656C73AD924B6E02310C86AF1279DFC94C17555511D8B0E9A68BC205D2E079A89387624F55CEC6822371054C413C2484BA98A5FF389F3F39D96DB693D9AFEFD50F66EA6230501525280C2EAEBAD01818B87E7A85D974F289BD65E9A0B64BA4E44A20032D737AD39A5C8BDE5211130639A963F696A5CC8D4ED67DDB06F57359BEE87CCD805BA67A5F199060C1EB1E2B50CB75C2FF0C8875DD399C4737780C7C678EA60391846873836CE05817C201A5EF4B7C0C7E548530F82FCCB2D08BC5397A28B24066E9A1711772825EADE4943C7459CAC8715F860FC48BC55F790CABB389BEF978D33D504B01021400140002000800210A8652CC29177C5C01000088020000110000000000000000000000000000000000646F6350726F70732F636F72652E786D6C504B01021400140002000800210A86520B738179B90100007604000011000000000000000000000000008B010000776F72642F646F63756D656E742E786D6C504B01021400140002000800210A865228B65512E1020000720A00000F0000000000000000000000000073030000776F72642F7374796C65732E786D6C504B01021400140002000800210A86520804E60B730000007F000000120000000000000000000000000081060000776F72642F6E756D626572696E672E786D6C504B01021400140002000800210A8652E741AA3DB80100006B040000110000000000000000000000000024070000776F72642F73657474696E67732E786D6C504B01021400140002000800210A8652E873B14F34050000C219000015000000000000000000000000000B090000776F72642F7468656D652F7468656D65312E786D6C504B01021400140002000800210A86529BC13E5CCF000000B00100000B00000000000000000000000000720E00005F72656C732F2E72656C73504B01021400140002000800210A86524DBB813A320100001304000013000000000000000000000000006A0F00005B436F6E74656E745F54797065735D2E786D6C504B01021400140002000800210A8652CCEE7FCCE2000000B10200001C00000000000000000000000000CD100000776F72642F5F72656C732F646F63756D656E742E786D6C2E72656C73504B0506000000000900090041020000E91100000000
		,'VendorProfile'
		,0
		,1
		,0x89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000002A744558744372656174696F6E2054696D65004D692035204D727A20323030332031373A30313A3035202B303130308C96156A0000000774494D4507D605170D313595ABE506000000097048597300000AF000000AF00142AC34980000000467414D410000B18F0BFC6105000002E34944415478DA7D534B681351143D93F9C5363536B66A1BD2F4A35544145C680515BB72215524200882829BBA11D18D4B1782B87567C10F8A76A1595445C55FFD501585B441DBD2D684FE4CD336696292F964BEDE095350FC0C9C796FE6DD73DEB9F7BEC7E0F787C1FF1F1B7F235CBEDCBFB358CC9FADADF56DE1796E8D65593E4D33A028B22C49A585D9D9F4D8D4D448CFC0C08D3714AE10AC6501CE7905832B5F1D3DBAAFAA54A2555A5655039A6641D72D6F2E5708A4D34B9B7A7AB2BB29F420E10BA1F89B80C7237893492097FB816CB608D3B42AF34C2643631EF1F8308D4B3C853A22DFFF102897559D6521CAB249812A6CDB44B1A8921B270D0D82C0D1268C63BB8EC0BBA9DBCB028C28729EAA2A0D8D8D2C02017FC5BE24AD80CF172432038EDB8B747ADED7D979D5138D467744229119E2E94E2D2A0E64D9506559E0532989020BA8AE66D1D25A8D7BFD49C4264B9068EFA09F653BBABAEBCA65BDBEEEF4C7B7992B1D87899AA90888A2CDB0AC464205CADF4428B40AD71F27F02096474225AF2D2D54283F838D678E8F3C19DEA389D65AB71EEF2A028A625B54486CDFDE40B9CB1591EE436D38B1DF44563270F1DE085E4A6DF06EDD8826AEBD3515FBAA90EE66A2C62A021C67680AFDCAE7751CB9330D4B10A09A24ACEAF0F3366E449A30DD3B6BFBB910B32BCCA1F7B36110ADDAA95F4540D719B3BEDE4B1D28A3ECE17160FF267C9832907FFF11BDC79A11B99B85C4FB50181A95E7060D73293D3B4F34D3E9842360279333D1787CC3A970782543D6D03F65E39BC141A52E9CBF3D8E9B91309E3DEAFB74E9D2B9695A5E20D09143C2C99E751C0C0CDCFF3439B9A88442AB83D1512BC0CF8D6331A331A8A941521571EB490263294194143B8EC2681F515E13869D2E30BF1CA846C2B6DA930F2FE4AE750D61DD0E03F57B9B6B1BD6B7783455CF8E3DFF82F91713B0CA4F292E4E901CF7BFDE3E47C4470813DA098B842AF73B40D008138441F7381BFFBABEA25B61D51575E6827B744BEE3DD097837F024ED954FC398D194D0000000049454E44AE426082
		,'FormView'
		,49
		,22
		,16
		,1
		,GetDate()
		,'System'
		)
END