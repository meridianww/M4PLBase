SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- DROP VIEW [vwJobGateways]

CREATE  VIEW [dbo].[vwJobGateways]
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

CREATE UNIQUE CLUSTERED INDEX IX_vwJobGateways
	ON [vwJobGateways]
	(
	 ID
    ,JobID 
	,GwyOrderType
	,GwyGatewayCode
	,GwyCompleted
	,StatusId
	,GwyGatewayTitle
	,GatewayTypeId	
	)