SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Ins a  Program MVOC  
-- Execution:                 EXEC [dbo].[InsPrgMvoc]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
  
CREATE PROCEDURE  [dbo].[InsPrgMvoc]  
	(@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@vocOrgID bigint  
	,@vocProgramID bigint  
	,@vocSurveyCode nvarchar(20)  
	,@vocSurveyTitle nvarchar(50)  
	,@statusId int  
	,@vocDateOpen datetime2(7)  
	,@vocDateClose datetime2(7)  
	,@dateEntered datetime2(7)  
	,@enteredBy nvarchar(50)
	,@vocAllStar BIT = 0)  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @currentId BIGINT;  
 INSERT INTO [dbo].[MVOC000Program]  
           (VocOrgID  
   ,VocProgramID  
   ,VocSurveyCode  
   ,VocSurveyTitle  
   ,StatusId  
   ,VocDateOpen  
   ,VocDateClose 
   ,VocAllStar 
   ,DateEntered  
   ,EnteredBy)  
     VALUES  
           (@vocOrgID   
      ,@vocProgramID  
      ,@vocSurveyCode  
      ,@vocSurveyTitle  
      ,@statusId  
      ,@vocDateOpen  
      ,@vocDateClose 
	  ,@vocAllStar 
      ,@dateEntered  
      ,@enteredBy)  
   SET @currentId = SCOPE_IDENTITY();  
 SELECT * FROM [dbo].[MVOC000Program] WHERE Id = @currentId;   
END TRY                
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
