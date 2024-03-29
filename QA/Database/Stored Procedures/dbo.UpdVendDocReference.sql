SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Upd a vend doc ref
-- Execution:                 EXEC [dbo].[UpdVendDocReference]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  06/07/2019 (Parthiban - Remove '#M4PL' while updating)
-- ============================================= 
CREATE PROCEDURE  [dbo].[UpdVendDocReference]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT	 
	,@vdrOrgId BIGINT = NULL
	,@vdrVendorId BIGINT = NULL
	,@vdrItemNumber INT = NULL
	,@vdrCode NVARCHAR(20) = NULL
	,@vdrTitle NVARCHAR(50) = NULL
	,@docRefTypeId INT = NULL
	,@docCategoryTypeId INT = NULL
	,@vdrAttachment INT = NULL
	,@vdrDateStart DATETIME2(7) = NULL
	,@vdrDateEnd DATETIME2(7) = NULL
	,@vdrRenewal BIT = NULL
	,@statusId INT = NULL 
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
      DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @vdrVendorId, @entity, @vdrItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   UPDATE [dbo].[VEND030DocumentReference]
    SET     VdrOrgId 			 = ISNULL(@vdrOrgId, VdrOrgId)
           ,VdrVendorId 		 = ISNULL(@vdrVendorId, VdrVendorId)
           ,VdrItemNumber 		 = ISNULL(@updatedItemNumber, VdrItemNumber)
           ,VdrCode 			 = ISNULL(@vdrCode, VdrCode)
           ,VdrTitle 			 = @vdrTitle
           ,DocRefTypeId 		 = ISNULL(@docRefTypeId, DocRefTypeId)
           ,DocCategoryTypeId 	 = ISNULL(@docCategoryTypeId, DocCategoryTypeId)
           ,VdrDateStart 		 = CASE WHEN (CONVERT(CHAR(10), @vdrDateStart, 103)='01/01/1753') THEN NULL ELSE ISNULL(@vdrDateStart, VdrDateStart) END
           ,VdrDateEnd 			 = CASE WHEN (CONVERT(CHAR(10), @vdrDateEnd, 103)='01/01/1753') THEN NULL ELSE ISNULL(@vdrDateEnd, VdrDateEnd) END
           ,VdrRenewal 			 = ISNULL(@vdrRenewal, VdrRenewal)
           ,StatusId 			 = ISNULL(@statusId, StatusId)
           ,ChangedBy 			 = @changedBy   
           ,DateChanged			 = @dateChanged  
      WHERE Id = @id
		EXEC [dbo].[GetVendDocReference] @userId, @roleId, @vdrOrgId ,@id 
END TRY       
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
