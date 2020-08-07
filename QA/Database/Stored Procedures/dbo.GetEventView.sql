-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 06/August/2020
-- Description:	Get Event List by Event Type -- exec [dbo].[GetEventView] 4
-- =============================================
ALTER PROCEDURE [dbo].[GetEventView]
(
  @EventTypeId INT
)
AS
BEGIN
	
	SET NOCOUNT ON;

   	DECLARE @EventEntityRelationId INT
		,@ToEmailSubscriberTypeId INT
		,@CustomSubscriberId INT
		,@CCEmailSubscriberTypeId INT
		,@CustomToAddressEmail VARCHAR(200)
		,@CustomCCAddressEmail VARCHAR(200)
		
		SELECT @CustomSubscriberId = SubscriberId
	FROM [dbo].[EventSubscriber]
	WHERE SubscriberDescription = 'Custom'

	SELECT @ToEmailSubscriberTypeId = Id
	FROM [dbo].[EventSubscriberType]
	WHERE EventSubscriberTypeName = 'To'

	SELECT @CcEmailSubscriberTypeId = Id
	FROM [dbo].[EventSubscriberType]
	WHERE EventSubscriberTypeName = 'CC'

	
	-- Event Values
	SELECT ev.Id,
	       ev.EventName,
	       ev.EventShortName,
	       ev.FromMail,
		   ev.[Description],
		   ev.StatusId,
		   ev.EventTypeId
		,eer.ParentId
		,eecd.[Subject]
		,eecd.[IsBodyHtml]
		,(SELECT EmailAddresses
	FROM dbo.EventSubscriberRelation
	WHERE EventSubscriberTypeId = @CcEmailSubscriberTypeId
		AND EventEntityRelationId = eer.ID
		AND SubscriberId = @CustomSubscriberId) As ToEmail
		,(SELECT EmailAddresses
	FROM dbo.EventSubscriberRelation
	WHERE EventSubscriberTypeId = @ToEmailSubscriberTypeId
		AND EventEntityRelationId = eer.ID
		AND SubscriberId = @CustomSubscriberId) AS CcEmail
	FROM dbo.[Event] ev
	INNER JOIN dbo.EventEntityRelation eer ON ev.ID = eer.EventId
	INNER JOIN dbo.EventEntityContentDetail eecd ON eecd.EventEntityRelationId = eer.ID
	WHERE ev.EventTypeId = @EventTypeId


END
GO
