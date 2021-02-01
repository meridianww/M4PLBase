IF NOT EXISTS (Select 1 From SYSTM000Ref_Options Where SysLookupCode = 'RateCategoryType' AND SysOptionName = 'Return')
BEGIN
INSERT INTO SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName,SysSortOrder,SysDefault,IsSysAdmin,StatusId,DateEntered,EnteredBy)
Values (33, 'RateCategoryType', 'Return', 5, 0,0,1,GetDate(), null)
END