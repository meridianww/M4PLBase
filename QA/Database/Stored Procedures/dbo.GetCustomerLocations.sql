SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               11/08/2019      
-- Description:               Get all location side code by customer ID
-- Execution:                 EXEC [dbo].[GetCustomerLocations] 10007, 1, 10,''
-- Modified on:  
-- Modified Desc:  
-- =============================================   
CREATE PROCEDURE [dbo].[GetCustomerLocations] @CustomerId BIGINT
	,@pageNo INT
	,@pageSize INT
	,@like NVARCHAR(500) = NULL
AS
BEGIN TRY
	DECLARE @sqlCommand NVARCHAR(MAX) = ''
		,@newPgNo INT;

	IF (@CustomerId IS NOT NULL)
	BEGIN
		SET @sqlCommand = 'SELECT JobSiteCode AS LocationCode FROM (SELECT DISTINCT JobSiteCode FROM JOBDL000Master WHERE ProgramID IN (SELECT ID FROM PRGRM000Master WHERE StatusId IN (1,2) AND PrgCustID =' + CONVERT(NVARCHAR(50), @CustomerId) + ') AND JobSiteCode IS NOT NULL AND JobSiteCode <> '''' AND StatusId IN (1,2)) AS QueryResult'

		IF (ISNULL(@like, '') != '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' WHERE ('

			DECLARE @likeStmt NVARCHAR(MAX)

			SELECT @likeStmt = COALESCE(@likeStmt + ' OR ', '') + Item + ' LIKE ''%' + @like + '%' + ''''
			FROM [dbo].[fnSplitString]('JobSiteCode', ',')

			SET @sqlCommand = @sqlCommand + @likeStmt + ') '
		END

		SET @sqlCommand = @sqlCommand + ' ORDER BY LocationCode OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'

		PRINT @sqlCommand

		EXEC sp_executesql @sqlCommand
			,N'@pageNo INT, @pageSize INT, @CustomerId BIGINT'
			,@pageNo = @pageNo
			,@pageSize = @pageSize
			,@CustomerId = @CustomerId
	END
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH
GO
