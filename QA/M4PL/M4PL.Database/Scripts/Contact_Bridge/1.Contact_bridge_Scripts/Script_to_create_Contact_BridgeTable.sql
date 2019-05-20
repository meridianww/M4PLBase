
CREATE TABLE [dbo].[CONTC010Bridge](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ConOrgId] [bigint] NOT NULL,
	[ContactMSTRID] [bigint] NOT NULL,
	[ConTableName] [nvarchar](100) NULL,
	[ConPrimaryRecordId] [bigint] NULL,
	[ConItemNumber] [int] NULL,
	[ConTitle] [nvarchar](50) NULL,
	[ConCodeId] [bigint] NULL,
	[ConTypeId] [int] NULL,
	[StatusId] [int] NULL,
	[ConIsDefault] [bit] NULL,
	[ConDescription] [varbinary](max) NULL,
	[ConInstruction] [varbinary](max) NULL,
	[ConTableTypeId] [int]  NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_CONTC010Bridge] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CONTC010Bridge]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC010Bridge_ConTableTypeId_SYSTM000Ref_Lookup] FOREIGN KEY([ConTableTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[CONTC010Bridge] CHECK CONSTRAINT [FK_CONTC010Bridge_ConTableTypeId_SYSTM000Ref_Lookup]
GO

ALTER TABLE [dbo].[CONTC010Bridge]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC010Bridge_CONTC000Master] FOREIGN KEY([ContactMSTRID])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO

ALTER TABLE [dbo].[CONTC010Bridge] CHECK CONSTRAINT [FK_CONTC010Bridge_CONTC000Master]
GO

ALTER TABLE [dbo].[CONTC010Bridge]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC010Bridge_ConTypeId_SYSTM000Ref_Options] FOREIGN KEY([ConTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[CONTC010Bridge] CHECK CONSTRAINT [FK_CONTC010Bridge_ConTypeId_SYSTM000Ref_Options]
GO

ALTER TABLE [dbo].[CONTC010Bridge]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC010Bridge_ORGAN000Master] FOREIGN KEY([ConOrgId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO

ALTER TABLE [dbo].[CONTC010Bridge] CHECK CONSTRAINT [FK_CONTC010Bridge_ORGAN000Master]
GO

ALTER TABLE [dbo].[CONTC010Bridge]  WITH CHECK ADD  CONSTRAINT [FK_CONTC010Bridge_ORGAN010Ref_Roles] FOREIGN KEY([ConCodeId])
REFERENCES [dbo].[ORGAN010Ref_Roles] ([Id])
GO

ALTER TABLE [dbo].[CONTC010Bridge] CHECK CONSTRAINT [FK_CONTC010Bridge_ORGAN010Ref_Roles]
GO

ALTER TABLE [dbo].[CONTC010Bridge]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC010Bridge_StatusId_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[CONTC010Bridge] CHECK CONSTRAINT [FK_CONTC010Bridge_StatusId_SYSTM000Ref_Options]
GO

ALTER TABLE [dbo].[CONTC010Bridge]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC010Bridge_SYSTM000Ref_Table] FOREIGN KEY([ConTableName])
REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName])
GO

ALTER TABLE [dbo].[CONTC010Bridge] CHECK CONSTRAINT [FK_CONTC010Bridge_SYSTM000Ref_Table]
GO
