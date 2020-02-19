SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal        
-- Create date:               18/02/2020      
-- Description:               Ins a Job EDI XCBL
-- Execution:                 EXEC [dbo].[InsJobEDIXcbl]
-- =============================================
CREATE PROCEDURE [dbo].[InsJobEDIXcbl] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@jobId BIGINT
	,@statusId INT
	,@edtCode NVARCHAR(20)
	,@edtTitle NVARCHAR(50)
	,@edtData NVARCHAR(Max)
	,@edtTypeId INT
	,@enteredBy NVARCHAR(50)
	,@dateEntered DATETIME2(7)
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @currentId BIGINT;

	INSERT INTO [dbo].[JOBDL070ElectronicDataTransactions] (
		[JobId]
		,[EdtCode]
		,[EdtTitle]
		,[StatusId]
		,[EdtData]
		,[EdtTypeId]
		,[DateEntered]
		,[EnteredBy]
		)
	VALUES (
		@JobId
		,@edtCode
		,@edtTitle
		,1
		,@edtData
		,@edtTypeId
		,@dateEntered
		,@enteredBy
		)

	SET @currentId = SCOPE_IDENTITY();

	SELECT *
	FROM [dbo].[JOBDL070ElectronicDataTransactions]
	WHERE Id = @currentId;
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

