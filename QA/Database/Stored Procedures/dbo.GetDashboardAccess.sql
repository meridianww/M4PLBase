SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Janardana Behar         
-- Create date:               09/17/2018        
-- Description:               GetDashboardAccess  
-- Execution:                 EXEC sp_helptext GetDashboardAccess 1,1,14,'JOBDL000Master',1 
-- Modified on:    
-- Modified Desc:    
-- =============================================   
CREATE PROCEDURE  [dbo].[GetDashboardAccess]  
    @userId BIGINT,  
    @orgId BIGINT,  
    @roleId BIGINT,  
 @dashboardID INT,  
 @tableName NVARCHAR(100)  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
  
  DECLARE @entity NVARCHAR(100)  
  
  SELECT @entity = SysRefName FROM SYSTM000Ref_Table Where TblTableName= @tableName;  
  
  
  EXEC GetUserPageOptnLevelAndPermission @userId,@orgId,@roleId,@entity  
  
  
    
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
