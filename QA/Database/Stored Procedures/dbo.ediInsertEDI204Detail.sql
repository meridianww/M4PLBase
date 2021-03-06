SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/3/2018
-- Description:	The stored procedure inserts the EDI orders from the flat file into the EDI204Summary Detail table.
-- =============================================

CREATE Procedure [dbo].[ediInsertEDI204Detail]
	@HeaderID bigint,
	@TradingPartner varchar(20),
	@BOLNo varchar(30),
	@ManifestNo varchar(30),
	@CommodityType varchar(50),
	@CommodityDescription varchar(50),
	@UnitOfMeasure varchar(10),
	@Weight decimal(18,2),
	@Quantity bigint,
	@CubicFeet decimal(18,2),
	@UDF01 varchar(30),
	@UDF02 varchar(30),
	@UDF03 varchar(30),
	@UDF04 varchar(30),
	@UDF05 varchar(30),
	@UDF06 varchar(30),
	@UDF07 varchar(30),
	@UDF08 varchar(30),
	@UDF09 varchar(30),
	@UDF10 varchar(30)


As BEGIN

INSERT INTO dbo.EDI204SummaryDetail(eshHeaderID, esdTradingPartner, esdBOLNo, esdManifestNo, esdCommodityType, esdCommodityDescription, esdUnitOfMeasure, esdWeight, esdQuantity, esdCubicFeet, esdUDF01, esdUDF02, esdUDF03, esdUDF04, esdUDF05, esdUDF06, esdUDF07, esdUDF08, esdUDF09, esdUDF10 ) VALUES (@HeaderID, @TradingPartner, @BOLNo, @ManifestNo, @CommodityType, @CommodityDescription, @UnitOfMeasure, @Weight, @Quantity, @CubicFeet, @UDF01, @UDF02, @UDF03, @UDF04, @UDF05, @UDF06, @UDF07, @UDF08, @UDF09, @UDF10)

END
GO
