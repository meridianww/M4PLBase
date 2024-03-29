SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a cust finacial cal
-- Execution:                 EXEC [dbo].[UpdCustFinacialCalender]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[UpdCustFinacialCalender]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL 
	,@custId BIGINT = NULL 
	,@fclPeriod INT  = NULL
	,@fclPeriodCode NVARCHAR(20)  = NULL
	,@fclPeriodStart DATETIME2(7)  = NULL
	,@fclPeriodEnd DATETIME2(7)  = NULL
	,@fclPeriodTitle NVARCHAR(50)  = NULL
	,@fclAutoShortCode NVARCHAR(15)  = NULL
	,@fclWorkDays INT  = NULL
	,@finCalendarTypeId INT  = NULL
	,@statusId INT = NULL 
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
    DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @custId, @entity, @fclPeriod, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  


    UPDATE  [dbo].[CUST050Finacial_Cal]
      SET  OrgId				= ISNULL(@orgId, OrgId)
          ,CustId				= ISNULL(@custId, CustId) 
          ,FclPeriod			= ISNULL(@updatedItemNumber, FclPeriod) 
          ,FclPeriodCode		= ISNULL(@fclPeriodCode, FclPeriodCode) 
          ,FclPeriodStart		= CASE WHEN (@isFormView = 1) THEN @fclPeriodStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @fclPeriodStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@fclPeriodStart, FclPeriodStart) END
          ,FclPeriodEnd			= CASE WHEN (@isFormView = 1) THEN @fclPeriodEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @fclPeriodEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@fclPeriodEnd, FclPeriodEnd) END
          ,FclPeriodTitle		= ISNULL(@fclPeriodTitle, FclPeriodTitle) 
          ,FclAutoShortCode		= ISNULL(@fclAutoShortCode, FclAutoShortCode) 
          ,FclWorkDays			= ISNULL(@fclWorkDays, FclWorkDays) 
          ,FinCalendarTypeId	= ISNULL(@finCalendarTypeId, FinCalendarTypeId)   
          ,StatusId				= ISNULL(@statusId, StatusId) 
          ,DateChanged			= ISNULL(@dateChanged,DateChanged)
          ,ChangedBy 			= ISNULL(@changedBy, ChangedBy)	
	  WHERE Id = @id
	EXEC [dbo].[GetCustFinacialCalender] @userId, @roleId, @orgId ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
