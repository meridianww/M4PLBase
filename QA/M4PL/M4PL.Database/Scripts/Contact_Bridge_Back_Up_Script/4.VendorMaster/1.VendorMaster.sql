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
           ,[DateChanged]
		   ,[3030Id])
     
           SELECT [VendERPID]
           ,1
           ,TS.[VendItemNumber]
           ,TS.[VendCode]
           ,TS.[VendTitle]
           ,TS.[VendDescription]
           ,(SELECT CCM.ID FROM [dbo].[CONTC000Master] CCM WHERE CCM.[3030Id] = TS.VendWorkAddressId)
           ,(SELECT CM.ID FROM [dbo].[CONTC000Master] CM WHERE CM.[3030Id] = TS.VendBusinessAddressId)
           ,(SELECT CMM.ID FROM [dbo].[CONTC000Master] CMM WHERE CMM.[3030Id] = TS.VendCorporateAddressId)
           ,TS.[VendContacts]
           ,TS.[VendLogo]
           ,TS.[VendNotes]
           ,TS.[VendTypeId]
           ,TS.[VendWebPage]
           ,TS.[StatusId]
           ,TS.[EnteredBy]
           ,TS.[DateEntered]
           ,TS.[ChangedBy]
           ,TS.[DateChanged]
		   ,TS.Id FROM [M4PL_3030_Test].[dbo].[VEND000Master] TS
		   where TS.VendOrgID = 1

GO

