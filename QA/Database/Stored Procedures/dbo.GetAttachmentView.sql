SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               11/10/2018      
-- Description:               Get all attachemnets for particular module and record
-- Execution:                 EXEC [dbo].[GetAttachmentView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE [dbo].[GetAttachmentView]
	 @userId BIGINT,
	 @roleId BIGINT,
	 @orgId BIGINT,
	 @entity NVARCHAR(100),
	 @pageNo INT,
	 @pageSize INT,
	 @orderBy NVARCHAR(500),
	 @groupBy NVARCHAR(500), 
	 @groupByWhere NVARCHAR(500), 
	 @where NVARCHAR(MAX),
	 @parentId BIGINT,
	 @isNext BIT,
	 @isEnd BIT,
	 @recordId BIGINT,
	 @TotalCount INT OUTPUT
AS
BEGIN TRY                
 SET NOCOUNT ON;  

 DECLARE @sqlCommand NVARCHAR(MAX);
 
 DECLARE @TCountQuery NVARCHAR(MAX);
 SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM020Ref_Attachments] (NOLOCK) '+ @entity +' WHERE '+ @entity +'.AttPrimaryRecordID= @parentId AND ISNULL(StatusId,1) IN (1,2)  ' + ISNULL(@where, '') ;
  
 EXEC sp_executesql @TCountQuery, N'@parentId BIGINT,  @TotalCount INT OUTPUT', @parentId,  @TotalCount  OUTPUT;

SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM020Ref_Attachments] (NOLOCK) '+ @entity

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[AttPrimaryRecordID] = @parentId AND  ISNULL(StatusId,1) IN (1,2)'+ ISNULL(@where, '') + 
	' ORDER BY '+ ISNULL(@orderBy, @entity+'.AttItemNumber') + 
	' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);' 

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(MAX), @parentId BIGINT, @entity NVARCHAR(100)' ,
     @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId
	 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
