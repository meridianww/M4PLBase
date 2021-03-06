SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a Job Attribute
-- Execution:                 EXEC [dbo].[InsJobAttribute]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 

CREATE PROCEDURE  [dbo].[InsJobAttribute]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@jobId bigint
	,@ajbLineOrder int
	,@ajbAttributeCode nvarchar(20)
	,@ajbAttributeTitle nvarchar(50)
	,@ajbAttributeQty decimal(18, 2)
	,@ajbUnitTypeId int
	,@ajbDefault bit
	,@statusId int = NULL
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  
  DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, 0, @jobId, @entity, @ajbLineOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
  
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[JOBDL030Attributes]
           ([JobID]
			,[AjbLineOrder]
			,[AjbAttributeCode]
			,[AjbAttributeTitle]
			,[AjbAttributeQty]
			,[AjbUnitTypeId]
			,[AjbDefault]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@jobId
			,@updatedItemNumber
		   	,@ajbAttributeCode
		   	,@ajbAttributeTitle
		   	,@ajbAttributeQty
		   	,@ajbUnitTypeId
		   	,@ajbDefault
			,ISNULL(@statusId,1)
		   	,@dateEntered
		   	,@enteredBy)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[JOBDL030Attributes] WHERE Id = @currentId;   
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
