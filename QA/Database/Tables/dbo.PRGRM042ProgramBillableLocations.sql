SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PRGRM042ProgramBillableLocations](
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
	[StatusId] [int] NOT NULL DEFAULT ((1)),
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PRGRM042ProgramBillableLocations]  WITH CHECK ADD  CONSTRAINT [FK_Billable_Location_Program] FOREIGN KEY([PblProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO

ALTER TABLE [dbo].[PRGRM042ProgramBillableLocations] CHECK CONSTRAINT [FK_Billable_Location_Program]
GO

ALTER TABLE [dbo].[PRGRM042ProgramBillableLocations]  WITH CHECK ADD  CONSTRAINT [FK_Billable_Location_PblVendorID] FOREIGN KEY([PblVendorID])
REFERENCES [dbo].[VEND000Master] ([Id])
GO

ALTER TABLE [dbo].[PRGRM042ProgramBillableLocations] CHECK CONSTRAINT [FK_Billable_Location_PblVendorID]
GO



