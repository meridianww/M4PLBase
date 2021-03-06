SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2019) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               08/26/2019      
-- Description:               Get program level hierarchy 
-- Execution:                 EXEC [dbo].[GetProgramLevel]  
-- =============================================  
Create PROCEDURE  [dbo].[GetProgramLevel]
   	@orgId BIGINT,
    @programId BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT   
     cast([PrgHierarchyLevel] AS INT)
  FROM [dbo].[PRGRM000Master]  where id = @programId and PrgOrgID = @orgId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
