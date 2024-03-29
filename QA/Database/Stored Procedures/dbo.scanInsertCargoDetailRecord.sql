SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/9/2018
-- Description:	The stored procedure inserts the Cargo record into the Scanner Cargo Detail table
-- =============================================
CREATE PROCEDURE [dbo].[scanInsertCargoDetailRecord]
	-- Add the parameters for the stored procedure here
	@CargoId bigint
	,@CgoSerialNumber nvarchar(255)     
	,@CgoQtyCounted decimal(18,2)
	,@CgoQtyDamaged decimal(18,2)
	,@CgoQtyShort decimal(18,2)
	,@CgoQtyOver decimal(18,2)        
	,@CgoLongitude nvarchar(30)
	,@CgoLatitude nvarchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	  INSERT INTO [SCN006CargoDetail]
           ([CargoID]
           ,[DetSerialNumber]
           ,[DetQtyCounted]
           ,[DetQtyDamaged]
           ,[DetQtyShort]
           ,[DetQtyOver]
           ,[DetLong]
           ,[DetLat])
     VALUES 		
           (@CargoID
           ,@CgoSerialNumber
           ,@CgoQtyCounted
           ,@CgoQtyDamaged
           ,@CgoQtyShort
           ,@CgoQtyOver
           ,@CgoLongitude
           ,@CgoLatitude)
END
GO
