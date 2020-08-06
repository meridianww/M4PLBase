SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO

-- =============================================
-- Author:	Prashant Aggarwal
-- Create date: 08-06-2020
-- Description:	Update Email Status
-- =============================================
CREATE PROCEDURE [dbo].[UpdateEmailStatus] (
	 @id INT
	,@emailStatus TINYINT
	,@retryAttampts TINYINT
	)
AS
BEGIN
	UPDATE dbo.EmailDetail
	SET [Status] = @emailStatus
		,RetryAttempt = @retryAttampts
		,LastAttemptDate = GETUTCDATE()
	WHERE ID = @id
END
GO

