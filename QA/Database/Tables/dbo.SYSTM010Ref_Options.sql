SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM010Ref_Options](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NOT NULL,
	[SysRefId] [int] NOT NULL,
	[LookupName] [nvarchar](100) NULL,
	[SysOptionName] [nvarchar](100) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM010Ref_Options] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM010Ref_Options] ADD  CONSTRAINT [DF_SYSTM010Ref_Options_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010Ref_Options', @level2type=N'COLUMN',@level2name=N'LangCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sys000RefOptionId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010Ref_Options', @level2type=N'COLUMN',@level2name=N'SysRefId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Text for the Option Value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010Ref_Options', @level2type=N'COLUMN',@level2name=N'SysOptionName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Referenc Option Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010Ref_Options', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
