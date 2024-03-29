SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/3/2018
-- Description:	The stored procedure returns the EDI 856 Manifest Detail IDs matching the Customer Reference Number
-- =============================================
CREATE PROCEDURE [dbo].[ediGetEdiManifestDetailIdByCustomerReferenceNo]
	-- Add the parameters for the stored procedure here
	@CustomerReferenceNumber varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		Select emdDetailID FROM EDI856ManifestDetail 
	Inner Join EDI856ManifestHeader  On EDI856ManifestDetail.emhHeaderId = EDI856ManifestHeader.emhHeaderId 
	And EDI856ManifestHeader.emhCustomerReferenceNo = @CustomerReferenceNumber
	AND EDI856ManifestHeader.ProFlags01 Is NULL
END
GO
