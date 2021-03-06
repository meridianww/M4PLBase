SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/3/2018
-- Description:	The stored procedure returns all the EDI 204 Summary Header records for the Trading Partner
-- =============================================
CREATE PROCEDURE [dbo].[ediGetEdiSummaryHeaderByTradingPartner]
	-- Add the parameters for the stored procedure here
	@TradingPartner varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT eshHeaderID, eshCustomerReferenceNo, eshShipDate, eshArrivalDate3PL, eshScheduledPickupDate , eshScheduledDeliveryDate FROM EDI204SummaryHeader Where eshTradingPartner = @TradingPartner And (ProFlags01 Is Null OR ProFlags01 != 'R')
END
GO
