SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Ref_Table](
	[SysRefName] [nvarchar](100) NOT NULL,
	[LangCode] [nvarchar](10) NULL,
	[TblLangName] [nvarchar](100) NULL,
	[TblTableName] [nvarchar](100) NOT NULL,
	[TblMainModuleId] [int] NULL,
	[TblIcon] [image] NULL,
	[TblTypeId] [int] NULL,
	[TblPrimaryKeyName] [nvarchar](100) NULL,
	[TblParentIdFieldName] [nvarchar](100) NULL,
	[TblItemNumberFieldName] [nvarchar](100) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM000Ref_Table] PRIMARY KEY CLUSTERED 
(
	[SysRefName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Table] ADD  CONSTRAINT [DF_SYSTM000Ref_Table_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Table]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Ref_Table_SYSTM000Ref_Options] FOREIGN KEY([TblTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Ref_Table] CHECK CONSTRAINT [FK_SYSTM000Ref_Table_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entity name used in application for development' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Table', @level2type=N'COLUMN',@level2name=N'SysRefName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Database objects name with schema like table Name [dbo].[SYSTM000MenuDriver]' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Table', @level2type=N'COLUMN',@level2name=N'TblTableName'
GO
