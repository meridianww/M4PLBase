SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardhan Behara 
-- Create date:               11/11/2018      
-- Description:               Ins a Attachment  
-- Execution:                 EXEC [dbo].[InsAttachment]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
  
CREATE PROCEDURE  [dbo].[InsAttachment]  
	(@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@attTableName NVARCHAR(100) = NULL  
	,@attPrimaryRecordID BIGINT = NULL  
	,@attItemNumber INT = NULL  
	,@attTitle NVARCHAR(50) = NULL  
	,@attTypeId INT = NULL  
	,@attFileName NVARCHAR(50) = NULL  
	,@statusId INT =NULL 
	,@primaryTableFieldName NVARCHAR(100) = NULL
	,@where NVARCHAR(500) = NULL
	,@enteredBy NVARCHAR(50) = NULL  
	,@dateEntered DATETIME2(7) = NULL)  
AS  
BEGIN TRY                  
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT, @AttachmentCount INT     
  EXEC [dbo].[ResetItemNumber] @userId, 0, @attPrimaryRecordID, @entity, @attItemNumber, @statusId, NULL, @where, @updatedItemNumber OUTPUT  
    
 DECLARE @currentId BIGINT;  
 INSERT INTO [dbo].[SYSTM020Ref_Attachments]  
           ([AttTableName]  
           ,[AttPrimaryRecordID]  
           ,[AttItemNumber]  
           ,[AttTitle]  
           ,[AttTypeId]  
           ,[AttFileName]  
		   ,[StatusId]  
           ,[EnteredBy]  
           ,[DateEntered])  
     VALUES  
           (@attTableName
           ,@attPrimaryRecordID   
           ,@updatedItemNumber --@attItemNumber   
           ,@attTitle
           ,@attTypeId  
           ,@attFileName    
		   ,ISNULL(@statusId,1) 
           ,@enteredBy    
           ,@dateEntered)
     SET @currentId = SCOPE_IDENTITY();  

	 Select @AttachmentCount = Count(Id) From [dbo].[SYSTM020Ref_Attachments] Where [AttTableName] = @attTableName AND [AttPrimaryRecordID] = @attPrimaryRecordID AND StatusId IN (1,2)
	IF(ISNULL(@primaryTableFieldName, '') <> '')
		BEGIN
			DECLARE @updateQuery NVARCHAR(MAX)
			DECLARE @actualTableName NVARCHAR(100)
			SELECT @actualTableName = TblTableName FROM [dbo].[SYSTM000Ref_Table] WHERE SysRefName = @attTableName
			SET @updateQuery = 'UPDATE '+ @actualTableName + ' SET ' + @primaryTableFieldName + '=ISNULL(' + CAST(@AttachmentCount AS NVARCHAR(50)) + ', 0) WHERE Id='+CAST(@attPrimaryRecordID AS NVARCHAR(10)) +
							   '; SELECT * FROM [dbo].[SYSTM020Ref_Attachments] WHERE Id='+CAST(@currentId AS NVARCHAR(20))
			EXEC sp_executesql @updateQuery
		END
	ELSE
		BEGIN
			 SELECT * FROM [dbo].[SYSTM020Ref_Attachments] WHERE Id = @currentId;     
		END
END TRY                
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH

GO
