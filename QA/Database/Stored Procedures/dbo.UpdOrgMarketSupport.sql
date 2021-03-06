SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Org mrkt org Support
-- Execution:                 EXEC [dbo].[UpdOrgMarketSupport]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdOrgMarketSupport]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@mrkOrder INT  = NULL
	,@mrkCode NVARCHAR(20)  = NULL
	,@mrkTitle NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;
   DECLARE @updatedItemNumber INT      
EXEC [dbo].[ResetItemNumber] @userId, @id, @orgId, @entity, @mrkOrder, NULL, NULL, NULL,  @updatedItemNumber OUTPUT  
    
   UPDATE [dbo].[ORGAN002MRKT_OrgSupport]
     SET    OrgId 			 = CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrgId) END
           ,MrkOrder 		 = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, MrkOrder) END
           ,MrkCode 		 = CASE WHEN (@isFormView = 1) THEN @mrkCode WHEN ((@isFormView = 0) AND (@mrkCode='#M4PL#')) THEN NULL ELSE ISNULL(@mrkCode, MrkCode) END
           ,MrkTitle 		 = CASE WHEN (@isFormView = 1) THEN @mrkTitle WHEN ((@isFormView = 0) AND (@mrkTitle='#M4PL#')) THEN NULL ELSE ISNULL(@mrkTitle, MrkTitle) END
           ,DateChanged 	 = @dateChanged 
           ,ChangedBy		 = @changedBy
 EXEC [dbo].[GetOrgMarketSupport] @userId, @roleId, @orgId, @id

  END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
