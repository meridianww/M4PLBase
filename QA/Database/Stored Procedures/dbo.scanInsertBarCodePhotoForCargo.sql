SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/9/2018
-- Description:	The stored procedure Inserts the Cargo Barcode Photos
-- =============================================
CREATE PROCEDURE [dbo].[scanInsertBarCodePhotoForCargo]
	-- Add the parameters for the stored procedure here
	@TableName nvarchar, 
	@StatusId int,
	@FileExtension nvarchar
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO SYSTM020Ref_Attachments
	(AttTableName,
	AttPrimaryRecordID,
	AttFileName,
	AttData,
	StatusId)
	SELECT @TableName,cargoPhoto.CargoID, cargoPhoto.Step +'-'+ gateways.GwyGatewayCode + @FileExtension, cargoPhoto.Photo, @StatusId FROM SCN007CargoBCPhoto cargoPhoto 
		INNER JOIN SCN005Cargo cargo ON cargoPhoto.CargoID = cargo.CargoID AND cargo.CgoProFlag12 = 'U' AND CONVERT(int,cargo.CgoProFlag11) = CONVERT(int,cargoPhoto.Step)
		LEFT JOIN JOBDL020Gateways gateways ON gateways.JobID = cargo.JobID AND CONVERT(int,gateways.GwyGatewaySortOrder) = CONVERT(int,cargoPhoto.Step)
END
GO
