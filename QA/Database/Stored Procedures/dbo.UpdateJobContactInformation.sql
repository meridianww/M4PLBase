SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Kirty Anurag         
-- Create date:               09/11/2020        
-- Description:               Update Job Contact Information         
-- =============================================       
CREATE PROCEDURE [dbo].[UpdateJobContactInformation] (
	 @jobDeliveryAnalystContactID BIGINT = NULL
	,@jobDeliveryResponsibleContactId BIGINT = NULL
	,@jobDriverId BIGINT = NULL
	,@jobRouteId NVARCHAR(20)
	,@jobStop NVARCHAR(20) = NULL
	,@id BIGINT
	,@isFormView BIT = 0 
	)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[JOBDL000Master]
	SET [JobDriverId] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDriverId
			ELSE ISNULL(@jobDriverId, JobDriverId)
			END
		,[JobRouteId] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobRouteId
			ELSE ISNULL(@jobRouteId, JobRouteId)
			END
		,[JobStop] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobStop
			ELSE ISNULL(@jobStop, JobStop)
			END
		,[JobDeliveryAnalystContactID] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryAnalystContactID
			ELSE ISNULL(@jobDeliveryAnalystContactID, JobDeliveryAnalystContactID)
			END
		,[JobDeliveryResponsibleContactID] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryResponsibleContactID
			ELSE ISNULL(@jobDeliveryResponsibleContactID, JobDeliveryResponsibleContactID)
			END
	WHERE [Id] = @id;
END
GO

