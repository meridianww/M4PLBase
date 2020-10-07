
IF NOT EXISTS(SELECT 1 FROM SYSTM000Ref_Table WHERE SysRefName='NavRemittance')
BEGIN
INSERT INTO [dbo].[SYSTM000Ref_Table]
           ([SysRefName]
           ,[LangCode]
           ,[TblLangName]
           ,[TblTableName]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
           ('NavRemittance'
		   ,'EN'
           ,'Nav Remittance'
           ,''
           ,GETUTCDATE()
           ,'NFUJIMOTO')
END

UPDATE SYSTM000ColumnsAlias SET ColIsReadOnly=0 WHERE ColTableName='NavRemittance' AND ColColumnName='ChequeNo'


