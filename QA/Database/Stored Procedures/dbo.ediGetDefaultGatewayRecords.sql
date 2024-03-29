SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 5/12/2018
-- Description:	The stored procedure gets all the active default records in the Program Gateway Defaults table by Program ID
-- =============================================
CREATE PROCEDURE [dbo].[ediGetDefaultGatewayRecords]
	-- Add the parameters for the stored procedure here
	@ProgramId bigint,
	@StatusActive nvarchar
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [PRGRM010Ref_GatewayDefaults].PgdProgramID, [PRGRM010Ref_GatewayDefaults].PgdGatewaySortOrder, [PRGRM010Ref_GatewayDefaults].PgdGatewayCode,
		[PRGRM010Ref_GatewayDefaults].PgdGatewayTitle, [PRGRM010Ref_GatewayDefaults].[PgdGatewayDescription], [PRGRM010Ref_GatewayDefaults].PgdGatewayDuration, 
		[PRGRM010Ref_GatewayDefaults].GatewayTypeId, [PRGRM010Ref_GatewayDefaults].UnitTypeId, [PRGRM010Ref_GatewayDefaults].PgdGatewayComment, 
		[PRGRM010Ref_GatewayDefaults].GatewayDateRefTypeId, SYSTM000Ref_Options.SysOptionName, [PRGRM010Ref_GatewayDefaults].StatusId
		FROM [PRGRM010Ref_GatewayDefaults] INNER JOIN SYSTM000Ref_Options ON [PRGRM010Ref_GatewayDefaults].GatewayTypeId = SYSTM000Ref_Options.Id
		WHERE PgdProgramID = @ProgramId AND PgdGatewayDefault = 1 AND [PRGRM010Ref_GatewayDefaults].StatusId = @StatusActive
END
GO
