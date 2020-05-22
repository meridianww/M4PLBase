-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 21/May/2020
-- Description:	Get Program By Customer
-- =============================================
CREATE PROCEDURE [dbo].[GetProgramsByCustomer] (@CustId BIGINT)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Id
		,CASE 
			WHEN PrgPhaseCode IS NOT NULL
				THEN PrgPhaseCode
			WHEN PrgProjectCode IS NOT NULL
				THEN PrgProjectCode
			WHEN PrgProgramCode IS NOT NULL
				THEN PrgProgramCode
			END AS PrgProgramCode
	FROM [dbo].[PRGRM000Master]
	WHERE prgCustId = @CustId
		AND StatusId = 1
END
GO

