SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 08/05/2020
-- Description:	Get the Email Details Information From Database
-- =============================================
CREATE PROCEDURE [dbo].[GetEmailDetail] (
	@emailCount INT
	,@ToHours INT
	,@FromHours INT
	)
AS
BEGIN
	CREATE TABLE [#TempEmailDetail] (
		[EmailDetailID] INT
		,[FromAddress] VARCHAR(50)
		,[ToAddress] VARCHAR(500)
		,[CCAddress] VARCHAR(500)
		,[Subject] VARCHAR(1000)
		,[Body] NVARCHAR(MAX)
		,[IsBodyHtml] BIT
		,[EmailPriority] TINYINT
		,[LastAttemptDate] DATETIME
		,[Status] TINYINT
		,[RetryAttempt] TINYINT
		,[QueuedDate] DATETIME
		)

	INSERT INTO [#TempEmailDetail]
	SELECT TOP (@emailCount) [ID]
		,[FromAddress]
		,[ToAddress]
		,[CCAddress]
		,[Subject]
		,[Body]
		,[IsBodyHtml]
		,[EmailPriority]
		,[LastAttemptDate]
		,[Status]
		,[RetryAttempt]
		,[QueuedDate]
	FROM [dbo].[EmailDetail] WITH (NOLOCK)
	WHERE [Status] = 0
	
	UNION
	
	SELECT TOP (@emailCount) [ID]
		,[FromAddress]
		,[ToAddress]
		,[CCAddress]
		,[Subject]
		,[Body]
		,[IsBodyHtml]
		,[EmailPriority]
		,[LastAttemptDate]
		,[Status]
		,[RetryAttempt]
		,[QueuedDate]
	FROM [dbo].[EmailDetail] WITH (NOLOCK)
	WHERE [Status] = 2
		AND QueuedDate >= DATEADD(mi, (@FromHours * - 1), GetUTCDate())
		AND QueuedDate <= DATEADD(mi, (@ToHours * - 1), GetUTCDate())

	UPDATE [emailDetail]
	SET [Status] = 1
	FROM [dbo].[EmailDetail] [ED]
	INNER JOIN [#TempEmailDetail] [tblED] ON [ED].[ID] = [tblED].[EmailDetailId]

	SELECT [EmailDetailId] AS [ID]
		,[FromAddress]
		,ISNULL([ToAddress], '') AS [ToAddress]
		,ISNULL([CCAddress], '') AS [CCAddress]
		,ISNULL([Subject], '') AS [Subject]
		,ISNULL([Body], '') AS [Body]
		,[IsBodyHtml]
		,[EmailPriority]
		,[LastAttemptDate]
		,[Status]
		,[RetryAttempt]
	FROM [#TempEmailDetail]
	ORDER BY [QueuedDate] ASC

	SELECT [S].[ID]
		,ISNULL([S].[SMTPServerName], '') AS [SMTPServerName]
		,ISNULL([S].[SMTPServerPort], '') AS [SMTPServerPort]
		,ISNULL([S].[SMTPLoginUserName], '') AS [SMTPLoginUserName]
		,ISNULL([S].[SMTPLoginPassword], '') AS [SMTPLoginPassword]
		,[S].[IsSSLEnabled]
		,ISNULL([S].[DefaultFromAddress], '') AS [DefaultFromAddress]
	FROM [dbo].[SMTPServerDetail] [S] WITH (NOLOCK)

	SELECT [EA].[ID] AS [ID]
		,[EA].[EmailDetailID] AS [EmailDetailID]
		,[EA].[AttachmentName] AS [AttachmentName]
		,[EA].[Attachment] AS [Attachment]
	FROM [dbo].[EmailAttachment] [EA] WITH (NOLOCK)
	INNER JOIN [#TempEmailDetail] [tblED] ON [tblED].[EmailDetailID] = [EA].[EmailDetailId]

	DROP TABLE [#TempEmailDetail]
END
GO

