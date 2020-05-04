IF NOT EXISTS(select SysRefName from SYSTM000Ref_Table where SysRefName = 'jobcard')
BEGIN
	INSERT INTO SYSTM000Ref_Table(SysRefName,LangCode,TblLangName,TblTableName,TblMainModuleId,TblIcon,TblTypeId,TblPrimaryKeyName,TblParentIdFieldName,TblItemNumberFieldName,DateEntered,EnteredBy,DateChanged,ChangedBy)
	VALUES ('JobCard','EN','Job Card','JOBDL000Master',13,NULL,NULL,'Id',NULL,NULL,'2020-02-12 13:23:13.5030000',NULL,NULL,NULL)
END 
GO