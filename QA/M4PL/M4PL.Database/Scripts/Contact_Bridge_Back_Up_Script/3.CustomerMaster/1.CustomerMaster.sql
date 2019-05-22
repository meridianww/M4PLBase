INSERT INTO [dbo].[CUST000Master]
           ([CustERPID]
           ,[CustOrgId]
           ,[CustItemNumber]
           ,[CustCode]
           ,[CustTitle]
           ,[CustDescription]
           ,[CustWorkAddressId]
           ,[CustBusinessAddressId]
           ,[CustCorporateAddressId]
           ,[CustContacts]
           ,[CustLogo]
           ,[CustNotes]
           ,[CustTypeId]
           ,[CustWebPage]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged]
		   ,[3030Id])
     
           SELECT [CustERPID]
           ,1
           ,[CustItemNumber]
           ,[CustCode]
           ,[CustTitle]
           ,[CustDescription]
           ,(SELECT CCM.ID FROM [dbo].[CONTC000Master] CCM WHERE CCM.[3030Id] = TS.CustWorkAddressId)
           ,(SELECT CM.ID FROM [dbo].[CONTC000Master] CM WHERE CM.[3030Id] = TS.CustBusinessAddressId)
           ,(SELECT CMM.ID FROM [dbo].[CONTC000Master] CMM WHERE CMM.[3030Id] = TS.CustCorporateAddressId)
           ,[CustContacts]
           ,[CustLogo]
           ,[CustNotes]
           ,[CustTypeId]
           ,[CustWebPage]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]		   
           ,[DateChanged]
		   ,TS.Id FROM [M4PL_3030_Test].[dbo].[CUST000Master] TS
		   where TS.CustOrgId = 1
		   
		   
		   GO


