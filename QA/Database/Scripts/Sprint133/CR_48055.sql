
IF  EXISTS (SELECT 1 From dbo.SYSTM000ColumnsAlias Where  ColTableName = 'Job' AND ColColumnName = 'JobDeliverySitePOC2' and ColAliasName = 'Site POC2' and ColCaption= 'Site POC2')
BEGIN
UPDATE SYSTM000ColumnsAlias SET  ColCaption = 'Site POC', colAliasname = 'Site POC'  WHERE ColTableName = 'Job' AND ColColumnName = 'JobDeliverySitePOC2' and ColAliasName = 'Site POC2' and ColCaption= 'Site POC2'
END
