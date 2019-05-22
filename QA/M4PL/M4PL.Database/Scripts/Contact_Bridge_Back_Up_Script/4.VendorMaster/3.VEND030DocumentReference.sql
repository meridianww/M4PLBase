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
           ,v.Id
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
		   INNER join [dbo].[VEND000Master] V on V.[3030Id] = VD.VdrVendorID
		   WHERE VdrOrgID = 1
GO


