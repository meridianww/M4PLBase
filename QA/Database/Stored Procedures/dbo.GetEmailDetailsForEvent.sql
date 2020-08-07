SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 08/06/2020
-- Description:	Get Email Details For Event
-- =============================================
CREATE PROCEDURE [dbo].[GetEmailDetailsForEvent] @EventId INT
	,@ParentId BIGINT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT E.FromMail
		,EC.[Subject]
		,EC.Body
		,EC.IsBodyHtml
		,E.XSLTPath
	FROM dbo.[Event] E
	INNER JOIN dbo.EventEntityRelation ER ON ER.EventId = E.Id
	INNER JOIN dbo.EventEntityContentDetail EC ON EC.EventEntityRelationId = ER.Id
	WHERE E.ID = @EventId
		AND ER.ParentId = @ParentId

	SELECT CASE 
			WHEN EC.EventSubscriberTypeId = 1
				THEN EmailAddresses
			ELSE NULL
			END ToAddress
		,CASE 
			WHEN EC.EventSubscriberTypeId = 2
				THEN EmailAddresses
			ELSE NULL
			END CcAddress
	FROM dbo.EventSubscriberRelation EC
	INNER JOIN dbo.EventEntityRelation ER ON ER.Id = EC.EventEntityRelationId
	INNER JOIN dbo.[Event] E ON E.Id = ER.EventId
	WHERE E.ID = @EventId
		AND ER.ParentId = @ParentId
END
GO

