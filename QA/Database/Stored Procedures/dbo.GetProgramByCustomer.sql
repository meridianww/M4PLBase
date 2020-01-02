/****** Object:  StoredProcedure [dbo].[GetCustomerLocations]    Script Date: 12/30/2019 6:12:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               12/30/2019      
-- Description:               Get all program code by customer ID
-- Execution:                 EXEC [dbo].[GetProgramByCustomer] 10012, 1, 10,'',1
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetProgramByCustomer] @CustomerId BIGINT
	,@pageNo INT
	,@pageSize INT
	,@like NVARCHAR(500) = NULL
	,@orgId BIGINT=0
AS
BEGIN TRY
	DECLARE @sqlCommand NVARCHAR(MAX) = ''
		,@newPgNo INT, @prgOrgId BIGINT =0;


	IF (@CustomerId IS NOT NULL)
	BEGIN
		SET @sqlCommand = 'SELECT * FROM (SELECT DISTINCT Id,PrgProgramCode AS ProgramIdCode FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgHierarchyLevel=1 AND PrgCustID =' + CONVERT(NVARCHAR(50), @CustomerId) +') AS RESULT' 
		PRINT @sqlCommand
		IF (ISNULL(@like, '') != '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' WHERE ('

			DECLARE @likeStmt NVARCHAR(MAX)

			SELECT @likeStmt = COALESCE(@likeStmt + ' OR ', '') + Item + ' LIKE ''%' + @like + '%' + ''''
			FROM [dbo].[fnSplitString]('ProgramIdCode', ',')

			SET @sqlCommand = @sqlCommand + @likeStmt + ') '
		END

		SET @sqlCommand = @sqlCommand + ' ORDER BY ProgramIdCode OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'

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