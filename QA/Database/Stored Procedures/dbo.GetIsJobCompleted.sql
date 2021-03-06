SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               04/16/2018      
-- Description:               Check Job is Completed or Not 
-- Execution:                 EXEC [dbo].[GetIsJobCompleted] 
-- Modified on:  
-- Modified Desc:  
-- =============================================    

CREATE PROCEDURE  [dbo].[GetIsJobCompleted] 
@jobId BIGINT
AS

BEGIN TRY
  SET NOCOUNT ON;
  SELECT JobCompleted FROM JOBDL000Master WHERE Id=  @jobId;


END TRY
BEGIN CATCH                
DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
  ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
  ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
