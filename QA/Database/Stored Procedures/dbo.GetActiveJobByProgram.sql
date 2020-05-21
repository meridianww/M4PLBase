SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 21/May/2020
-- Description:	Get the Active Jobs by Program
-- =============================================
CREATE PROCEDURE [dbo].[GetActiveJobByProgram] (@ProgramId BIGINT)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Id
		,JobCustomerSalesOrder
	FROM [dbo].[JOBDL000Master]
	WHERE ProgramID = @ProgramId
		AND StatusId = 1
		AND JobCompleted = 0
END
GO
