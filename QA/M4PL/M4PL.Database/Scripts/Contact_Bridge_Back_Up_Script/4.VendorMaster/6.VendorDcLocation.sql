INSERT INTO [dbo].[VEND040DCLocations]
           ([VdcVendorID]
           ,[VdcItemNumber]
           ,[VdcLocationCode]
           ,[VdcCustomerCode]
           ,[VdcLocationTitle]
           ,[VdcContactMSTRID]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
     SELECT --(select TOP 1 id from dbo.VEND000Master where VendCode = VN.VendCode)
            v.ID--[VdcVendorID]
           ,VD.[VdcItemNumber]
           ,VD.[VdcLocationCode]
           ,VD.[VdcCustomerCode]
           ,VD.[VdcLocationTitle]
           ,(select TOP 1 f.id from [dbo].[CONTC000Master] f where f.ConEmailAddress = ISNULL((select TOP 1 m.ConEmailAddress from [M4PL_3030_Test].[dbo].[CONTC000Master] m where m.Id = VD.VdcContactMSTRID), -1))--VD.[VdcContactMSTRID]
           ,VD.[StatusId]
           ,VD.[EnteredBy]
           ,VD.[DateEntered]
           ,VD.[ChangedBy]
           ,VD.[DateChanged] FROM M4PL_3030_Test.dbo.VEND040DCLocations VD
		   INNER JOIN M4PL_3030_Test.dbo.VEND000Master VN ON VN.ID = VD.VdcVendorID
		   left join dbo.VEND000Master v on v.VendCode = VN.VendCode
		   WHERE VN.VendOrgID = 1 and v.Id is not null
GO


