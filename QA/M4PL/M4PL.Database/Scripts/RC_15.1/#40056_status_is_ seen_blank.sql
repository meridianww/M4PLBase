USE [M4PL_Dev]
GO

INSERT INTO [dbo].[SYSTM000Validation]
           ([LangCode]
           ,[ValTableName]
           ,[RefTabPageId]
           ,[ValFieldName]
           ,[ValRequired]
           ,[ValRequiredMessage]
           ,[ValUnique]
           ,[ValUniqueMessage]
           ,[ValRegExLogic0]
           ,[ValRegEx1]
           ,[ValRegExMessage1]
           ,[ValRegExLogic1]
           ,[ValRegEx2]
           ,[ValRegExMessage2]
           ,[ValRegExLogic2]
           ,[ValRegEx3]
           ,[ValRegExMessage3]
           ,[ValRegExLogic3]
           ,[ValRegEx4]
           ,[ValRegExMessage4]
           ,[ValRegExLogic4]
           ,[ValRegEx5]
           ,[ValRegExMessage5]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     VALUES ( 'EN','OrgActSecurityByRole',64,'StatusId',1,'Status Is Required',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2017-11-02 06:07:27.0000000',NULL,NULL,NULL)
          
GO


