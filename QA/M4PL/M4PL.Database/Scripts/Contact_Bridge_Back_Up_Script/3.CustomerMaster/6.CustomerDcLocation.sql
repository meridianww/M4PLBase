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
           ,[DateChanged])
     select
           (SELECT TOP 1 C.ID FROM [dbo].[CUST000Master] C WHERE C.CustCode = CU.CustCode)
		    [CdcCustomerID]
           ,CD.[CdcItemNumber]
           ,CD.[CdcLocationCode]
           ,CD.[CdcCustomerCode]
           ,CD.[CdcLocationTitle]
           ,CD.[CdcContactMSTRID]
           ,CD.[StatusId]
           ,CD.[EnteredBy]
           ,CD.[DateEntered]
           ,CD.[ChangedBy]
           ,CD.[DateChanged] from [M4PL_3030_Test].[dbo].[CUST040DCLocations] CD
		   left join [M4PL_3030_Test].[dbo].[CUST000Master] CU on CU.ID=CD.CdcCustomerID
		   WHERE CU.CustOrgId = 1
GO


