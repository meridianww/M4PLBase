SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM010MenuOptionLevel](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NULL,
	[SysRefId] [int] NOT NULL,
	[MolOrder] [int] NULL,
	[MolMenuLevelTitle] [nvarchar](50) NULL,
	[MolMenuAccessDefault] [int] NULL,
	[MolMenuAccessOnly] [bit] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK__SYSTM010__3214EC07B000E61D] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM010MenuOptionLevel] ADD  CONSTRAINT [DF_SYSTM010MenuOptionLevel_MolMenuAccessOnly]  DEFAULT ((0)) FOR [MolMenuAccessOnly]
GO
ALTER TABLE [dbo].[SYSTM010MenuOptionLevel] ADD  CONSTRAINT [DF_SYSTM010MenuOptionLevel_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Menu Option Level IDentification (MOLID) Auto Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'LangCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Can Be 0-5, Zero (0) No Rights; (1) Dashboards, (2) Reports, (3) Screens, (4) Process, (5) Systems' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'MolOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See ABove To What Goes Into Each Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'MolMenuLevelTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'References  Access Default and Points to Access Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'MolMenuAccessDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Only Option Default No Other Choices Given' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'MolMenuAccessOnly'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Menu Option Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuOptionLevel', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
