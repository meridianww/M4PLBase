SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 08/05/2010
-- Description:	Insert Email Details Information
-- =============================================
CREATE PROCEDURE [dbo].[InsertEmailDetail] 
(    @FromAddress VARCHAR(50)
	,@ToAddress VARCHAR(500)
	,@CCAddress VARCHAR(500)
	,@Subject VARCHAR(1000)
	,@IsBodyHtml BIT
	,@Body NVARCHAR(MAX)
	,@EmailAttachment [uttEmailAttachment] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @EmailId BIGINT

	INSERT INTO [dbo].[EmailDetail] (
		[FromAddress]
		,[ToAddress]
		,[CCAddress]
		,[Subject]
		,[IsBodyHtml]
		,[Body]
		)
	VALUES (
		@FromAddress
		,@ToAddress
		,@CCAddress
		,@Subject
		,@IsBodyHtml
		,@Body
		)

    SET @EmailId = SCOPE_IDENTITY()

	IF EXISTS (SELECT 1 FROM @EmailAttachment)
	BEGIN
		INSERT INTO [dbo].[EmailAttachment] (
			[EmailDetailID]
			,[AttachmentName]
			,[Attachment]
			)
		SELECT @EmailId
			,Att.[AttachmentName]
			,Att.[Attachment]
		FROM @EmailAttachment Att
		WHERE Att.[Attachment] IS NOT NULL
			AND Att.[AttachmentName] IS NOT NULL
	END
END
GO

