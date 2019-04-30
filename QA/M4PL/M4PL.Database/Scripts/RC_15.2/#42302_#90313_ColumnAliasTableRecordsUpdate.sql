USE [M4PL_DEV]
GO

UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ConOrgId' WHERE id = 516
UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ContactMSTRID' WHERE id = 517
UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ConItemNumber' WHERE id = 518
UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ConCode' WHERE id = 519
UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ConTitle' WHERE id = 520
UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ConTableTypeId' WHERE id = 521
UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ConDescription' WHERE id = 522
UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ConInstruction' WHERE id = 523
UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ConIsDefault' WHERE id = 524
GO

UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ConPrimaryRecordId' WHERE id IN (12054, 12040, 994)
UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ConItemNumber' WHERE id IN (12055, 12041, 995)
UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ConCode' WHERE id IN (12056, 12042, 996)
UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ConTitle' WHERE id IN (12057, 12043, 997)
UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ContactMSTRID' WHERE id IN (12059, 12045, 998)
UPDATE [dbo].[SYSTM000ColumnsAlias]  SET [ColColumnName] = 'ConTableTypeId' WHERE id = 22068


update [SYSTM000ColumnsAlias] set ColIsVisible=0 where Id in (12060, 12061, 12046, 12047)