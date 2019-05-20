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
           ,(select top 1 id from dbo.VEND000Master v where v.VendCode = vn.VendCode)
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
		   left join M4PL_3030_Test.dbo.VEND000Master vn on vn.id = vb.VbtVendorID
		   WHERE vn.VendOrgID = 1
GO


