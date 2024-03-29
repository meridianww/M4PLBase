SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a org finacial cal
-- Execution:                 EXEC [dbo].[UpdOrgFinacialCalender]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdOrgFinacialCalender]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@fclPeriod INT = NULL 
	,@fclPeriodCode NVARCHAR(20)  = NULL
	,@fclPeriodStart DATETIME2(7)  = NULL
	,@fclPeriodEnd DATETIME2(7)  = NULL
	,@fclPeriodTitle NVARCHAR(50)  = NULL
	,@fclAutoShortCode NVARCHAR(15)  = NULL
	,@fclWorkDays INT  = NULL
	,@finCalendarTypeId BIGINT  = NULL
	,@statusId INT = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @orgId, @entity, @fclPeriod, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 


    UPDATE [dbo].[ORGAN020Financial_Cal]
     SET   OrgId 				= CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrgId) END 
          ,FclPeriod 			= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, FclPeriod) END  
          ,FclPeriodCode 		= CASE WHEN (@isFormView = 1) THEN @fclPeriodCode WHEN ((@isFormView = 0) AND (@fclPeriodCode='#M4PL#')) THEN NULL ELSE ISNULL(@fclPeriodCode, FclPeriodCode) END 
          ,FclPeriodStart 		= CASE WHEN (@isFormView = 1) THEN @fclPeriodStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @fclPeriodStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@fclPeriodStart, FclPeriodStart) END 
          ,FclPeriodEnd 		= CASE WHEN (@isFormView = 1) THEN @fclPeriodEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @fclPeriodEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@fclPeriodEnd, FclPeriodEnd) END 
          ,FclPeriodTitle 		= CASE WHEN (@isFormView = 1) THEN @fclPeriodTitle WHEN ((@isFormView = 0) AND (@fclPeriodTitle='#M4PL#')) THEN NULL ELSE ISNULL(@fclPeriodTitle, FclPeriodTitle) END 
          ,FclAutoShortCode		= CASE WHEN (@isFormView = 1) THEN @fclAutoShortCode WHEN ((@isFormView = 0) AND (@fclAutoShortCode='#M4PL#')) THEN NULL ELSE ISNULL(@fclAutoShortCode, FclAutoShortCode) END  
          ,FclWorkDays 			= CASE WHEN (@isFormView = 1) THEN @fclWorkDays WHEN ((@isFormView = 0) AND (@fclWorkDays=-100)) THEN NULL ELSE ISNULL(@fclWorkDays, FclWorkDays) END 
          ,FinCalendarTypeId 	= CASE WHEN (@isFormView = 1) THEN @finCalendarTypeId WHEN ((@isFormView = 0) AND (@finCalendarTypeId=-100)) THEN NULL ELSE ISNULL(@finCalendarTypeId, FinCalendarTypeId) END
          ,StatusId		 		= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END    
          ,DateChanged 			= @dateChanged  
          ,ChangedBy			= @changedBy 
     WHERE Id 	= @id
 EXEC [dbo].[GetOrgFinacialCalender] @userId, @roleId, @orgId, @id

   END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
