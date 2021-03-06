SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*Copyright (2018) Meridian Worldwide Transportation Group
  All Rights Reserved Worldwide */
-- =====================================================================  
-- Author:                    Akhil Chauhan         
-- Create date:               02/01/2018
-- Description:               Update Status of Attachments and update the count of parent table attachment column 
-- Execution:                 EXEC [dbo].[DeleteAttachmentAndUpdateCount]  
-- Modified on:  
-- Modified Desc:  
-- ======================================================================    
CREATE PROCEDURE [dbo].[DeleteAttachmentAndUpdateCount]
@userId BIGINT,
@roleId BIGINT,
@orgId BIGINT,
@ids NVARCHAR(MAX),
@separator CHAR(1),
@statusId INT,
@parentTable NVARCHAR(100),
@parentFieldName NVARCHAR(100)
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 
 DECLARE @parentTableName NVARCHAR(100)
 DECLARE  @allIdTable TABLE ( Item NVARCHAR(1000))

 SELECT @parentTableName = TblTableName from [dbo].[SYSTM000Ref_Table] WHERE SysRefName = @parentTable

 INSERT INTO @allIdTable SELECT * FROM [dbo].[fnSplitString](@ids, @separator);

 UPDATE refAttachment SET refAttachment.StatusId=@statusId 
 FROM [dbo].[SYSTM020Ref_Attachments] refAttachment
 JOIN  @allIdTable allIdTbl ON refAttachment.Id = allIdTbl.Item

IF(ISNULL(@parentFieldName, '') <> '')
	BEGIN

		DECLARE @sqlCommand NVARCHAR(MAX);
		DECLARE @totalDeletedRecords INT;
		DECLARE @parentRecordId BIGINT;

		SELECT TOP 1 @parentRecordId=AttPrimaryRecordID 
		FROM [dbo].[SYSTM020Ref_Attachments] refAttachment
		JOIN @allIdTable allIdTbl ON refAttachment.Id = allIdTbl.Item

		SELECT @totalDeletedRecords=COUNT(Item) FROM @allIdTable;

		SET @sqlCommand = 'UPDATE '+ @parentTableName + ' SET ' + @parentFieldName + '=' + @parentFieldName + '-'+CAST(@totalDeletedRecords AS NVARCHAR(10))+
						  ' WHERE Id='+CAST(@parentRecordId AS NVARCHAR(10)) +
						  '; SELECT refAttachment.StatusId AS SysRefId, 0 as IsDefault, NULL as SysRefName, NULL as LangName, 0 as ParentId' +
						  ' FROM [dbo].[SYSTM020Ref_Attachments] refAttachment' + 
						  ' JOIN [dbo].[fnSplitString](''' + @ids + ''', ''' + @separator + ''') allIds ON refAttachment.Id = allIds.Item ' +
						  ' WHERE refAttachment.StatusId != ' + CAST(@statusId as varchar(100))
		
		 EXEC sp_executesql @sqlCommand

	END
ELSE
	BEGIN
		
		SELECT refAttachment.StatusId As SysRefId, 0 as IsDefault, NULL as SysRefName, NULL as LangName, 0 as ParentId 
		FROM [dbo].[SYSTM020Ref_Attachments] refAttachment
		JOIN @allIdTable allIdTbl ON refAttachment.Id = allIdTbl.Item
		WHERE refAttachment.StatusId != @statusId

	END 

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
