INSERT INTO [dbo].[CUST040DCLocations]
           ([CdcCustomerID]
           ,[CdcItemNumber]
           ,[CdcLocationCode]
           ,[CdcCustomerCode]
           ,[CdcLocationTitle]
           ,[CdcContactMSTRID]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged]
		   ,[3030Id])
     select
           CU.Id
		    [CdcCustomerID]
           ,CD.[CdcItemNumber]
           ,CD.[CdcLocationCode]
           ,CD.[CdcCustomerCode]
           ,CD.[CdcLocationTitle]
           ,CM.Id
           ,CD.[StatusId]
           ,CD.[EnteredBy]
           ,CD.[DateEntered]
           ,CD.[ChangedBy]
           ,CD.[DateChanged]
		   ,CD.Id from [M4PL_3030_Test].[dbo].[CUST040DCLocations] CD
		   INNER join [dbo].[CUST000Master] CU on CU.[3030Id]=CD.CdcCustomerID
		    INNER JOIN [dbo].[CONTC000Master] CM ON CM.[3030Id] = CD.CdcContactMSTRID
		   WHERE CU.CustOrgId = 1
GO


