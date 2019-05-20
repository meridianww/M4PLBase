INSERT INTO [dbo].[VEND030DocumentReference]
           ([VdrOrgID]
           ,[VdrVendorID]
           ,[VdrItemNumber]
           ,[VdrCode]
           ,[VdrTitle]
           ,[DocRefTypeId]
           ,[DocCategoryTypeId]
           ,[VdrDescription]
           ,[VdrAttachment]
           ,[VdrDateStart]
           ,[VdrDateEnd]
           ,[VdrRenewal]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
     SELECT
            VD.[VdrOrgID]
           ,VF.Id
           ,VD.[VdrItemNumber]
           ,VD.[VdrCode]
           ,VD.[VdrTitle]
           ,VD.[DocRefTypeId]
           ,VD.[DocCategoryTypeId]
           ,VD.[VdrDescription]
           ,VD.[VdrAttachment]
           ,VD.[VdrDateStart]
           ,VD.[VdrDateEnd]
           ,VD.[VdrRenewal]
           ,VD.[StatusId]
           ,VD.[EnteredBy]
           ,VD.[DateEntered]
           ,VD.[ChangedBy]
           ,VD.[DateChanged] FROM [M4PL_3030_Test].[dbo].[VEND030DocumentReference] VD
		   left join [M4PL_3030_Test].[dbo].[VEND000Master] V on V.Id = VD.VdrVendorID
		   left join [dbo].[VEND000Master] VF on VF.VendCode = V.VendCode
		   WHERE VdrOrgID = 1
GO


