SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Get a  Program MVOC
-- Execution:                 EXEC [dbo].[GetPrgMvoc]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetPrgMvoc]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.Id
		,prg.VocOrgID
		,prg.VocProgramID
		,prg.VocSurveyCode
		,prg.VocSurveyTitle
		,prg.StatusId
		,prg.VocDateOpen
		,prg.VocDateClose
		,prg.DateEntered
		,prg.EnteredBy
		,prg.DateChanged
		,prg.ChangedBy
		,prg.VocAllStar
  FROM   [dbo].[MVOC000Program] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
