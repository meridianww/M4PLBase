SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 07/28/2010
-- Description:	Import Gateway and Actions for a Program
-- =============================================
CREATE PROCEDURE [dbo].[ImportGatewayActionForProgram] @programId BIGINT
	,@changedBy NVARCHAR(150)
	,@dateChanged DATETIME2(7)
	,@uttGateway [dbo].[uttGateway] READONLY
AS
BEGIN
	SET NOCOUNT ON;

	MERGE [dbo].[PRGRM010Ref_GatewayDefaults] T
	USING @uttGateway S
		ON (
				S.Code = T.PgdGatewayCode
				AND S.OrderType = T.PgdOrderType
				AND S.ShipmentType = T.PgdShipmentType
				AND T.PgdProgramID = @programId
				)
	WHEN MATCHED
		THEN
			UPDATE
			SET T.PgdGatewayTitle = Title
				,T.UnitTypeId = S.Units
				,T.PgdGatewayDefault = S.[Default]
				,T.GatewayTypeId = S.[Type]
				,T.GatewayDateRefTypeId = S.DateReference
				,T.PgdShipStatusReasonCode = S.StatusReasonCode
				,T.PgdShipApptmtReasonCode = S.AppointmentReasonCode
				,T.StatusId = 1
				,T.PgdGatewayStatusCode = S.GatewayStatusCode
				,T.MappingId = S.NextGateway
				,T.PgdGatewayDefaultComplete = S.IsDefaultComplete
				,T.InstallStatusId = S.InstallStatus
				,T.TransitionStatusId = S.TransitionStatus
				,T.PgdGatewayDefaultForJob = S.IsStartGateway
				,T.ChangedBy = @changedBy
				,T.DateChanged = @dateChanged
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (
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
				,MappingId
				,PgdGatewayDefaultComplete
				,InstallStatusId
				,TransitionStatusId
				,PgdGatewayDefaultForJob
				,EnteredBy
				,DateEntered
				)
			VALUES (
				@programId
				,Code
				,OrderType
				,ShipmentType
				,Title
				,Units
				,[Default]
				,[Type]
				,DateReference
				,StatusReasonCode
				,AppointmentReasonCode
				,1
				,GatewayStatusCode
				,NextGateway
				,IsDefaultComplete
				,InstallStatus
				,TransitionStatus
				,IsStartGateway
				,@changedBy
				,@dateChanged
				);
END
GO

