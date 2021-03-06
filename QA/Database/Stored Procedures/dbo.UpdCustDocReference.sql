SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a cust document reference
-- Execution:                 EXEC [dbo].[UpdCustDocReference]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdCustDocReference]		  
	 @userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@cdrOrgId BIGINT  = NULL
	,@cdrCustomerId BIGINT  = NULL
	,@cdrItemNumber INT = NULL 
	,@cdrCode NVARCHAR(20) = NULL 
	,@cdrTitle NVARCHAR(50)  = NULL
	,@docRefTypeId INT  = NULL
	,@docCategoryTypeId INT = NULL 
	,@cdrAttachment INT  = NULL
	,@cdrDateStart DATETIME2(7)  = NULL
	,@cdrDateEnd DATETIME2(7)  = NULL
	,@cdrRenewal BIT   = NULL
	,@statusId INT = NULL 
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   

  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @cdrCustomerId, @entity, @cdrItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
     UPDATE [dbo].[CUST030DocumentReference]
        SET  CdrOrgId				=  ISNULL(@cdrOrgId, CdrOrgId) 
            ,CdrCustomerId			=  ISNULL(@cdrCustomerId, CdrCustomerId) 
            ,CdrItemNumber			=  ISNULL(@updatedItemNumber, CdrItemNumber)
            ,CdrCode				=  ISNULL(@cdrCode, CdrCode) 
            ,CdrTitle				=  ISNULL(@cdrTitle, CdrTitle) 
            ,DocRefTypeId			=  ISNULL(@docRefTypeId, DocRefTypeId) 
            ,DocCategoryTypeId		=  ISNULL(@docCategoryTypeId, DocCategoryTypeId)  
            ,CdrDateStart			=  CASE WHEN (@isFormView = 1) THEN @cdrDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @cdrDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@cdrDateStart, CdrDateStart) END
            ,CdrDateEnd				=  CASE WHEN (@isFormView = 1) THEN @cdrDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @cdrDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@cdrDateEnd, CdrDateEnd) END
            ,CdrRenewal				=  ISNULL(@cdrRenewal, CdrRenewal)	  
            ,StatusId				=  ISNULL(@statusId, StatusId) 	  
            ,ChangedBy				=  ISNULL(@changedBy, ChangedBy)
            ,DateChanged			=  ISNULL(@dateChanged,	DateChanged)	
       WHERE Id= @id
	EXEC [dbo].[GetCustDocReference] @userId, @roleId, @cdrOrgId ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
