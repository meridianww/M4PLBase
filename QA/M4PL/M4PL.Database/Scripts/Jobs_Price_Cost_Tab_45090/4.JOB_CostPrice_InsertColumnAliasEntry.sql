
DELETE FROM [SYSTM000ColumnsAlias] WHERE ColTableName= 'JobRefCostSheet'
INSERT INTO [dbo].[SYSTM000ColumnsAlias]
           ([LangCode]
           ,[ColTableName]
           ,[ColAssociatedTableName]
           ,[ColColumnName]
           ,[ColAliasName]
           ,[ColCaption]
           ,[ColLookupId]
           ,[ColLookupCode]
           ,[ColDescription]
           ,[ColSortOrder]
           ,[ColIsReadOnly]
           ,[ColIsVisible]
           ,[ColIsDefault]
           ,[StatusId]
           ,[ColDisplayFormat]
           ,[ColAllowNegativeValue]
           ,[ColIsGroupBy]
           ,[ColMask])

    VALUES  ('EN','JobBillableSheet',NULL,'Id','ID','ID',NULL,NULL,NULL,1,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'JobID','Job ID','Job ID',NULL,NULL,NULL,2,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'PrcLineItem','Item','Item',NULL,NULL,NULL,3,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'PrcChargeID','Charge ID','Charge ID',NULL,NULL,NULL,4,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'PrcChargeCode','Charge Code','Charge Code',NULL,NULL,NULL,5,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'PrcTitle','Title','Title',NULL,NULL,NULL,6,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'PrcSurchargeOrder','Surcharge Order','Surcharge Order',NULL,NULL,NULL,7,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'ChargeTypeId','Charge Type','Charge Type',NULL,NULL,NULL,5,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'PrcNumberUsed','Number Used','Number Used',NULL,NULL,NULL,6,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'PrcDuration','Duration','Duration',NULL,NULL,NULL,8,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'PrcQuantity','Quantity','Quantity',NULL,NULL,NULL,9,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'PrcUnitId','Cost','Cost',NULL,NULL,NULL,10,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'PrcRate','Cost Rate','Cost Rate',NULL,NULL,NULL,11,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'PrcAmount','Amount','Amount',NULL,NULL,NULL,12,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'PrcMarkupPercent','Markup Percent','Markup Percent',NULL,NULL,NULL,13,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'PrcComments','Comments','Comments',NULL,NULL,NULL,14,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'StatusId','Status','Status',NULL,NULL,NULL,14,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'EnteredBy','Entered By','Entered By',NULL,NULL,NULL,15,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'DateEntered','Date Entered','Date Entered',NULL,NULL,NULL,16,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'ChangedBy','Changed By','Changed By',NULL,NULL,NULL,17,1,1,1,1,'',0,0,NULL),
			('EN','JobBillableSheet',NULL,'DateChanged','Date Changed','Date Changed',NULL,NULL,NULL,18,1,1,1,1,'',0,0,NULL)



			

INSERT INTO [dbo].[SYSTM000ColumnsAlias]
           ([LangCode]
           ,[ColTableName]
           ,[ColAssociatedTableName]
           ,[ColColumnName]
           ,[ColAliasName]
           ,[ColCaption]
           ,[ColLookupId]
           ,[ColLookupCode]
           ,[ColDescription]
           ,[ColSortOrder]
           ,[ColIsReadOnly]
           ,[ColIsVisible]
           ,[ColIsDefault]
           ,[StatusId]
           ,[ColDisplayFormat]
           ,[ColAllowNegativeValue]
           ,[ColIsGroupBy]
           ,[ColMask])

    VALUES  ('EN','JobCostSheet',NULL,'Id','ID','ID',NULL,NULL,NULL,1,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'JobID','Job ID','Job ID',NULL,NULL,NULL,2,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'CstLineItem','Item','Item',NULL,NULL,NULL,3,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'CstChargeID','Charge ID','Charge ID',NULL,NULL,NULL,4,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'CstChargeCode','Charge Code','Charge Code',NULL,NULL,NULL,5,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'CstTitle','Title','Title',NULL,NULL,NULL,6,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'CstSurchargeOrder','Surcharge Order','Surcharge Order',NULL,NULL,NULL,7,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'ChargeTypeId','Charge Type','Charge Type',NULL,NULL,NULL,5,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'CstNumberUsed','Number Used','Number Used',NULL,NULL,NULL,6,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'CstDuration','Duration','Duration',NULL,NULL,NULL,8,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'CstQuantity','Quantity','Quantity',NULL,NULL,NULL,9,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'CstUnitId','Cost','Cost',NULL,NULL,NULL,10,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'CstRate','Cost Rate','Cost Rate',NULL,NULL,NULL,11,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'CstAmount','Amount','Amount',NULL,NULL,NULL,12,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'CstMarkupPercent','Markup Percent','Markup Percent',NULL,NULL,NULL,13,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'CstComments','Comments','Comments',NULL,NULL,NULL,14,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'StatusId','Status','Status',NULL,NULL,NULL,14,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'EnteredBy','Entered By','Entered By',NULL,NULL,NULL,15,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'DateEntered','Date Entered','Date Entered',NULL,NULL,NULL,16,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'ChangedBy','Changed By','Changed By',NULL,NULL,NULL,17,1,1,1,1,'',0,0,NULL),
			('EN','JobCostSheet',NULL,'DateChanged','Date Changed','Date Changed',NULL,NULL,NULL,18,1,1,1,1,'',0,0,NULL)














