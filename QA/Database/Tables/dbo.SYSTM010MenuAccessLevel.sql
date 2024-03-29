SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM010MenuAccessLevel](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NULL,
	[SysRefId] [int] NOT NULL,
	[MalOrder] [int] NULL,
	[MalTitle] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK__SYSTM010__3214EC076C580C94] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM010MenuAccessLevel] ADD  CONSTRAINT [DF_SYSTM010MenuAccessLevel_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Menu Access Level IDentification (MALID) Auto Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'LangCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Can Be 0-5, Zero (0) No Access; (1) Read Only, (2) Edit Actuals, (3) Edit All, (4) Add/Edit, (5) Add, Edit & Delete' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'MalOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See ABove To What Goes Into Each Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'MalTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Menu Access Level Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010MenuAccessLevel', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
