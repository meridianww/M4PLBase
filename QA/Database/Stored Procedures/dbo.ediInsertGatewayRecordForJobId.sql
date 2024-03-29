SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 5/12/2018
-- Description:	The stored procedure inserts a new record into the Job Gateway Table for the specified Job ID
-- =============================================
CREATE PROCEDURE [dbo].[ediInsertGatewayRecordForJobId]
	@JobId bigint,
	@ProgramId bigint,
	@ItemNumber int,
	@GatewayCode nvarchar(20) ,
	@GatewayTitle nvarchar(50),
	@GatewayDescription varbinary(max),
	@GatewayDuration decimal(18,2),
	@GatewayTypeId int,
	@GatewayAnalyst bigint,
	@GatewayResponsible bigint,
	@GatewayPCD datetime2(7),
	@GatewayECD datetime2(7),
	@GatewayUnitId int,
	--@GatewayAttachments int,
	@GatewayComment varbinary(max),
	@DateRefTypeId int,
	@StatusId int,
	@ShipStatusCode nvarchar(20),
	@ShipAppointmentCode nvarchar(20),
	@OrderType nvarchar(20),
	@ShipmentType nvarchar(20),
	@Scanner bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[JOBDL020Gateways]
           ([JobID]
           ,[ProgramID]
           ,[GwyGatewaySortOrder]
           ,[GwyGatewayCode]
           ,[GwyGatewayTitle]
           ,[GwyGatewayDescription]
           ,[GwyGatewayDuration]
           ,[GwyGatewayDefault]
           ,[GatewayTypeId]
           ,[GwyGatewayAnalyst]
           ,[GwyGatewayResponsible]
           ,[GwyGatewayPCD]
           ,[GwyGatewayECD]
           ,[GwyCompleted]
           ,[GatewayUnitId]
           --,[GwyAttachments]
           ,[GwyComment]
           ,[GwyDateRefTypeId]
           ,[StatusId]
		   ,[GwyShipStatusReasonCode]
		   ,[GwyShipApptmtReasonCode]
		   ,[GwyOrderType]
		   ,[GwyShipmentType]
		   ,[Scanner])
     VALUES
           (@JobId
           ,@ProgramId
           ,@ItemNumber
           ,@GatewayCode
           ,@GatewayTitle
           ,@GatewayDescription
           ,@GatewayDuration
           ,1
           ,@GatewayTypeId
           ,@GatewayAnalyst
           ,@GatewayResponsible
           ,@GatewayPCD
           ,@GatewayECD
           ,0
           ,@GatewayUnitId
           --,@GatewayAttachments
           ,@GatewayComment
           ,@DateRefTypeId
           ,@StatusId
		   ,@ShipStatusCode
		   ,@ShipAppointmentCode
			,@OrderType
			,@ShipmentType
			,@Scanner)
END
GO
