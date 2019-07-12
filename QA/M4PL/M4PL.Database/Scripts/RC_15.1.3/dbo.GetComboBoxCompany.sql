SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
--==================================================================================    
-- Author        : Prashant Aggarwal  
-- Date          : 26 June 2019     
-- Description   : Stored Procedure to Get Combo Box For Company
--=================================================================================                      
CREATE PROCEDURE [dbo].[GetComboBoxCompany] @langCode NVARCHAR(10)
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@fields NVARCHAR(2000)
	,@pageNo INT
	,@pageSize INT
	,@orderBy NVARCHAR(500)
	,@like NVARCHAR(500) = NULL
	,@where NVARCHAR(500) = NULL
	,@primaryKeyValue NVARCHAR(100) = NULL
	,@primaryKeyName NVARCHAR(50) = NULL
	,@parentId BIGINT = NULL
	,@entityFor NVARCHAR(50) = NULL
	,@parentEntity NVARCHAR(50) = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;

	SELECT Id
		,CompCode
		,CompTitle
		,CompTableName
	FROM [dbo].[COMP000Master](NOLOCK) Company
	WHERE 1 = 1
		AND ISNULL(Company.StatusId, 1) = 1
	ORDER BY CompTitle
		,CompCode OFFSET 10 * (1 - 1) ROWS

	FETCH NEXT 10 ROWS ONLY
	OPTION (RECOMPILE);
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