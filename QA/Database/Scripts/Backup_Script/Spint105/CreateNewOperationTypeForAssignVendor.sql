Declare @AssignVendorID INT
IF NOT EXISTS(Select 1 From [dbo].[SYSTM000Ref_Options] Where [SysOptionName] = 'AssignVendor')
BEGIN
INSERT INTO [dbo].[SYSTM000Ref_Options]
           ([SysLookupId]
           ,[SysLookupCode]
           ,[SysOptionName]
           ,[SysSortOrder]
           ,[SysDefault]
           ,[IsSysAdmin]
           ,[StatusId]
)
     VALUES
           (29
           ,'OperationType'
           ,'AssignVendor'
           ,26
           ,0
           ,0
           ,1)
END

Select @AssignVendorID = ID From [dbo].[SYSTM000Ref_Options] Where [SysOptionName] = 'AssignVendor'

IF NOT EXISTS(Select 1 From [dbo].[SYSMS010Ref_MessageTypes] Where SysRefId = @AssignVendorID)
BEGIN
INSERT INTO [dbo].[SYSMS010Ref_MessageTypes] (LangCode,SysRefId,SysMsgTypeTitle,StatusId,DateEntered)
Values ('EN', @AssignVendorID, 'Retrieve Location',1,GetDate())
END






