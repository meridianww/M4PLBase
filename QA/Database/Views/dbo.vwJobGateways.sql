SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER  VIEW [dbo].[vwJobGateways]
WITH SCHEMABINDING
AS 
SELECT 
    GWY.ID
    ,GWY.JobID 
	,GWY.GwyOrderType
	,GWY.GwyGatewayCode
	,GWY.GwyCompleted
	,GWY.StatusId
	,GWY.GwyGatewayTitle
	,GWY.GatewayTypeId
FROM  dbo.JOBDL020Gateways GWY 


GO
