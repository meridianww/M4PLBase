INSERT INTO [dbo].[VEND000Master]
           ([VendERPID]
           ,[VendOrgID]
           ,[VendItemNumber]
           ,[VendCode]
           ,[VendTitle]
           ,[VendDescription]
           ,[VendWorkAddressId]
           ,[VendBusinessAddressId]
           ,[VendCorporateAddressId]
           ,[VendContacts]
           ,[VendLogo]
           ,[VendNotes]
           ,[VendTypeId]
           ,[VendWebPage]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
     
           SELECT [VendERPID]
           ,1
           ,TS.[VendItemNumber]
           ,TS.[VendCode]
           ,TS.[VendTitle]
           ,TS.[VendDescription]
           ,(select TOP 1 f.id from [dbo].[CONTC000Master] f where f.ConEmailAddress = ISNULL((select TOP 1 m.ConEmailAddress from [M4PL_3030_Test].[dbo].[CONTC000Master] m where m.Id = TS.VendWorkAddressId), -1))
           ,(select TOP 1 f.id from [dbo].[CONTC000Master] f where f.ConEmailAddress = ISNULL((select TOP 1 m.ConEmailAddress from [M4PL_3030_Test].[dbo].[CONTC000Master] m where m.Id = TS.VendBusinessAddressId), -1))
           ,(select TOP 1 f.id from [dbo].[CONTC000Master] f where f.ConEmailAddress = ISNULL((select TOP 1 m.ConEmailAddress from [M4PL_3030_Test].[dbo].[CONTC000Master] m where m.Id = TS.VendCorporateAddressId), -1))
           ,TS.[VendContacts]
           ,TS.[VendLogo]
           ,TS.[VendNotes]
           ,TS.[VendTypeId]
           ,TS.[VendWebPage]
           ,TS.[StatusId]
           ,TS.[EnteredBy]
           ,TS.[DateEntered]
           ,TS.[ChangedBy]
           ,TS.[DateChanged] FROM [M4PL_3030_Test].[dbo].[VEND000Master] TS
		   where TS.VendCode not in (select B.VendCode from [dbo].[VEND000Master] B) and TS.VendOrgID = 1

GO

