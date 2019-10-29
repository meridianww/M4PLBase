SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 10/23/2019
-- Description:	Insert Error Log Information
-- =============================================
CREATE PROCEDURE [dbo].[InsErrorLogInfo] (
	 @ErrRelatedTo [nvarchar](500)
	,@ErrInnerException [nvarchar](max)
	,@ErrMessage [nvarchar](max)
	,@ErrSource [nvarchar](364)
	,@ErrStackTrace [nvarchar](max)
	,@ErrAdditionalMessage [nvarchar](max)
	,@LogType [nvarchar](150)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		INSERT INTO dbo.SYSTM000ErrorLog (
			ErrRelatedTo
			,ErrInnerException
			,ErrMessage
			,ErrSource
			,ErrStackTrace
			,ErrAdditionalMessage
			,ErrDateStamp
			,LogType
			)
		VALUES (
			@ErrRelatedTo
			,@ErrInnerException
			,@ErrMessage
			,@ErrSource
			,@ErrStackTrace
			,@ErrAdditionalMessage
			,GETUTCDATE()
			,@LogType
			)
	END TRY

	BEGIN CATCH
		DECLARE @spName VARCHAR(MAX) = (
				SELECT OBJECT_NAME(@@PROCID)
				)

		EXEC [ErrorLog_LogDBErrors] @spName
	END CATCH
END
GO

