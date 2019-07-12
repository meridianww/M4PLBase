SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 7/9/2019
-- Description:	Update Company Address Information
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCOMP000Master] (
	 @CompOrgId BIGINT
	,@CompTableName NVARCHAR(100)
	,@CompPrimaryRecordId BIGINT
	,@CompCode NVARCHAR(20) = NULL
	,@CompTitle NVARCHAR(50) = NULL
	,@statusId INT = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[COMP000Master]
			WHERE [CompTableName] = @CompTableName
				AND [CompPrimaryRecordId] = @CompPrimaryRecordId
			)
	BEGIN
		INSERT INTO [dbo].[COMP000Master] (
			[CompOrgId]
			,[CompTableName]
			,[CompPrimaryRecordId]
			,[CompCode]
			,[CompTitle]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy]
			)
		VALUES (
			@CompOrgId
			,@CompTableName
			,@CompPrimaryRecordId
			,@CompCode
			,@CompTitle
			,@StatusId
			,ISNULL(@dateEntered, @dateChanged)
			,ISNULL(@enteredBy, @changedBy)
			)
	END
	ELSE
	BEGIN
		UPDATE [dbo].[COMP000Master]
		SET [CompOrgId] = @CompOrgId
			,[CompCode] = @CompCode
			,[CompTitle] = @CompTitle
			,[StatusId] = @StatusId
			,DateChanged = @dateChanged
			,ChangedBy = @changedBy
		WHERE [CompTableName] = @CompTableName
			AND [CompPrimaryRecordId] = @CompPrimaryRecordId
	END
END
GO

