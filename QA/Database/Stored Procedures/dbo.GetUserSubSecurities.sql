SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get user securities  
-- Execution:                 EXEC [dbo].[GetUserSubSecurities]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
CREATE PROCEDURE  [dbo].[GetUserSubSecurities] 
 @userId BIGINT,  
 @secByRoleId BIGINT,  
 @orgId BIGINT,  
 @roleId BIGINT
AS  
BEGIN TRY                  
 SET NOCOUNT ON; 

	 	  SELECT subSbr.SecByRoleId,
			  subSbr.RefTableName,
			  subSbr.SubsMenuOptionLevelId,
			  subSbr.SubsMenuAccessLevelId
			  FROM [dbo].[SYSTM010SubSecurityByRole] (NOLOCK) subSbr 
			  INNER JOIN [dbo].[SYSTM000SecurityByRole] (NOLOCK) sbr ON subSbr.SecByRoleId = sbr.Id
			  WHERE subSbr.SecByRoleId = @secByRoleId AND subSbr.StatusId=1 AND sbr.StatusId=1;
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
   
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH


GO
