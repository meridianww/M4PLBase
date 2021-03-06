SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program Role
-- Execution:                 EXEC [dbo].[GetPrgEdiMapping]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetPrgEdiMapping]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT  prg.[Id]
		 ,prg.[PemHeaderID]
         ,prg.[PemEdiTableName]
         ,prg.[PemEdiFieldName]
         ,prg.[PemEdiFieldDataType]
         ,prg.[PemSysTableName]
         ,prg.[PemSysFieldName]
         ,prg.[PemSysFieldDataType]
         ,prg.[StatusId]
         ,prg.[PemInsertUpdate]
         ,prg.[PemDateStart]
         ,prg.[PemDateEnd]
         ,prg.[EnteredBy]
         ,prg.[DateEntered]
         ,prg.[ChangedBy]
         ,prg.[DateChanged]
  FROM   [dbo].[PRGRM071EdiMapping] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
