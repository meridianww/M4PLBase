SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 11/03/2020
-- Description:	Get xCBL Exception Details
-- =============================================
CREATE PROCEDURE [dbo].[GetXcblExceptionInfo] (@scenarioTypeId INT)
AS
BEGIN
	SET NOCOUNT ON;

	--DECLARE @LastExecutionDate DATETIME2(7)

	--SELECT @LastExecutionDate = ExecutionDateTime
	--FROM [dbo].[EmailProcessingLog]
	--WHERE [ScenarioTypeId] = @scenarioTypeId

	IF (@scenarioTypeId = 5)
	BEGIN
		SELECT TranDateTime TransactionDatetime
			,TranOrderNo OrderNumber
			,TranWebDocumentID DocumentId
		FROM [dbo].[XCBL_MER010TransactionLog]
		WHERE TranMessageCode <> 'Success'
			AND TranWebMessageNumber = '03.02'
			--AND TranDateTime > CASE 
			--	WHEN @LastExecutionDate IS NULL
			--		THEN dateadd(HOUR, - 4, getdate())
			--	ELSE @LastExecutionDate
			--	END
	END

	IF (@scenarioTypeId = 6)
	BEGIN
		SELECT TranDateTime TransactionDatetime
			,TranOrderNo OrderNumber
			,TranWebDocumentID DocumentId
		FROM [dbo].[XCBL_MER010TransactionLog]
		WHERE TranMessageCode <> 'Success'
			AND TranWebMessageNumber = '03.01'
			--AND TranDateTime > CASE 
			--	WHEN @LastExecutionDate IS NULL
			--		THEN dateadd(HOUR, - 4, getdate())
			--	ELSE @LastExecutionDate
			--	END
	END

	IF (@scenarioTypeId = 7)
	BEGIN
		SELECT TranDateTime TransactionDatetime
			,TranOrderNo OrderNumber
			,TranWebDocumentID DocumentId
		FROM [dbo].[XCBL_MER010TransactionLog]
		WHERE TranMessageCode <> 'Success'
			AND TranWebMessageNumber IN ('06.04', '06.07', '06.08', '03.08')
			--AND TranDateTime > CASE 
			--	WHEN @LastExecutionDate IS NULL
			--		THEN dateadd(HOUR, - 4, getdate())
			--	ELSE @LastExecutionDate
			--	END
	END

	IF (@scenarioTypeId = 8)
	BEGIN
		SELECT TranDateTime TransactionDatetime
			,TranOrderNo OrderNumber
			,TranWebDocumentID DocumentId
		FROM [dbo].[XCBL_MER010TransactionLog]
		WHERE TranMessageCode <> 'Success'
			AND TranWebMessageNumber IN ('03.08', '03.12')
			--AND TranDateTime > CASE 
			--	WHEN @LastExecutionDate IS NULL
			--		THEN dateadd(HOUR, - 4, getdate())
			--	ELSE @LastExecutionDate
			--	END
	END
END
GO

