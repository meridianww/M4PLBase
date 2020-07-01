

UPDATE [dbo].[SYSTM000Ref_Options] SET SysDefault =1  WHERE SysLookupCode='JobPreferredMethod' AND SysOptionName = 'Email'
UPDATE [dbo].[SYSTM000Ref_Options] SET SysDefault =0  WHERE SysLookupCode='JobPreferredMethod' AND SysOptionName = 'Phone'