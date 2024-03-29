SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/2/2018
-- Description:	The stored procedure INSERTS the EDI Shipement Status Header record for the completed Job Gateway with Status Codes
-- =============================================
CREATE PROCEDURE [dbo].[ediInsertEDI214Header]  
 -- Add the parameters for the stored procedure here  
 @TradingPartner varchar(20),   
 @CustomerOrderNumber varchar (30),   
 @ShipmentID varchar (30),   
 @SCACCode varchar (10),   
 @DomicileSiteNo varchar (30),   
 @RouteNumber varchar (30),   
 @SignedBy varchar (60),   
 @TerminalName varchar (60),   
 @TerminalAddress1 varchar (75),   
 @TerminalAddress2 varchar (75),   
 @TerminalCity varchar (75),   
 @TerminalState varchar (25),   
 @TerminalPostalCode varchar (15),   
 @TerminalCountryCode varchar (10),   
 @Status varchar (20),   
 @StatusReason varchar (20),   
 @StatusDate varchar (50),   
 @StatusTime varchar (50),   
 @LocationCity varchar (75),   
 @LocationState varchar (25),   
 @LocationCountryCode varchar (10),   
 @Latitude varchar (30),   
 @Longitude varchar (30),   
 @EquipmentNumber varchar(30),  
 @Direction varchar (30),   
 @Overage bigint,   
 @Partial bigint,   
 @Damage bigint,
 @OrderType varchar(30),
 @WeightQualifier varchar(10),
 @WeightUnitCode varchar(10),
 @Weight decimal(18,2),
 @Quantity bigint,
 @Parts bigint,
 @VolumeQualifier varchar(10),
 @Volume decimal(18,2)  
  
AS BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 INSERT INTO  EDI214ShipmentStatusHeader(   
 eshTradingPartner,   
 eshOrderNumber,   
 eshShipmentID,   
 eshSCAC,   
 eshDomicileSiteNo,   
 eshRouteNumber,   
 eshSignedBy,   
 eshTerminalName,   
 eshTerminalAddress1,   
 eshTerminalAddress2,   
 eshTerminalCity,   
 eshTerminalState,   
 eshTerminalPostalCode,   
 eshTerminalCountryCode,   
 eshStatus,   
 eshStatusReason,   
 eshStatusDate,   
 eshStatusTime,   
 eshLocationCity,   
 eshLocationState,   
 eshLocationCountryCode,   
 eshLatitude,  
 eshLongitude,   
 eshEquipmentNumber,  
 eshDirection,   
 eshOverage,   
 eshPartial,   
 eshDamage,
 eshOrderType,
 eshWeightQualifier,
 eshWeightUnitCode,
 eshWeight,
 eshQuanity,
 eshParts,
 eshVolumeQualifier,
 eshVolume) 
VALUES  
( @TradingPartner,   
 @CustomerOrderNumber,   
 @ShipmentID,   
 @SCACCode,   
 @DomicileSiteNo,   
 @RouteNumber ,   
 @SignedBy,   
 @TerminalName,   
 @TerminalAddress1,   
 @TerminalAddress2,   
 @TerminalCity,   
 @TerminalState,   
 @TerminalPostalCode,   
 @TerminalCountryCode,   
 @Status,   
 @StatusReason,   
 @StatusDate,   
 @StatusTime,   
 @LocationCity,   
 @LocationState,   
 @LocationCountryCode,   
 SubString(@Latitude,1,7),   
 SubString(@Longitude, 1, 7),   
 @EquipmentNumber,  
 @Direction,   
 @Overage,   
 @Partial,   
 @Damage,
 @OrderType,
 @WeightQualifier,
 @WeightUnitCode,
 @Weight,
 @Quantity,
 @Parts,
 @VolumeQualifier,
 @Volume);  
Select SCOPE_IDENTITY();  
END
GO
