SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 07 August 2020
-- Description:	Get event Subscriber
-- =============================================
CREATE PROCEDURE [dbo].[GetEventSubscriber]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT SubscriberId AS Id
		,SubscriberDescription
	FROM [DBO].[EVENTSUBSCRIBER]
END
GO

