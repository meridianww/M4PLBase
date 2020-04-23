SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 04/23/2020
-- Description:	Insert data into job Cargo Table
-- =============================================
CREATE PROCEDURE [dbo].[InsertJobCargoData] @uttjobCargo [dbo].[uttjobCargo] READONLY
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @jobId BIGINT

	SELECT TOP 1 @jobId = JobId
	FROM @uttjobCargo

	UPDATE dbo.JOBDL010Cargo
	SET StatusId = 2
	WHERE JobId = @jobId

	INSERT INTO dbo.JOBDL010Cargo (
		[JobID]
		,[CgoLineItem]
		,[CgoPartNumCode]
		,[CgoTitle]
		,[CgoSerialNumber]
		,[CgoPackagingType]
		,[CgoWeight]
		,[CgoWeightUnits]
		,[CgoVolumeUnits]
		,[CgoCubes]
		,[CgoQtyUnits]
		,[CgoQTYOrdered]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
		)
	SELECT [JobID]
		,[CgoLineItem]
		,[CgoPartNumCode]
		,[CgoTitle]
		,[CgoSerialNumber]
		,[CgoPackagingType]
		,[CgoWeight]
		,[CgoWeightUnits]
		,[CgoVolumeUnits]
		,[CgoCubes]
		,[CgoQtyUnits]
		,[CgoQTYOrdered]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
	FROM @uttjobCargo
END
GO

