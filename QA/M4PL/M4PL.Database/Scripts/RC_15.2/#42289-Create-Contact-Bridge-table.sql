SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CONTC010Bridge](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ConOrgId] [bigint] NOT NULL,
	[ContactMSTRID] [bigint] NOT NULL,
	[ConTableName] [nvarchar](100) NULL,
	[ConPrimaryRecordId] [bigint] NULL,
	[ConItemNumber] [int] NULL,
	[ConCode] [nvarchar](20) NULL,
	[ConTitle] [nvarchar](50) NULL,
	[ConTypeId] [int] NULL,
	[StatusId] [int] NULL,
	[ConIsDefault] [bit] NULL,
	[ConDescription] [varbinary](max) NULL,
	[ConInstruction] [varbinary](max) NULL,
	[ConTableTypeId] [int] NOT NULL,
	[ConAssignment] [nvarchar](20) NULL,
	[ConGateway] [nvarchar](20) NULL,
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

ALTER TABLE [dbo].[CONTC010Bridge]  WITH CHECK ADD  CONSTRAINT [FK_CONTC010Bridge_ConTableTypeId_SYSTM000Ref_Lookup] FOREIGN KEY([ConTableTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[CONTC010Bridge] CHECK CONSTRAINT [FK_CONTC010Bridge_ConTableTypeId_SYSTM000Ref_Lookup]
GO

ALTER TABLE [dbo].[CONTC010Bridge]  WITH CHECK ADD  CONSTRAINT [FK_CONTC010Bridge_CONTC000Master] FOREIGN KEY([ContactMSTRID])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO

ALTER TABLE [dbo].[CONTC010Bridge] CHECK CONSTRAINT [FK_CONTC010Bridge_CONTC000Master]
GO

ALTER TABLE [dbo].[CONTC010Bridge]  WITH CHECK ADD  CONSTRAINT [FK_CONTC010Bridge_ConTypeId_SYSTM000Ref_Options] FOREIGN KEY([ConTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[CONTC010Bridge] CHECK CONSTRAINT [FK_CONTC010Bridge_ConTypeId_SYSTM000Ref_Options]
GO

ALTER TABLE [dbo].[CONTC010Bridge]  WITH CHECK ADD  CONSTRAINT [FK_CONTC010Bridge_ORGAN000Master] FOREIGN KEY([ConOrgId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO

ALTER TABLE [dbo].[CONTC010Bridge] CHECK CONSTRAINT [FK_CONTC010Bridge_ORGAN000Master]
GO

ALTER TABLE [dbo].[CONTC010Bridge]  WITH CHECK ADD  CONSTRAINT [FK_CONTC010Bridge_StatusId_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[CONTC010Bridge] CHECK CONSTRAINT [FK_CONTC010Bridge_StatusId_SYSTM000Ref_Options]
GO

ALTER TABLE [dbo].[CONTC010Bridge]  WITH CHECK ADD  CONSTRAINT [FK_CONTC010Bridge_SYSTM000Ref_Table] FOREIGN KEY([ConTableName])
REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName])
GO

ALTER TABLE [dbo].[CONTC010Bridge] CHECK CONSTRAINT [FK_CONTC010Bridge_SYSTM000Ref_Table]
GO


