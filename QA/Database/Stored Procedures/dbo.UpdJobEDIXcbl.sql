SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal        
-- Create date:               18/02/2020    
-- Description:               Upd a Job EDI Xcbl
-- Execution:                 EXEC [dbo].[UpdJobEDIXcbl] 
-- =============================================
CREATE PROCEDURE [dbo].[UpdJobEDIXcbl] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@jobId BIGINT
	,@statusId INT
	,@edtCode NVARCHAR(20)
	,@edtTitle NVARCHAR(50)
	,@edtData NVARCHAR(Max)
	,@edtTypeId INT
	,@transactionDate DATETIME2(7)
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	UPDATE [dbo].[JOBDL070ElectronicDataTransactions]
	SET [JobId] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobId
			WHEN (
					(@isFormView = 0)
					AND (@jobId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@jobId, JobID)
			END
		,[EdtCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @edtCode
			WHEN (
					(@isFormView = 0)
					AND (@edtCode = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@edtCode, EdtCode)
			END
		,[EdtTitle] = CASE 
			WHEN (@isFormView = 1)
				THEN @edtTitle
			WHEN (
					(@isFormView = 0)
					AND (@edtTitle = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@edtTitle, EdtTitle)
			END
		,[StatusId] = CASE 
			WHEN (@isFormView = 1)
				THEN @statusId
			WHEN (
					(@isFormView = 0)
					AND (@statusId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@statusId, StatusId)
			END
		,[EdtData] = CASE 
			WHEN (@isFormView = 1)
				THEN @edtData
			WHEN (
					(@isFormView = 0)
					AND (@edtData = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@edtData, EdtData)
			END
		,[EdtTypeId] = CASE 
			WHEN (@isFormView = 1)
				THEN @edtTypeId
			WHEN (
					(@isFormView = 0)
					AND (@edtTypeId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@edtTypeId, EdtTypeId)
			END
		,TransactionDate = @dateChanged
		,[ChangedBy] = @changedBy
		,[DateChanged] = @dateChanged
	WHERE [Id] = @id;

	SELECT *
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

