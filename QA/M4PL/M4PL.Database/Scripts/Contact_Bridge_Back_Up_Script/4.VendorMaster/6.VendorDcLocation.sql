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
           ,[DateChanged]
		   ,[3030Id])
     SELECT --(select TOP 1 id from dbo.VEND000Master where VendCode = VN.VendCode)
            VN.ID--[VdcVendorID]
           ,VD.[VdcItemNumber]
           ,VD.[VdcLocationCode]
           ,VD.[VdcCustomerCode]
           ,VD.[VdcLocationTitle]
           ,CM.Id
           ,VD.[StatusId]
           ,VD.[EnteredBy]
           ,VD.[DateEntered]
           ,VD.[ChangedBy]
           ,VD.[DateChanged] FROM M4PL_3030_Test.dbo.VEND040DCLocations VD
		   INNER JOIN dbo.VEND000Master VN ON VN.3030Id = VD.VdcVendorID
		   INNER JOIN [dbo].[CONTC000Master] CM ON CM.3030Id = VD.VdcContactMSTRID
		   WHERE VN.VendOrgID = 1 
GO


