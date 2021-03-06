SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/3/2018
-- Description:	The stored procedure returns the Customer Reference Number from the EDI856ManifestHeader table
-- =============================================
CREATE PROCEDURE [dbo].[ediGetEdi856HeaderCustomerReferenceNo]
	-- Add the parameters for the stored procedure here
	@TradingPartner varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT emhCustomerReferenceNo, emhHeaderID, emhOrderType, emhTextData FROM EDI856ManifestHeader WHERE emhTradingPartner = @TradingPartner AND (ProFlags01 Is Null OR ProFlags01 != 'R')
END
GO
