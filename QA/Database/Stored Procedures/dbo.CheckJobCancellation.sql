SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 04/08/2020
-- Description:	Check Job Cancellation
-- =============================================
CREATE PROCEDURE [dbo].[CheckJobCancellation] (@JobId BIGINT)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @IsExists BIT = 0

	IF EXISTS (
			SELECT 1
			FROM dbo.JOBDL000Master WITH(NOLOCK)
			WHERE ID = @JobId AND IsCancelled = 1
			)
	BEGIN
		SET @IsExists = 1
	END

	SELECT @IsExists
END

GO
