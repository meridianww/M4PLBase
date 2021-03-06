SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/11/2018
-- Description:	The stored procedure Updates the Job Gateway Status field with the current Gateway
-- =============================================
CREATE PROCEDURE [dbo].[scanUpdateJobGatewayStatus]
	-- Add the parameters for the stored procedure here
	@StatusId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE jobs
SET jobs.JobGatewayStatus = jobs.ProFlags11 + '-' + gateways.GwyGatewayCode
FROM JOBDL000Master jobs INNER JOIN JOBDL020Gateways gateways ON jobs.ProFlags11 = gateways.GwyGatewaySortOrder AND jobs.Id = gateways.JobID WHERE jobs.StatusId = @StatusId
END
GO
