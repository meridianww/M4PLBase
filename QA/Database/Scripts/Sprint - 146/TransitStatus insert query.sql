IF NOT EXISTS(SELECT 1 FROM SYSTM000Ref_Lookup WHERE LkupCode = 'TransitStatus')
BEGIN
INSERT INTO [dbo].[SYSTM000Ref_Lookup]
           ([LkupCode]
           ,[LkupTableName])
     VALUES
           ('TransitStatus'
           ,'Global')
END


DECLARE @SysLookupId INT
SELECT @SysLookupId = ID FROM [dbo].[SYSTM000Ref_Lookup] WHERE [LkupCode] = 'TransitStatus'

BEGIN
IF NOT EXISTS(SELECT 1 FROM [SYSTM000Ref_Options] WHERE SysLookupCode = 'TransitStatus' AND SysOptionName = 'In Production')
BEGIN
INSERT INTO [dbo].[SYSTM000Ref_Options]
          ([SysLookupId],[SysLookupCode],[SysOptionName],[SysSortOrder],[SysDefault],[IsSysAdmin],[StatusId],[DateEntered],[EnteredBy])
	VALUES(@SysLookupId,'TransitStatus','In Production',1,1,0,1,GETUTCDATE(),N'nfujimoto')
		   END


IF NOT EXISTS(SELECT 1 FROM [SYSTM000Ref_Options] WHERE SysLookupCode = 'TransitStatus' AND SysOptionName = 'In Transit')
BEGIN
INSERT INTO [dbo].[SYSTM000Ref_Options]
          ([SysLookupId],[SysLookupCode],[SysOptionName],[SysSortOrder],[SysDefault],[IsSysAdmin],[StatusId],[DateEntered],[EnteredBy])
	VALUES(@SysLookupId,'TransitStatus','In Transit',2,0,0,1,GETUTCDATE(),N'nfujimoto')
		   END

IF NOT EXISTS(SELECT 1 FROM [SYSTM000Ref_Options] WHERE SysLookupCode = 'TransitStatus' AND SysOptionName = 'On Hand')
BEGIN
INSERT INTO [dbo].[SYSTM000Ref_Options]
          ([SysLookupId],[SysLookupCode],[SysOptionName],[SysSortOrder],[SysDefault],[IsSysAdmin],[StatusId],[DateEntered],[EnteredBy])
	VALUES(@SysLookupId,'TransitStatus','On Hand',3,0,0,1,GETUTCDATE(),N'nfujimoto')
		   END

IF NOT EXISTS(SELECT 1 FROM [SYSTM000Ref_Options] WHERE SysLookupCode = 'TransitStatus' AND SysOptionName = 'On Truck')
BEGIN
INSERT INTO [dbo].[SYSTM000Ref_Options]
          ([SysLookupId],[SysLookupCode],[SysOptionName],[SysSortOrder],[SysDefault],[IsSysAdmin],[StatusId],[DateEntered],[EnteredBy])
	VALUES(@SysLookupId,'TransitStatus','On Truck',4,0,0,1,GETUTCDATE(),N'nfujimoto')
		   END

IF NOT EXISTS(SELECT 1 FROM [SYSTM000Ref_Options] WHERE SysLookupCode = 'TransitStatus' AND SysOptionName = 'Will Call')
BEGIN
INSERT INTO [dbo].[SYSTM000Ref_Options]
          ([SysLookupId],[SysLookupCode],[SysOptionName],[SysSortOrder],[SysDefault],[IsSysAdmin],[StatusId],[DateEntered],[EnteredBy])
	VALUES(@SysLookupId,'TransitStatus','Will Call',5,0,0,1,GETUTCDATE(),N'nfujimoto')
		   END

IF NOT EXISTS(SELECT 1 FROM [SYSTM000Ref_Options] WHERE SysLookupCode = 'Delivered' AND SysOptionName = 'Delivered')
BEGIN
INSERT INTO [dbo].[SYSTM000Ref_Options]
          ([SysLookupId],[SysLookupCode],[SysOptionName],[SysSortOrder],[SysDefault],[IsSysAdmin],[StatusId],[DateEntered],[EnteredBy])
	VALUES(@SysLookupId,'TransitStatus','Delivered',6,0,0,1,GETUTCDATE(),N'nfujimoto')
		   END

IF NOT EXISTS(SELECT 1 FROM [SYSTM000Ref_Options] WHERE SysLookupCode = 'Delivered' AND SysOptionName = 'POD Upload')
BEGIN
INSERT INTO [dbo].[SYSTM000Ref_Options]
          ([SysLookupId],[SysLookupCode],[SysOptionName],[SysSortOrder],[SysDefault],[IsSysAdmin],[StatusId],[DateEntered],[EnteredBy])
	VALUES(@SysLookupId,'TransitStatus','POD Upload',7,0,0,1,GETUTCDATE(),N'nfujimoto')
		   END

END
