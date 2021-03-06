SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/1/2018
-- Description:	The stored procedure returns all the Gateways that have EDI Shipment Status and Appointment Reason Codes that are completed and have not been processed yet.
--				The Status of the Job and Gateway needs to be 'Active' (value of 1)
-- =============================================
CREATE PROCEDURE [dbo].[ediGetEdiCompletedGateways_REMOVE] 
	-- Add the parameters for the stored procedure here
	@ProgramId bigint,
	@JobStatusId int, 
	@GatewayStatusId int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT JOBDL000Master.ProgramID, JOBDL000Master.Id, JOBDL000Master.StatusId, JOBDL020Gateways.GwyGatewayCode, JOBDL020Gateways.GwyCompleted, JOBDL020Gateways.GwyShipStatusReasonCode, JOBDL020Gateways.GwyShipApptmtReasonCode, JOBDL020Gateways.StatusId, JOBDL020Gateways.ProFlags02
FROM JOBDL020Gateways INNER JOIN JOBDL000Master ON JOBDL020Gateways.JobID = JOBDL000Master.Id
WHERE JOBDL000Master.ProgramID = @ProgramId AND JOBDL000Master.StatusId = @JobStatusId AND JOBDL020Gateways.StatusId = @GatewayStatusId AND JOBDL020Gateways.GwyShipStatusReasonCode Is Not Null AND JOBDL020Gateways.GwyShipApptmtReasonCode Is Not Null AND JOBDL020Gateways.GwyCompleted = 1
END
GO
