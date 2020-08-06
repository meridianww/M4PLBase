SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 06/Aug/2020
-- Description:	Insert Email Event
-- =============================================
CREATE PROCEDURE [dbo].[InsEvent]
	(
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

DECLARE @EventId INT, @EventEntityRelationId INT,@CustomSubscriberId INT, @ToEmailSubscriberTypeId INT, @CCEmailSubscriberTypeId INT


SELECT @CustomSubscriberId = SubscriberId FROM
[dbo].[EventSubscriber] Where SubscriberDescription = 'Custom'


SELECT @ToEmailSubscriberTypeId = Id FROM
[dbo].[EventSubscriberType] Where EventSubscriberTypeName = 'To'


SELECT @CcEmailSubscriberTypeId = Id FROM
[dbo].[EventSubscriberType] Where EventSubscriberTypeName = 'CC'

  
INSERT INTO [dbo].[Event]
           ([EventName]
           ,[EventShortName]
           ,[FromMail]
           ,[Description]
           ,[CreatedDate]
           ,[XSLTPath]
           ,[StatusId]
           ,[EventTypeId])
     VALUES
           (@EventName
           ,@EventShortName
           ,@FromMail
           ,@Description
           ,GETUTCDATE()
           ,@XSLTPath
           ,@StatusId
           ,@EventTypeId)
    
	SELECT @EventId = SCOPE_IDENTITY() 
	
INSERT INTO [dbo].[EventEntityRelation]
           ([EventId]
           ,[ParentId])
     VALUES
           (@EventId
           ,@ParentId)

  SELECT @EventEntityRelationId = SCOPE_IDENTITY() 
  

INSERT INTO [dbo].[EventEntityContentDetail]
           ([EventEntityRelationId]
           ,[Subject]
           ,[IsBodyHtml]
           )
     VALUES
           (@EventEntityRelationId
           ,@Subject
           ,@IsBodyHtml
           )

		   		   
INSERT INTO [dbo].[EventSubscriberRelation]
           ([SubscriberId]
           ,[EventEntityRelationId]
           ,[EmailAddresses]
           ,[EventSubscriberTypeId])
     SELECT
           SubscriberId,
           @EventEntityRelationId,
           CASE WHEN SubscriberId = @CustomSubscriberId AND @ToEmailSubscriberTypeId =  SubscriberTypeId THEN @ToEmailAddress 
		         WHEN SubscriberId = @CustomSubscriberId AND @CcEmailSubscriberTypeId =  SubscriberTypeId THEN @CCEmailAddress 
		   ELSE NULL END,
           SubscriberTypeId
		   FROM dbo.uttEventSubscriber
		   

END
GO
