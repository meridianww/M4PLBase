SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[scanUpdateJobCargoScannerFlags]
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE JOBDL010Cargo Set ProFlags11 = scanCargo.CgoProFlag11, ProFlags12 = scanCargo.CgoProFlag12, ProFlags13 = scanCargo.CgoProFlag13 FROM SCN005Cargo scanCargo WHERE JOBDL010Cargo.Id = scanCargo.CargoID
END
GO
