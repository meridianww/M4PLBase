SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
/* Copyright (2018) Meridian Worldwide Transportation Group    
   All Rights Reserved Worldwide */    
-- =============================================            
-- Author:                    Janardana                 
-- Create date:               02/17/2018          
-- Description:               Get Program Gateway Responsible based on organization      
-- Execution:                 EXEC [dbo].[GetJobResponsibleComboboxContacts] 1,2    
-- Modified on:      
-- Modified Desc:      
-- =============================================                              
CREATE PROCEDURE [dbo].[GetJobResponsibleComboboxContacts]                 
 @orgId BIGINT = 0 ,                    
 @programId BIGINT                      
AS                              
BEGIN TRY                              
                
  SET NOCOUNT ON;      
      
  SELECT DISTINCT cont.Id,      
   cont.ConFullName,      
   cont.ConJobTitle,      
   cont.ConFileAs        
  FROM  CONTC000MASTER cont      
  INNER JOIN [dbo].[PRGRM010Ref_GatewayDefaults] pr      
  ON cont.Id = pr.[PgdGatewayResponsible]   
  WHERE pr.PgdProgramID = @programId AND cont.ConOrgId = @orgId    
  AND  cont.StatusId In(1,2)  

  UNION  

SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs 
FROM  [dbo].CONTC000Master contact  
INNER JOIN  [dbo].[PRGRM020Program_Role] prgRole ON contact.Id = prgRole.[PrgRoleContactID] AND   prgRole.ProgramID = @programId AND prgRole.PrxJobDefaultResponsible =1
WHERE  contact.StatusId In(1,2)  
AND prgRole.StatusId In(1,2)  AND contact.ConOrgId = @orgId   

  --AND pr.OrgID=1      
                       
END TRY                              
BEGIN CATCH                              
                               
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                              
END CATCH
GO
