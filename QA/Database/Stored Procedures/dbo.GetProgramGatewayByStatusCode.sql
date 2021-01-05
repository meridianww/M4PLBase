SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 01/04/2021
-- Description:	Get Program Gateway By Status Code
-- =============================================
CREATE PROCEDURE [dbo].[GetProgramGatewayByStatusCode] 
 @orderType NVARCHAR(15)
,@shipmentType NVARCHAR(50) 
,@programId BIGINT
,@StatusCode NVARCHAR(6)
,@IsScheduled BIT
AS
BEGIN
SET NOCOUNT ON;
IF(@IsScheduled = 1)
BEGIN
	SELECT TOP 1 PgdGatewayCode
		  ,PgdGatewayTitle
		  ,PgdShipApptmtReasonCode
		  ,PgdShipStatusReasonCode
	FROM PRGRM010Ref_GatewayDefaults
	WHERE PgdProgramID = @programId
		AND PgdOrderType = @orderType
		AND PgdShipmentType = @shipmentType
		AND GatewayTypeId = 86
		AND StatusId = 1
		AND PgdShipApptmtReasonCode = @StatusCode
		--Order BY ID DESC
END
ELSE
BEGIN
IF(ISNULL(@orderType,'') = 'Return')
BEGIN
		SELECT TOP 1 PgdGatewayCode
		  ,PgdGatewayTitle
		  ,PgdShipApptmtReasonCode
		  ,PgdShipStatusReasonCode
	FROM PRGRM010Ref_GatewayDefaults
	WHERE PgdProgramID = @programId
		AND PgdOrderType = @orderType
		AND PgdShipmentType = @shipmentType
		AND GatewayTypeId = 86
		AND StatusId = 1
		AND PgdGatewayTitle = 'Scheduled Pick Up'
		Order BY ID DESC
END
ELSE
BEGIN
	SELECT TOP 1 PgdGatewayCode
		  ,PgdGatewayTitle
		  ,PgdShipApptmtReasonCode
		  ,PgdShipStatusReasonCode
	FROM PRGRM010Ref_GatewayDefaults
	WHERE PgdProgramID = @programId
		AND PgdOrderType = @orderType
		AND PgdShipmentType = @shipmentType
		AND GatewayTypeId = 86
		AND StatusId = 1
		AND PgdGatewayTitle = 'Initial Appointment'
		Order BY ID DESC
END
END
END
GO
