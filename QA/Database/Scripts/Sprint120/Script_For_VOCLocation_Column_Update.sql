IF NOT EXISTS (SELECT 1 FROM [SYSTM000ColumnsAlias] WHERE [ColTableName] = 'Report' AND [ColColumnName] = 'IsPBSReport')
BEGIN
INSERT INTO [SYSTM000ColumnsAlias] VALUES('EN','Report',null,'IsPBSReport','Default Survey','Default Survey',null,null,null,15,0,1,1,1,null,0,0,null,0)
END

IF NOT EXISTS (SELECT 1 FROM [SYSTM000ColumnsAlias] WHERE [ColTableName] = 'Report' AND [ColColumnName] = 'StartDate')
BEGIN
INSERT INTO [SYSTM000ColumnsAlias] VALUES('EN','Report',null,'StartDate','Start Date','Start Date',null,null,null,16,0,1,1,1,null,0,0,null,0)
END

IF NOT EXISTS (SELECT 1 FROM [SYSTM000ColumnsAlias] WHERE [ColTableName] = 'Report' AND [ColColumnName] = 'EndDate')
BEGIN
INSERT INTO [SYSTM000ColumnsAlias] VALUES('EN','Report',null,'EndDate','End Date','End Date',null,null,null,17,0,1,1,1,null,0,0,null,0)
END