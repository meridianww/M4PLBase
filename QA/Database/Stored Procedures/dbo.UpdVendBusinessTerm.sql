SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Upd a vend business tTerm
-- Execution:                 EXEC [dbo].[UpdVendBusinessTerm]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  06/07/2019 (Parthiban - Remove '#M4PL' while updating)
-- =============================================  
CREATE PROCEDURE  [dbo].[UpdVendBusinessTerm]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@id BIGINT
	,@vbtOrgId BIGINT = NULL
	,@vbtVendorId BIGINT = NULL 
	,@vbtItemNumber INT  = NULL
	,@vbtCode NVARCHAR(20)  = NULL
	,@vbtTitle NVARCHAR(50)  = NULL
	,@businessTermTypeId INT  = NULL
	,@vbtActiveDate DATETIME2(7)  = NULL
	,@vbtValue DECIMAL(18,2)  = NULL
	,@vbtHiThreshold DECIMAL(18,2)  = NULL
	,@vbtLoThreshold DECIMAL(18,2)  = NULL
	,@vbtAttachment INT  = NULL
	,@statusId INT   = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @vbtVendorId, @entity, @vbtItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
   UPDATE [dbo].[VEND020BusinessTerms]
    SET     LangCode			=	ISNULL(@langCode, LangCode)
           ,VbtOrgId 			=	ISNULL(@vbtOrgId, VbtOrgId)
           ,VbtVendorId 		=	ISNULL(@vbtVendorId, VbtVendorId)
           ,VbtItemNumber 		=	ISNULL(@updatedItemNumber, VbtItemNumber)
           ,VbtCode 			=	ISNULL(@vbtCode, VbtCode)
           ,VbtTitle 			=	@vbtTitle
           ,BusinessTermTypeId 	=	ISNULL(@businessTermTypeId, BusinessTermTypeId)  
           ,VbtActiveDate 		=	CASE WHEN (CONVERT(CHAR(10), @vbtActiveDate, 103)='01/01/1753') THEN NULL ELSE ISNULL(@vbtActiveDate, VbtActiveDate) END
           ,VbtValue 			=	@vbtValue
           ,VbtHiThreshold 		=	@vbtHiThreshold
           ,VbtLoThreshold 		=	@vbtLoThreshold
           ,StatusId 			=	ISNULL(@statusId, StatusId)
           ,ChangedBy 			=	@changedBy  
           ,DateChanged			= 	@dateChanged 
      WHERE Id   = 	@id
		EXEC [dbo].[GetVendBusinessTerm] @userId, @roleId, @vbtOrgId ,@langCode, @id 
END TRY      
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
