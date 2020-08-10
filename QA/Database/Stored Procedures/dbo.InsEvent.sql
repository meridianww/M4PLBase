SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 06/Aug/2020
-- Description:	Insert Email Event
-- =============================================
ALTER PROCEDURE [dbo].[InsEvent]
	( 
	  @userId BIGINT,
	  @roleId BIGINT,
	  @orgId BIGINT,
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
BEGIN TRY

DECLARE @EventId INT, @EventEntityRelationId INT,@CustomSubscriberId INT, @ToEmailSubscriberTypeId INT, @CCEmailSubscriberTypeId INT


SELECT @CustomSubscriberId = SubscriberId FROM
[dbo].[EventSubscriber] Where SubscriberDescription = 'Custom'


SELECT @ToEmailSubscriberTypeId = Id FROM
[dbo].[EventSubscriberType] Where EventSubscriberTypeName = 'To'


SELECT @CcEmailSubscriberTypeId = Id FROM
[dbo].[EventSubscriberType] Where EventSubscriberTypeName = 'CC'

Select @EventId = ISNULL(Max(Id),0) + 1 From [dbo].[Event]
  
INSERT INTO [dbo].[Event]
           ([Id]
		   ,[EventName]
           ,[EventShortName]
           ,[FromMail]
           ,[Description]
           ,[CreatedDate]
           ,[XSLTPath]
           ,[StatusId]
           ,[EventTypeId]
		   ,[DateEntered]
		   ,[ChangedBy]
		   ,[EnteredBy]
		   ,[DateChanged])
     VALUES
           (@EventId
		   ,@EventName
           ,@EventShortName
           ,@FromMail
           ,@Description
           ,GETUTCDATE()
           ,@XSLTPath
           ,@StatusId
           ,@EventTypeId
		   ,GETUTCDATE()
		   ,@userId
		   ,null
		   ,null)
	
INSERT INTO [dbo].[EventEntityRelation]
           ([EventId]
           ,[ParentId])
     VALUES
           (@EventId
           ,@ParentId)

  SET @EventEntityRelationId = SCOPE_IDENTITY() 
  

INSERT INTO [dbo].[EventEntityContentDetail]
           ([EventEntityRelationId]
           ,[Subject]
           ,[IsBodyHtml]
		   ,[Body]
           )
     VALUES
           (@EventEntityRelationId
           ,@Subject
           ,@IsBodyHtml
		   ,''
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
		   FROM @uttEventSubscriber
		   

		   select @EventId
END TRY
BEGIN CATCH
 DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity

   SELECT 0

END CATCH

END
GO
