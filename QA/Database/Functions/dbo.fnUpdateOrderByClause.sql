SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil
-- Create date:               12/26/2018      
-- Description:               To get updated sorting qeury for Ref_options tables
-- Modified on:  
-- ============================================= 

CREATE FUNCTION [dbo].[fnUpdateOrderByClause]  
(
	@entity NVARCHAR(100),
	@orderBy NVARCHAR(500) 
)
RETURNS @orderClauseResult TABLE (
   OrderClause NVARCHAR(500),
   JoinClause NVARCHAR(500)
)
AS
BEGIN
	DECLARE @updatedOrderByClause NVARCHAR(500)=@orderBy, @joinClause NVARCHAR(500)='';

	IF((CHARINDEX(',', @orderBy) = 0) AND (@orderBy LIKE '%'+@entity+'.%'))
	BEGIN
		DECLARE @tempOrderByTable TABLE(Item NVARCHAR(1000));
		DECLARE @currentColumnNameWithEntity NVARCHAR(500),@currentColumnName NVARCHAR(500), @currentSortOrder NVARCHAR(50), @currentLookupId INT = NULL;
		INSERT INTO @tempOrderByTable SELECT Item FROM [dbo].[fnSplitString](@orderBy, ' ');
		SELECT @currentColumnNameWithEntity = Item FROM @tempOrderByTable WHERE Item LIKE '%'+@entity+'.%';
		SELECT @currentSortOrder = Item FROM @tempOrderByTable WHERE (ISNULL(Item, '') <> '') AND ITEM NOT LIKE '%'+@entity+'.%'; 
		SELECT @currentColumnName = REPLACE(@currentColumnNameWithEntity, @entity+'.', '');
		SELECT @currentLookupId=ColLookupId FROM [dbo].[SYSTM000ColumnsAlias] WHERE ColTableName = @entity AND ColColumnName = @currentColumnName;
		IF(ISNULL(@currentLookupId, 0) > 0)
		BEGIN
			SET @joinClause = ' LEFT JOIN [dbo].[SYSTM000Ref_Options] refOpOrderBy ON ' + @currentColumnNameWithEntity + '=refOpOrderBy.Id AND refOpOrderBy.SysLookupId=' + CAST(@currentLookupId AS NVARCHAR(100)) + ' ';
			SET @updatedOrderByClause =  ' refOpOrderBy.SysOptionName ' + @currentSortOrder + ' ';
		END
	END

	INSERT INTO @orderClauseResult(OrderClause, JoinClause) VALUES(@updatedOrderByClause, @joinClause);

	RETURN
END
GO
