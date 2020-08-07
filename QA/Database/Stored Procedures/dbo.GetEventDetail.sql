SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 06/Aug/2020
-- Description:	Get Event Event Detail exec [dbo].[GetEventDetail] 9
-- =============================================
ALTER PROCEDURE [dbo].[GetEventDetail] (@EventId INT)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @EventEntityRelationId INT
		,@ToEmailSubscriberTypeId INT
		,@CustomSubscriberId INT
		,@CCEmailSubscriberTypeId INT
		,@CustomToAddressEmail VARCHAR(200)
		,@CustomCCAddressEmail VARCHAR(200)

	SELECT @EventEntityRelationId = Id
	FROM dbo.EventEntityRelation
	WHERE EventId = @EventId

	SELECT @CustomSubscriberId = SubscriberId
	FROM [dbo].[EventSubscriber]
	WHERE SubscriberDescription = 'Custom'

	SELECT @ToEmailSubscriberTypeId = Id
	FROM [dbo].[EventSubscriberType]
	WHERE EventSubscriberTypeName = 'To'

	SELECT @CcEmailSubscriberTypeId = Id
	FROM [dbo].[EventSubscriberType]
	WHERE EventSubscriberTypeName = 'CC'

	---- All Values to Bind Dropwdown
	--SELECT *
	--FROM dbo.EventSubscriber

	-- Selected Values from To Email Address	
	SELECT es.SubscriberId AS Id,es.SubscriberDescription AS EventSubscriberTypeName
	FROM dbo.EventSubscriberRelation esr
	INNER JOIN dbo.EventSubscriber es ON es.SubscriberId = esr.SubscriberId
	WHERE EventSubscriberTypeId = @ToEmailSubscriberTypeId
		AND EventEntityRelationId = @EventEntityRelationId

	-- Selected Values from CC Email Address	
	SELECT es.SubscriberId AS Id,es.SubscriberDescription AS EventSubscriberTypeName
	FROM dbo.EventSubscriberRelation esr
	INNER JOIN dbo.EventSubscriber es ON es.SubscriberId = esr.SubscriberId
	WHERE EventSubscriberTypeId = @CcEmailSubscriberTypeId
		AND EventEntityRelationId = @EventEntityRelationId

	SELECT @CustomToAddressEmail = EmailAddresses
	FROM dbo.EventSubscriberRelation
	WHERE EventSubscriberTypeId = @CcEmailSubscriberTypeId
		AND EventEntityRelationId = @EventEntityRelationId
		AND SubscriberId = @CustomSubscriberId

	SELECT @CustomCCAddressEmail = EmailAddresses
	FROM dbo.EventSubscriberRelation
	WHERE EventSubscriberTypeId = @ToEmailSubscriberTypeId
		AND EventEntityRelationId = @EventEntityRelationId
		AND SubscriberId = @CustomSubscriberId

	-- Event Values
	SELECT 
	       ev.Id,
	       ev.EventName,
	       ev.EventShortName,
	       ev.FromMail,
		   ev.[Description],
		   ev.StatusId,
		   ev.EventTypeId
		,eer.ParentId
		,eecd.[Subject]
		,eecd.[IsBodyHtml]
		,@CustomToAddressEmail
		,@CustomCCAddressEmail
	FROM dbo.[Event] ev
	INNER JOIN dbo.EventEntityRelation eer ON ev.ID = eer.EventId
	INNER JOIN dbo.EventEntityContentDetail eecd ON eecd.EventEntityRelationId = eer.ID
	WHERE ev.ID = @EventId
END
GO

