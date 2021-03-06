SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[scanUpdateScannerCargoProcessingFlags]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE SCN005Cargo SET CgoProFlag11 = jobs.ProFlags11, CgoProFlag12 = jobs.ProFlags12
FROM JOBDL010Cargo jobCargo INNER JOIN JOBDL000Master jobs ON jobCargo.JobID = jobs.Id INNER JOIN SCN005Cargo scanCargo ON scanCargo.CargoID = jobCargo.Id
END
GO
