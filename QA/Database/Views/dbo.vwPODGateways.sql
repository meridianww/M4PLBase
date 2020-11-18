SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPODGateways]
AS
	SELECT GatewayB.Id LatestGatewayId
		,GatewayB.JobID
	FROM JOBDL020Gateways GatewayB
	INNER JOIN SYSTM000Ref_Options ON GatewayB.GatewayTypeId = SYSTM000Ref_Options.Id
		AND SYSTM000Ref_Options.SysLookupCode = 'GatewayType'
		AND SYSTM000Ref_Options.SysOptionName = 'Gateway'
		AND GatewayB.GwyGatewayCode = 'POD Upload'
		AND GatewayB.GwyCompleted = 1
		AND GatewayB.JobId IS NOT NULL
GO
