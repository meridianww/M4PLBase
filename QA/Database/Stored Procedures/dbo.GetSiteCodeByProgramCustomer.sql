/****** Object:  StoredProcedure [dbo].[GetCustomerLocations]    Script Date: 12/31/2019 2:46:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               31/12/2019      
-- Description:               Get all location side code by program ID
-- Execution:                 EXEC [dbo].[GetSiteCodeByProgramCustomer] 10012, 1, 100,''
-- Modified on:  
-- Modified Desc:  
-- =============================================   
CREATE PROCEDURE [dbo].[GetSiteCodeByProgramCustomer] @ProgramId BIGINT
	,@pageNo INT
	,@pageSize INT
	,@like NVARCHAR(500) = NULL 
AS
BEGIN TRY
	DECLARE @sqlCommand NVARCHAR(MAX) = ''
		,@newPgNo INT;

	IF (@ProgramId IS NOT NULL)
	BEGIN
		SET @sqlCommand = 'SELECT DISTINCT JobSiteCode AS ProgramIdCode FROM JOBDL000Master WHERE ProgramID = ' + CAST(@ProgramId AS nvarchar(20)) + ' AND StatusId IN (1,2) AND JobSiteCode IS NOT NULL AND JobSiteCode <> '''''
		IF (ISNULL(@like, '') != '')
		BEGIN
			SET @sqlCommand = @sqlCommand + ' WHERE ('

			DECLARE @likeStmt NVARCHAR(MAX)

			SELECT @likeStmt = COALESCE(@likeStmt + ' OR ', '') + Item + ' LIKE ''%' + @like + '%' + ''''
			FROM [dbo].[fnSplitString]('JobSiteCode', ',')

			SET @sqlCommand = @sqlCommand + @likeStmt + ') '
		END

		SET @sqlCommand = @sqlCommand + ' ORDER BY ProgramIdCode OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'
		
		EXEC sp_executesql @sqlCommand
			,N'@pageNo INT, @pageSize INT, @ProgramId BIGINT'
			,@pageNo = @pageNo
			,@pageSize = @pageSize
			,@ProgramId = @ProgramId 
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