SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               12/01/2018      
-- Description:               Ins Report  
-- Execution:                 EXEC [dbo].[InsReport]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================    
CREATE PROCEDURE  [dbo].[InsReport]      
	@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@orgId BIGINT = NULL  
	,@mainModuleId INT = NULL  
	,@reportName NVARCHAR(100) = NULL  
	,@reportDesc NVARCHAR(255) = NULL  
	,@isDefault BIT  
	,@statusId INT = NULL
	,@dateEntered DATETIME2(7) = NULL  
	,@enteredBy NVARCHAR(50) = NULL  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @currentId BIGINT;  
IF NOT EXISTS(SELECT RprtMainModuleId FROM [dbo].[SYSTM000Ref_Report] WHERE [RprtMainModuleId] = @mainModuleId)  
 BEGIN  
  SET @isDefault =1  --first report should be default  
 END  
   INSERT INTO [dbo].[SYSTM000Ref_Report]  
           ([OrganizationId]  
           ,[RprtMainModuleId]  
           ,[RprtName]  
           ,[RprtDescription]  
           ,[RprtIsDefault]  
           ,[StatusId] 
           ,[DateEntered]  
           ,[EnteredBy])  
     VALUES  
      (@orgId  
           ,@mainModuleId  
           ,@reportName  
           ,@reportDesc  
           ,@isDefault  
           ,@statusId 
           ,@dateEntered  
           ,@enteredBy)    
     SET @currentId = SCOPE_IDENTITY();  
 EXEC [dbo].[GetReport] @userId, @roleId,  @orgId,  'EN',  @currentId   
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
