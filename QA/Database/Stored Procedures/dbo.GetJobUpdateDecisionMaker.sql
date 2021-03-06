SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 04/15/2020
-- Description:	Get the ActionCode by xCBLColumn
-- =============================================
CREATE PROCEDURE [dbo].[GetJobUpdateDecisionMaker] 
AS
BEGIN
	SET NOCOUNT ON;

		SELECT 
	      ActionCode,
		  xCBLColumnName,
		  JobColumnName,
		  IsAutoUpdate,
		  XCBLTableName
	FROM JobUpdateDecisionMaker
END
GO
