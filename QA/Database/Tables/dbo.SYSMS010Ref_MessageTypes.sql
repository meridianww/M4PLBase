SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSMS010Ref_MessageTypes](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NOT NULL,
	[SysRefId] [int] NOT NULL,
	[SysMsgtypeTitle] [nvarchar](50) NOT NULL,
	[SysMsgTypeDescription] [varbinary](max) NULL,
	[SysMsgTypeHeaderIcon] [image] NULL,
	[SysMsgTypeIcon] [image] NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSMS010Ref_MessageTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSMS010Ref_MessageTypes] ADD  CONSTRAINT [DF_SYSMS010Ref_MessageTypes_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSMS010Ref_MessageTypes]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSMS010Ref_MessageTypes_StatusId_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSMS010Ref_MessageTypes] CHECK CONSTRAINT [FK_SYSMS010Ref_MessageTypes_StatusId_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSMS010Ref_MessageTypes]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSMS010Ref_MessageTypes_SysRefId_SYSTM000Ref_Options] FOREIGN KEY([SysRefId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSMS010Ref_MessageTypes] CHECK CONSTRAINT [FK_SYSMS010Ref_MessageTypes_SysRefId_SYSTM000Ref_Options]
GO
