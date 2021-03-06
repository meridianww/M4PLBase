SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/9/2018
-- Description:	The stored procedure inserts the Cargo record into the Scanner Cargo table
-- =============================================
CREATE PROCEDURE [dbo].[scanInsertCargoRecord]
	-- Add the parameters for the stored procedure here
	@CargoId bigint
    ,@JobID bigint
    ,@CgoLineItem int 
    ,@CgoPartNumCode nvarchar(30)
    ,@CgoQtyOrdered decimal(18,2)
    ,@CgoQtyExpected decimal(18,2)
    ,@CgoQtyCounted decimal(18,2)
    ,@CgoQtyDamaged decimal(18,2)
    ,@CgoQtyOnHold decimal(18,2)
    ,@CgoQtyShort decimal(18,2)
    ,@CgoQtyOver decimal(18,2)
    ,@CgoPackagingType nvarchar(30)         
    ,@CgoLongitude nvarchar(30)
    ,@CgoLatitude nvarchar(30)
	,@ProFlag11 nvarchar(1)
	,@ProFlag12 nvarchar(1)
	,@ProFlag14 nvarchar(1)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [SCN005Cargo]
           ([CargoID]
           ,[JobID]
           ,[CgoLineItem]
           ,[CgoPartNumCode]
           ,[CgoQtyOrdered]
           ,[CgoQtyExpected]
           ,[CgoQtyCounted]
           ,[CgoQtyDamaged]
           ,[CgoQtyOnHold]
           ,[CgoQtyShort]
           ,[CgoQtyOver]
           ,[CgoQtyUnits]           
           ,[CgoLong]
           ,[CgoLat]
		   ,[CgoProFlag11]
		   ,[CgoProFlag12]
		   ,[CgoProFlag14])
     VALUES
           (@CargoId
           ,@JobID
           ,@CgoLineItem
           ,@CgoPartNumCode
           ,@CgoQtyOrdered
           ,@CgoQtyExpected
           ,@CgoQtyCounted
           ,@CgoQtyDamaged
           ,@CgoQtyOnHold
           ,@CgoQtyShort
           ,@CgoQtyOver
           ,@CgoPackagingType          
           ,@CgoLongitude
           ,@CgoLatitude
		   ,@ProFlag11
		   ,@ProFlag12
		   ,@ProFlag14); Select SCOPE_IDENTITY();
END
GO
