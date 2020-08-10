SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 06/Aug/2020
-- Description:	Insert Email Event
-- =============================================
CREATE PROCEDURE [dbo].[UpdEvent]
	(
	  @userId BIGINT,
	  @roleId BIGINT,
	  @orgId BIGINT,
	  @EventId INT,
	  @EventName VARCHAR(250),
	  @EventShortName VARCHAR(50),
	  @FromMail VARCHAR(200),
	  @Description VARCHAR(4000),
	  @XSLTPath VARCHAR(200),
	  @EventTypeId INT,
	  @StatusId INT,
	  @ParentId BIGINT, 
	  @IsBodyHtml BIT,
	  @Subject VARCHAR(50),
	  @ToEmailAddress VARCHAR(MAX),
	  @CCEmailAddress VARCHAR(MAX),
	  @uttEventSubscriber dbo.uttEventSubscriber READONLY
	)
AS
BEGIN
SET NOCOUNT ON;

DECLARE @EventEntityRelationId INT,@CustomSubscriberId INT, @ToEmailSubscriberTypeId INT, @CCEmailSubscriberTypeId INT

SELECT @EventEntityRelationId = Id FROM dbo.EventEntityRelation WHERE EventId = @EventId --AND ParentId = @ParentId

SELECT @CustomSubscriberId = SubscriberId FROM
[dbo].[EventSubscriber] Where SubscriberDescription = 'Custom'


SELECT @ToEmailSubscriberTypeId = Id FROM
[dbo].[EventSubscriberType] Where EventSubscriberTypeName = 'To'


SELECT @CcEmailSubscriberTypeId = Id FROM
[dbo].[EventSubscriberType] Where EventSubscriberTypeName = 'CC'

Update [dbo].[Event] SET 
            [EventName] = @EventName
           ,[EventShortName] = @EventShortName
           ,[FromMail] = @FromMail
           ,[Description] = @Description
           ,[XSLTPath] = @XSLTPath
           ,[StatusId] = @StatusId
           ,[EventTypeId] = @EventTypeId
		   ,[ChangedBy] = @userId
		   ,[DateChanged] = GETUTCDATE()
 WHERE Id = @EventId            
    	

UPDATE [dbo].[EventEntityRelation]
           SET [ParentId] = @ParentId
    WHERE  Id = @EventEntityRelationId
  

UPDATE [dbo].[EventEntityContentDetail]
            SET
            [Subject] = @Subject
           ,[IsBodyHtml] = @IsBodyHtml
  WHERE  EventEntityRelationId = @EventEntityRelationId

		   
DELETE FROM [dbo].[EventSubscriberRelation] 
WHERE EventEntityRelationId = @EventEntityRelationId		   
		   
		   		   
INSERT INTO [dbo].[EventSubscriberRelation]
           ([SubscriberId]
           ,[EventEntityRelationId]
           ,[EmailAddresses]
           ,[EventSubscriberTypeId])
     SELECT
           SubscriberId,
           @EventEntityRelationId,
           CASE WHEN SubscriberId =  @CustomSubscriberId AND  SubscriberTypeId =  @ToEmailSubscriberTypeId THEN @ToEmailAddress 
		         WHEN SubscriberId = @CustomSubscriberId AND  SubscriberTypeId =  @CcEmailSubscriberTypeId THEN @CCEmailAddress 
		   ELSE NULL END,
           SubscriberTypeId
		   FROM @uttEventSubscriber

END
GO
