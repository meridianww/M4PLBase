USE [M4PL_Test]
GO

/****** Object:  StoredProcedure [dbo].[GetJobUpdateDecisionMaker]    Script Date: 2020-04-15 16:15:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 04/15/2020
-- Description:	Get the xCBL Details
-- =============================================
ALTER PROCEDURE [dbo].[UpdateJobFomXCBL] 
 (
   @columnsAndValues VARCHAR(MAX),
   @user VARCHAR(50),
   @JobId BIGINT
 )
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @UpdateQuery VARCHAR(MAX) = 'UPDATE dbo.JOBDL000Master SET ' + @columnsAndValues + ' WHERE Id = ' 
	      + CONVERT(VARCHAR, @JobId)
	--PRINT(@UpdateQuery)

	EXEC(@UpdateQuery)

END