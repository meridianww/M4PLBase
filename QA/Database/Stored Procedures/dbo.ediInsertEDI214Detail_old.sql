SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/3/2018
-- Description:	The stored procedure INSERTS the EDI Shipement Status Detail record for the completed Job Cargo with Status Codes
-- =============================================
CREATE PROCEDURE [dbo].[ediInsertEDI214Detail_old] 
	-- Add the parameters for the stored procedure here
	@TradingPartner varchar(20), 	
	@ShipmentID varchar (30), 
	@SerialNumber varchar (30), 
	@OSD varchar (10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO  EDI214ShipmentStatusDetail(
	esdTradingPartner,
	esdShipmentID,
	esdMasterCartonBarCode,
	esdOverageParitalDamage) 
	Values(
	@TradingPartner, 	
	@ShipmentID, 
	@SerialNumber, 
	@OSD);
END
GO
