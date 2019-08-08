USE [M4PL_DEV]
GO

/****** Object:  Table [dbo].[PRGRM052VendorLocationsPriceCode]    Script Date: 7/24/2019 11:52:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].PRGRM042ProgramBillableLocations(
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PblProgramID] [bigint] NULL,
	[PblVendorID] [bigint] NULL,
	[PblItemNumber] [int] NULL,
	[PblLocationCode] [nvarchar](20) NULL,
	[PblLocationCodeCustomer] [nvarchar](20) NULL,
	[PblLocationTitle] [nvarchar](50) NULL,
	[PblUserCode1] [nvarchar](20) NULL,
	[PblUserCode2] [nvarchar](20) NULL,
	[PblUserCode3] [nvarchar](20) NULL,
	[PblUserCode4] [nvarchar](20) NULL,
	[PblUserCode5] [nvarchar](20) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	PRIMARY KEY ([Id]),
    CONSTRAINT FK_BillableLocation_Program FOREIGN KEY ([PblProgramID]) REFERENCES [dbo].[PRGRM000Master] (Id),
	CONSTRAINT FK_BillableLocation_PrgVEndor FOREIGN KEY ([PblVendorID]) REFERENCES [dbo].PRGRM051VendorLocations (Id)
) 

GO

CREATE TABLE [dbo].PRGRM043ProgramCostLocations(
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PclProgramID] [bigint] NULL,
	[PclVendorID] [bigint] NULL,
	[PclItemNumber] [int] NULL,
	[PclLocationCode] [nvarchar](20) NULL,
	[PclLocationCodeVendor] [nvarchar](20) NULL,
	[PclLocationTitle] [nvarchar](50) NULL,
	[PclUserCode1] [nvarchar](20) NULL,
	[PclUserCode2] [nvarchar](20) NULL,
	[PclUserCode3] [nvarchar](20) NULL,
	[PclUserCode4] [nvarchar](20) NULL,
	[PclUserCode5] [nvarchar](20) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	PRIMARY KEY ([Id]),
    CONSTRAINT FK_Cost_Location_Program FOREIGN KEY ([PclProgramID]) REFERENCES [dbo].[PRGRM000Master] (Id),
	CONSTRAINT FK_Cost_Location_PrgVendor FOREIGN KEY ([PclVendorID]) REFERENCES [dbo].PRGRM051VendorLocations (Id)
) 


