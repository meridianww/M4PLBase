SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 11/03/2020
-- Description:	Get xCBL Exception Details
-- =============================================
CREATE PROCEDURE [dbo].[GetXcblExceptionInfo]  (@scenarioTypeId INT)
AS
BEGIN
	SET NOCOUNT ON;

	IF (@scenarioTypeId = 5)
	BEGIN
		SELECT TranDateTime TransactionDatetime
			,TranOrderNo OrderNumber
			,TranWebDocumentID DocumentId
		FROM [dbo].[XCBL_MER010TransactionLog]
		WHERE TranMessageCode <> 'Success'
			AND TranWebMessageNumber = '03.02'
	END
END
GO

