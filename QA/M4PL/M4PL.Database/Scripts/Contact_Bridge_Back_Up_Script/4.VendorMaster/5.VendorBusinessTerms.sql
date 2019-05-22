INSERT INTO [dbo].[VEND020BusinessTerms]
           ([LangCode]
           ,[VbtOrgID]
           ,[VbtVendorID]
           ,[VbtItemNumber]
           ,[VbtCode]
           ,[VbtTitle]
           ,[VbtDescription]
           ,[BusinessTermTypeId]
           ,[VbtActiveDate]
           ,[VbtValue]
           ,[VbtHiThreshold]
           ,[VbtLoThreshold]
           ,[VbtAttachment]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
     SELECT
            vb.[LangCode]
           ,vb.[VbtOrgID]
           ,vn.id
		   [VbtVendorID]
           ,vb.[VbtItemNumber]
           ,vb.[VbtCode]
           ,vb.[VbtTitle]
           ,vb.[VbtDescription]
           ,vb.[BusinessTermTypeId]
           ,vb.[VbtActiveDate]
           ,vb.[VbtValue]
           ,vb.[VbtHiThreshold]
           ,vb.[VbtLoThreshold]
           ,vb.[VbtAttachment]
           ,vb.[StatusId]
           ,vb.[EnteredBy]
           ,vb.[DateEntered]
           ,vb.[ChangedBy]
           ,vb.[DateChanged] FROM M4PL_3030_Test.dbo.VEND020BusinessTerms vb
		   INNER join dbo.VEND000Master vn on vn.3030Id = vb.VbtVendorID
		   WHERE vn.VendOrgID = 1
GO


