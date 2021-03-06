SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORGAN002MRKT_OrgSupport](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrgID] [bigint] NULL,
	[MrkOrder] [int] NULL,
	[MrkCode] [nvarchar](20) NULL,
	[MrkTitle] [nvarchar](50) NULL,
	[MrkDescription] [varbinary](max) NULL,
	[MrkInstructions] [varbinary](max) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_ORGAN002MRKT_OrgSupport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ORGAN002MRKT_OrgSupport] ADD  CONSTRAINT [DF_ORGAN002MRKT_OrgSupport_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[ORGAN002MRKT_OrgSupport]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN002MRKT_OrgSupport_ORGAN000Master] FOREIGN KEY([OrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN002MRKT_OrgSupport] CHECK CONSTRAINT [FK_ORGAN002MRKT_OrgSupport_ORGAN000Master]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Market Record ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'OrgID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Market Line Order (Supercedes Code Sorting)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'MrkOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Market Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'MrkCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Market Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'MrkTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Market Description (If Any)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'MrkDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Market Instructions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'MrkInstructions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Market Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN002MRKT_OrgSupport', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
