SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a cust finacial cal
-- Execution:                 EXEC [dbo].[InsCustFinacialCalender]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[InsCustFinacialCalender]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT  = NULL
	,@custId BIGINT  = NULL
	,@fclPeriod INT  = NULL
	,@fclPeriodCode NVARCHAR(20) = NULL 
	,@fclPeriodStart DATETIME2(7) = NULL 
	,@fclPeriodEnd DATETIME2(7)  = NULL
	,@fclPeriodTitle NVARCHAR(50) = NULL 
	,@fclAutoShortCode NVARCHAR(15) = NULL 
	,@fclWorkDays INT  = NULL
	,@finCalendarTypeId INT  = NULL
	,@statusId INT = NULL 
	,@dateEntered DATETIME2(7) = NULL 
	,@enteredBy NVARCHAR(50) = NULL 
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @custId, @entity, @fclPeriod, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
  
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[CUST050Finacial_Cal]
           ([OrgId]
           ,[CustId]
           ,[FclPeriod]
           ,[FclPeriodCode]
           ,[FclPeriodStart]
           ,[FclPeriodEnd]
           ,[FclPeriodTitle]
           ,[FclAutoShortCode]
           ,[FclWorkDays]
           ,[FinCalendarTypeId]
		   ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
		   (@orgId   
           ,@custId  
           ,@updatedItemNumber   
           ,@fclPeriodCode  
           ,@fclPeriodStart  
           ,@fclPeriodEnd  
           ,@fclPeriodTitle  
           ,@fclAutoShortCode  
           ,@fclWorkDays   
           ,@finCalendarTypeId  
		   ,@statusId
           ,@dateEntered 
           ,@enteredBy) 	
		   SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetCustFinacialCalender] @userId, @roleId, @orgId ,@currentId  
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
