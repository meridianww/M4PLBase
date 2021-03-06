SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[LatestNotSceduleGatewayIds]
AS
SELECT MAX(Id) LatestGatewayId, JobID FROM JOBDL020Gateways (NOLOCK)
			WHERE ISNULL(GwyCompleted,0) = 1 
			AND JobId NOT IN 
					(SELECT DISTINCT JobId FROM JOBDL020Gateways (NOLOCK)
							WHERE GatewayTypeId = (SELECT TOP 1 Id FROM SYSTM000Ref_Options (NOLOCK) WHERE SysLookupCode = 'GatewayType' AND SysOptionName = 'Action') 
								AND JobId IS NOT NULL  AND GwyCompleted = 1)  GROUP BY JobID
GO
