IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupCode = 'Status' AND SysOptionName = 'Hold')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options(SysLookupId, SysLookupCode, SysOptionName,SysSortOrder,SysDefault,IsSysAdmin,StatusId, DateEntered)
VALUES (39,'Status','Hold',5,0,0,1,GetDate())
END