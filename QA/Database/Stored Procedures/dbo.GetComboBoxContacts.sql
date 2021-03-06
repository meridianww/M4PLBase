SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/15/2018      
-- Description:               Get Contacts by Owner
-- Execution:                 EXEC [dbo].[GetComboBoxContacts]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE [dbo].[GetComboBoxContacts]
	@userId BIGINT,
	@roleId BIGINT,
	@orgId BIGINT,
	@entity NVARCHAR(100),
	@pageNo INT=1,
	@pageSize INT=10,
	@orderBy NVARCHAR(500),
	@where NVARCHAR(500),
	@parentId BIGINT,
	@custId BIGINT,
	@vendId BIGINT,
	@progId BIGINT,
	@jobId BIGINT,
	@contactId BIGINT,
	@TotalCount INT OUTPUT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 DECLARE @sqlCommand NVARCHAR(MAX);
 
SELECT @TotalCount = COUNT(Id) FROM [dbo].[CONTC000Master]
SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' WHERE '+ ISNULL(@where, '1=1') + 
	' ORDER BY '+ ISNULL(@orderBy, @entity+'.Id') + 
	' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'  

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100)' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
