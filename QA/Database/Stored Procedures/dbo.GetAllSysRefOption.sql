SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal         
-- Create date:               05/06/2020     
-- Description:               Get a Sys Ref Option
-- =============================================
CREATE PROCEDURE [dbo].[GetAllSysRefOption]
AS
BEGIN TRY
	SET NOCOUNT ON;

	SELECT Id
		,SysLookupId
		,SysLookupCode
		,SysOptionName
		,SysSortOrder
		,SysDefault
		,IsSysAdmin
		,StatusId
	FROM [SYSTM000Ref_Options]
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

