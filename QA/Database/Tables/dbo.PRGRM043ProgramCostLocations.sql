SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PRGRM043ProgramCostLocations](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PclProgramID] [bigint] NULL,
	[PclVendorID] [bigint] NULL,
	[PclItemNumber] [int] NULL,
	[PclLocationCode] [nvarchar](20) NULL,
	[PclLocationCodeCustomer] [nvarchar](20) NULL,
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
	[StatusId] [int] NOT NULL DEFAULT ((1)),
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PRGRM043ProgramCostLocations]  WITH CHECK ADD  CONSTRAINT [FK_Cost_Location_Program] FOREIGN KEY([PclProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO

ALTER TABLE [dbo].[PRGRM043ProgramCostLocations] CHECK CONSTRAINT [FK_Cost_Location_Program]
GO

ALTER TABLE [dbo].[PRGRM043ProgramCostLocations]  WITH CHECK ADD  CONSTRAINT [FK_Cost_Location_PclVendorID] FOREIGN KEY([PclVendorID])
REFERENCES [dbo].[VEND000Master] ([Id])
GO

ALTER TABLE [dbo].[PRGRM043ProgramCostLocations] CHECK CONSTRAINT [FK_Cost_Location_PclVendorID]
GO


