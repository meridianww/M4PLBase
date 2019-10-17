update [dbo].[SYSTM000Ref_Table] set TblTableName = 'CONTC010Bridge'  ,TblParentIdFieldName = 'ConPrimaryRecordId' ,TblItemNumberFieldName = 'ConItemNumber'  where  SysRefName  IN ('VendDcLocation','CustDcLocation')
 
