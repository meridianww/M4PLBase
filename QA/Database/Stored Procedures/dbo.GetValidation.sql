SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Sys Validation 
-- Execution:                 EXEC [dbo].[GetValidation]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetValidation]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
IF(@langCode='EN')
 BEGIN
SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[ValTableName]
      ,syst.[RefTabPageId]
      ,syst.[ValFieldName]
      ,syst.[ValRequired]
      ,syst.[ValRequiredMessage]
      ,syst.[ValUnique]
      ,syst.[ValUniqueMessage]
      ,syst.[ValRegExLogic0]
      ,syst.[ValRegEx1]
      ,syst.[ValRegExMessage1]
      ,syst.[ValRegExLogic1]
      ,syst.[ValRegEx2]
      ,syst.[ValRegExMessage2]
      ,syst.[ValRegExLogic2]
      ,syst.[ValRegEx3]
      ,syst.[ValRegExMessage3]
      ,syst.[ValRegExLogic3]
      ,syst.[ValRegEx4]
      ,syst.[ValRegExMessage4]
      ,syst.[ValRegExLogic4]
      ,syst.[ValRegEx5]
      ,syst.[ValRegExMessage5]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM000Validation] syst
 WHERE [Id]=@id 
END
ELSE
 BEGIN
SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[ValTableName]
      ,syst.[RefTabPageId]
      ,syst.[ValFieldName]
      ,syst.[ValRequired]
      ,syst.[ValRequiredMessage]
      ,syst.[ValUnique]
      ,syst.[ValUniqueMessage]
      ,syst.[ValRegExLogic0]
      ,syst.[ValRegEx1]
      ,syst.[ValRegExMessage1]
      ,syst.[ValRegExLogic1]
      ,syst.[ValRegEx2]
      ,syst.[ValRegExMessage2]
      ,syst.[ValRegExLogic2]
      ,syst.[ValRegEx3]
      ,syst.[ValRegExMessage3]
      ,syst.[ValRegExLogic3]
      ,syst.[ValRegEx4]
      ,syst.[ValRegExMessage4]
      ,syst.[ValRegExLogic4]
      ,syst.[ValRegEx5]
      ,syst.[ValRegExMessage5]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM000Validation] syst
 WHERE [Id]=@id 
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
