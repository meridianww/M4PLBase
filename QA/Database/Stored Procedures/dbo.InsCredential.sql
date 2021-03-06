SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a org credential
-- Execution:                 EXEC [dbo].[InsCredential]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[InsCredential]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@creItemNumber INT = NULL 
	,@creCode NVARCHAR(20) = NULL 
	,@creTitle NVARCHAR(50) = NULL 
	,@creExpDate DATETIME2(7) = NULL 
	,@statusId INT = NULL
	,@dateEntered DATETIME2(7) = NULL 
	,@enteredBy NVARCHAR(50) = NULL   
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @orgId, @entity, @creItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[ORGAN030Credentials]
           ([OrgId]
           ,[CreItemNumber]
           ,[CreCode]
           ,[CreTitle]
           ,[CreExpDate]
		   ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
		    (@orgId  
            ,@updatedItemNumber  
            ,@creCode  
            ,@creTitle  
            ,@creExpDate 
			,@statusId 
            ,@dateEntered  
            ,@enteredBy )  
	SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[ORGAN030Credentials] WHERE Id = @currentId;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdOrgCredential]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
