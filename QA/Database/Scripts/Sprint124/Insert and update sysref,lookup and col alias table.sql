
INSERT INTO SYSTM000Ref_Lookup(LkupCode,LkupTableName) VALUES ('OrderType','Global')
INSERT INTO SYSTM000Ref_Lookup(LkupCode,LkupTableName) VALUES ('Scheduled','Global')


INSERT INTO SYSTM000Ref_Options(SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,IsSysAdmin,StatusId) VALUES(2027,'OrderType','Original',1,1,0,1)
INSERT INTO SYSTM000Ref_Options(SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,IsSysAdmin,StatusId) VALUES(2027,'OrderType','Return',2,0,0,1)
INSERT INTO SYSTM000Ref_Options(SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,IsSysAdmin,StatusId) VALUES(2028,'Scheduled','Not Scheduled',1,1,0,1)
INSERT INTO SYSTM000Ref_Options(SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,IsSysAdmin,StatusId) VALUES(2028,'Scheduled','Scheduled',2,0,0,1)

UPDATE SYSTM000ColumnsAlias SET ColLookupCode='OrderType',ColLookupId=2027 WHERE ColTableName ='JobAdvanceReport' AND ColColumnName='OrderTypeId'
UPDATE SYSTM000ColumnsAlias SET ColLookupCode='Scheduled',ColLookupId=2028 WHERE ColTableName ='JobAdvanceReport' AND ColColumnName='Scheduled'
UPDATE SYSTM000ColumnsAlias SET ColLookupCode='StatusJob',ColLookupId=41 WHERE ColTableName ='JobAdvanceReport' AND ColColumnName='JobStatusId'
UPDATE SYSTM000ColumnsAlias SET ColLookupCode='GatewayStatus',ColLookupId=1007 WHERE ColTableName ='JobAdvanceReport' AND ColColumnName='GatewayStatusId'



INSERT INTO SYSTM000Ref_Table (SysRefName,LangCode,TblLangName,TblTableName,TblMainModuleId,TblPrimaryKeyName)
VALUES ('JobAdvanceReport','EN','Job Advance Report','SYSTM000Ref_Report',13,'Id')

UPDATE SYSTM000ColumnsAlias SET ColAliasName='Code' where ColTableName='jobadvancereport' and ColAliasName='ProgramIdCode'

UPDATE SYSTM000ColumnsAlias SET ColCaption='Order Type',ColColumnName='OrderType',ColAliasName='OrderType' where ColTableName='jobadvancereport' and ColAliasName='OrderTypeId' 

ALTER TABLE SYSTM000Ref_Report 
ADD Scheduled INT
FOREIGN KEY(Scheduled) REFERENCES SYSTM000Ref_Options(id);


ALTER TABLE SYSTM000Ref_Report 
ADD OrderType INT
FOREIGN KEY(OrderType) REFERENCES SYSTM000Ref_Options(id);

--SELECT * FROM SYSTM000ColumnsAlias WHERE ColTableName = 'jobadvancereport'

