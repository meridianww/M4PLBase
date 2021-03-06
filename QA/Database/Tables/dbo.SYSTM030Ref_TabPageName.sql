SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM030Ref_TabPageName](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NULL,
	[RefTableName] [nvarchar](100) NULL,
	[TabSortOrder] [int] NULL,
	[TabTableName] [nvarchar](100) NULL,
	[TabPageTitle] [nvarchar](500) NULL,
	[TabExecuteProgram] [nvarchar](50) NULL,
	[TabPageIcon] [image] NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM030Ref_TabPageName] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM030Ref_TabPageName] ADD  CONSTRAINT [DF_SYSTM030Ref_TabPageName_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM030Ref_TabPageName]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM030Ref_TabPageName_RefTableName_SYSTM000Ref_Table] FOREIGN KEY([RefTableName])
REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName])
GO
ALTER TABLE [dbo].[SYSTM030Ref_TabPageName] CHECK CONSTRAINT [FK_SYSTM030Ref_TabPageName_RefTableName_SYSTM000Ref_Table]
GO
ALTER TABLE [dbo].[SYSTM030Ref_TabPageName]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM030Ref_TabPageName_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM030Ref_TabPageName] CHECK CONSTRAINT [FK_SYSTM030Ref_TabPageName_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM030Ref_TabPageName]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM030Ref_TabPageName_TabTableName_SYSTM000Ref_Table] FOREIGN KEY([TabTableName])
REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName])
GO
ALTER TABLE [dbo].[SYSTM030Ref_TabPageName] CHECK CONSTRAINT [FK_SYSTM030Ref_TabPageName_TabTableName_SYSTM000Ref_Table]
GO
