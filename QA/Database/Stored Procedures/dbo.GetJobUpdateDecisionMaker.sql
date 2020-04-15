USE [M4PL_Test]
GO
/****** Object:  StoredProcedure [dbo].[GetActionCodeByxCBLColumnName]    Script Date: 2020-04-15 15:40:21 ******/
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
		  IsAutoUpdate
	FROM JobUpdateDecisionMaker
END
