SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal        
-- Create date:               18/02/2020          
-- Description:               Get a Job EDIXcbl 
-- Execution:                 EXEC [dbo].[GetJobEDIXcbl]  
-- =============================================  
CREATE PROCEDURE [dbo].[GetJobEDIXcbl] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@id BIGINT
AS
BEGIN TRY
	SET NOCOUNT ON;

	SELECT Id
		,JobId EdtCode
		,EdtTitle
		,StatusId
		,EdtData
		,EdtTypeId
		,DateEntered
		,EnteredBy
		,DateChanged
		,ChangedBy
	FROM [dbo].[JOBDL070ElectronicDataTransactions] job
	WHERE [Id] = @id
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

