SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwNoPODGateways]
AS
	SELECT GatewayA.Id LatestGatewayId
		,GatewayA.JobID
	FROM JOBDL020Gateways(NOLOCK) GatewayA
	INNER JOIN SYSTM000Ref_Options ON GatewayA.GatewayTypeId = SYSTM000Ref_Options.Id
		AND SYSTM000Ref_Options.SysLookupCode = 'GatewayType'
		AND SYSTM000Ref_Options.SysOptionName = 'Gateway'
		AND GatewayA.GwyGatewayCode = 'Delivered'
		AND GatewayA.GwyCompleted = 1
		AND GatewayA.JobId IS NOT NULL
	LEFT JOIN [dbo].[vwPODGateways] GatewayB ON GatewayA.JobID = GatewayB.JobID
	WHERE GatewayB.JobID IS NULL
GO
