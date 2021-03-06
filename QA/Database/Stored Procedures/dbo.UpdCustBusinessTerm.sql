SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a cust contact
-- Execution:                 EXEC [dbo].[UpdCustBusinessTerm]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdCustBusinessTerm]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id  BIGINT
	,@cbtOrgId  BIGINT  = NULL
	,@cbtCustomerId  BIGINT  = NULL
	,@cbtItemNumber  INT  = NULL
	,@cbtCode  NVARCHAR(20)  = NULL
	,@cbtTitle  NVARCHAR(50)  = NULL
	,@businessTermTypeId  INT  = NULL
	,@cbtActiveDate  DATETIME2(7)  = NULL
	,@cbtValue  DECIMAL(18, 2)  = NULL
	,@cbtHiThreshold  DECIMAL(18, 2)  = NULL
	,@cbtLoThreshold  DECIMAL(18, 2)  = NULL
	,@cbtAttachment  INT  = NULL
	,@statusId  INT  = NULL
	,@changedBy  NVARCHAR(50)  = NULL
	,@dateChanged  DATETIME2(7)  = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON; 
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @cbtCustomerId, @entity, @cbtItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
   
   UPDATE  [dbo].[CUST020BusinessTerms] 
      SET    LangCode				= 	  ISNULL(@langCode, LangCode)  
			,CbtOrgId				= 	  ISNULL(@cbtOrgId, CbtOrgId) 
			,CbtCustomerId			= 	  ISNULL(@cbtCustomerId, CbtCustomerId)  
			,CbtItemNumber			= 	  ISNULL(@updatedItemNumber, CbtItemNumber)  
			,CbtCode				= 	  ISNULL(@cbtCode, CbtCode)  
			,CbtTitle				= 	  ISNULL(@cbtTitle, CbtTitle)  
			,BusinessTermTypeId     = 	  ISNULL(@businessTermTypeId, BusinessTermTypeId)  
			,CbtActiveDate			= 	  CASE WHEN (@isFormView = 1) THEN @cbtActiveDate WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @cbtActiveDate, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@cbtActiveDate, CbtActiveDate) END
			,CbtValue				= 	  ISNULL(@cbtValue, CbtValue)  
			,CbtHiThreshold			= 	  ISNULL(@cbtHiThreshold, CbtHiThreshold)  
			,CbtLoThreshold			= 	  ISNULL(@cbtLoThreshold, CbtLoThreshold)  
			,StatusId				= 	  ISNULL(@statusId, StatusId)  
			,ChangedBy				= 	  ISNULL(@changedBy, ChangedBy) 
			,DateChanged			= 	  ISNULL(@dateChanged, DateChanged)	
       WHERE Id = @id		   

	EXEC [dbo].[GetCustBusinessTerm] @userId, @roleId, @cbtOrgId,@langCode ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
