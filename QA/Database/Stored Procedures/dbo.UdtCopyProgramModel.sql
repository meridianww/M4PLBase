SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kirty
-- Create date: 03/22/2021
-- Description:	UdtCopyProgramModel
-- =============================================
CREATE PROCEDURE [dbo].[UdtCopyProgramModel] @recordId BIGINT
	,@isGateway BIT
	,@isAppointmentCode BIT
	,@isReasonCode BIT
	,@changedBy NVARCHAR(150)
	,@dateChanged DATETIME2(7)
	,@toPPPId BIGINT
AS
BEGIN
	SET NOCOUNT ON;

	IF (ISNULL(@isGateway, 0) > 0)
	BEGIN
		UPDATE dbo.[PRGRM010Ref_GatewayDefaults]
		SET StatusId = 3
		WHERE PgdProgramID = @toPPPId

		INSERT INTO dbo.[PRGRM010Ref_GatewayDefaults] (
			PgdProgramID
			,PgdGatewayCode
			,PgdOrderType
			,PgdShipmentType
			,PgdGatewayTitle
			,UnitTypeId
			,PgdGatewayDefault
			,GatewayTypeId
			,GatewayDateRefTypeId
			,PgdShipStatusReasonCode
			,PgdShipApptmtReasonCode
			,StatusId
			,PgdGatewayStatusCode
			,PgdGatewayDefaultComplete
			,TransitionStatusId
			,PgdGatewayDefaultForJob
			,EnteredBy
			,DateEntered
			)
		SELECT @toPPPId
			,PgdGatewayCode
			,PgdOrderType
			,PgdShipmentType
			,PgdGatewayTitle
			,UnitTypeId
			,PgdGatewayDefault
			,GatewayTypeId
			,GatewayDateRefTypeId
			,PgdShipStatusReasonCode
			,PgdShipApptmtReasonCode
			,StatusId
			,PgdGatewayStatusCode
			,PgdGatewayDefaultComplete
			,TransitionStatusId
			,PgdGatewayDefaultForJob
			,@changedBy
			,@dateChanged
		FROM dbo.[PRGRM010Ref_GatewayDefaults]
		WHERE PgdProgramID = @recordId
			AND [StatusId] = 1
	END

	IF (ISNULL(@isAppointmentCode, 0) > 0)
	BEGIN
		UPDATE dbo.PRGRM031ShipApptmtReasonCodes
		SET StatusId = 3
		WHERE PacProgramID = @toPPPId

		INSERT INTO dbo.PRGRM031ShipApptmtReasonCodes (
			[PacApptReasonCode]
			,[PacApptInternalCode]
			,[PacApptPriorityCode]
			,[PacApptTitle]
			,[PacApptDescription]
			,[PacApptComment]
			,[PacApptCategoryCodeId]
			,[PacApptUser01Code]
			,[PacApptUser02Code]
			,[PacApptUser03Code]
			,[PacApptUser04Code]
			,[PacApptUser05Code]
			,[StatusId]
			,[PacProgramID]
			,[EnteredBy]
			,[DateEntered]
			,[PacOrgID]
			)
		SELECT [PacApptReasonCode]
			,[PacApptInternalCode]
			,[PacApptPriorityCode]
			,[PacApptTitle]
			,[PacApptDescription]
			,[PacApptComment]
			,[PacApptCategoryCodeId]
			,[PacApptUser01Code]
			,[PacApptUser02Code]
			,[PacApptUser03Code]
			,[PacApptUser04Code]
			,[PacApptUser05Code]
			,1
			,@toPPPId
			,@changedBy
			,@dateChanged
			,[PacOrgID]
		FROM dbo.PRGRM031ShipApptmtReasonCodes
		WHERE [PacProgramID] = @recordId
			AND [StatusId] = 1
	END

	IF (ISNULL(@isReasonCode, 0) > 0)
	BEGIN
		UPDATE dbo.PRGRM030ShipStatusReasonCodes
		SET StatusId = 3
		WHERE PscProgramID = @toPPPId

		INSERT INTO dbo.PRGRM030ShipStatusReasonCodes (
			[PscShipReasonCode]
			,[PscShipInternalCode]
			,[PscShipPriorityCode]
			,[PscShipTitle]
			,[PscShipDescription]
			,[PscShipComment]
			,[PscShipCategoryCode]
			,[PscShipUser01Code]
			,[PscShipUser02Code]
			,[PscShipUser03Code]
			,[PscShipUser04Code]
			,[PscShipUser05Code]
			,[StatusId]
			,[PscProgramID]
			,[EnteredBy]
			,[DateEntered]
			,[PscOrgId]
			)
		SELECT [PscShipReasonCode]
			,[PscShipInternalCode]
			,[PscShipPriorityCode]
			,[PscShipTitle]
			,[PscShipDescription]
			,[PscShipComment]
			,[PscShipCategoryCode]
			,[PscShipUser01Code]
			,[PscShipUser02Code]
			,[PscShipUser03Code]
			,[PscShipUser04Code]
			,[PscShipUser05Code]
			,1
			,@toPPPId
			,@changedBy
			,@dateChanged
			,[PscOrgId]
		FROM PRGRM030ShipStatusReasonCodes
		WHERE [PscProgramID] = @recordId
			AND [StatusId] = 1
	END
END
GO

