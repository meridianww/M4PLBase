SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Org MRKT Org Support    
-- Execution:                 EXEC [dbo].[GetOrgMarketSupport]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetOrgMarketSupport]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT org.[Id]
       ,org.[OrgID]
       ,org.[MrkOrder]
       ,org.[MrkCode]
       ,org.[MrkTitle]
       ,org.[DateEntered]
       ,org.[EnteredBy]
       ,org.[DateChanged]
       ,org.[ChangedBy]
   FROM [dbo].[ORGAN002MRKT_OrgSupport] org
  WHERE [Id]=@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
