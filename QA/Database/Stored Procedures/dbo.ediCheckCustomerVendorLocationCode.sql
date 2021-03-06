SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 5/12/2018
-- Description:	The stored procedure returns the ID of the record if the Customer Vendor Location Code is found.
-- =============================================
CREATE PROCEDURE [dbo].[ediCheckCustomerVendorLocationCode]
	-- Add the parameters for the stored procedure here
	@ProgramID bigint,
	@CustomerVendorLocationCode varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT COUNT(Id) FROM PRGRM051VendorLocations WHERE PvlProgramID = @ProgramID AND PvlLocationCodeCustomer = @CustomerVendorLocationCode
END
GO
