
/****** Object:  View [dbo].[vwJobCard]    Script Date: 2/16/2020 9:22:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
FROM  dbo.JOBDL020Gateways GWY 
GO

CREATE UNIQUE CLUSTERED INDEX idx_vwJobGatewaysId ON vwJobGateways(ID)

CREATE NONCLUSTERED INDEX ucidx_vwJobGatewaysJobID ON vwJobGateways(JobID);
CREATE NONCLUSTERED INDEX ucidx_vwJobGatewaysGwyOrderType ON vwJobGateways(GwyOrderType);
CREATE NONCLUSTERED INDEX ucidx_vwJobGwyGatewayCode ON vwJobGateways(GwyGatewayCode);