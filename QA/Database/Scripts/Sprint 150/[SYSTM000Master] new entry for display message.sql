
INSERT INTO [dbo].[SYSTM000Master]
           ([LangCode]
           ,[SysMessageCode]
           ,[SysRefId]
           ,[SysMessageScreenTitle]
           ,[SysMessageTitle]
           ,[SysMessageDescription]
           ,[SysMessageInstruction]
           ,[SysMessageButtonSelection]
           ,[StatusId]
           ,[DateEntered])
     VALUES
           ('EN'
           ,'JobExistSchedule'
           ,42
           ,'Mismatch'
           ,'Warning'
           ,'Selected job is already scheduled,Job is not Scheduled Yet'
           ,NULL
           ,'Ok'
           ,1
           ,GETUTCDATE()
		   )
GO


