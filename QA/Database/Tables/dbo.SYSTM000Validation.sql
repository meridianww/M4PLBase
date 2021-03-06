SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Validation](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NOT NULL,
	[ValTableName] [nvarchar](100) NULL,
	[RefTabPageId] [bigint] NOT NULL,
	[ValFieldName] [nvarchar](50) NULL,
	[ValRequired] [bit] NULL,
	[ValRequiredMessage] [nvarchar](255) NULL,
	[ValUnique] [bit] NULL,
	[ValUniqueMessage] [nvarchar](255) NULL,
	[ValRegExLogic0] [int] NULL,
	[ValRegEx1] [nvarchar](255) NULL,
	[ValRegExMessage1] [nvarchar](255) NULL,
	[ValRegExLogic1] [int] NULL,
	[ValRegEx2] [nvarchar](255) NULL,
	[ValRegExMessage2] [nvarchar](255) NULL,
	[ValRegExLogic2] [int] NULL,
	[ValRegEx3] [nvarchar](255) NULL,
	[ValRegExMessage3] [nvarchar](255) NULL,
	[ValRegExLogic3] [int] NULL,
	[ValRegEx4] [nvarchar](255) NULL,
	[ValRegExMessage4] [nvarchar](255) NULL,
	[ValRegExLogic4] [int] NULL,
	[ValRegEx5] [nvarchar](255) NULL,
	[ValRegExMessage5] [nvarchar](255) NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK__SYSTM000__3214EC07492002EF] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000Validation] ADD  CONSTRAINT [DF_SYSTM000Validation_ValRequired]  DEFAULT ((0)) FOR [ValRequired]
GO
ALTER TABLE [dbo].[SYSTM000Validation] ADD  CONSTRAINT [DF_SYSTM000Validation_ValUnique]  DEFAULT ((0)) FOR [ValUnique]
GO
ALTER TABLE [dbo].[SYSTM000Validation] ADD  CONSTRAINT [DF_SYSTM000Validation_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000Validation]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Validation_SYSTM000Ref_Table] FOREIGN KEY([ValTableName])
REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName])
GO
ALTER TABLE [dbo].[SYSTM000Validation] CHECK CONSTRAINT [FK_SYSTM000Validation_SYSTM000Ref_Table]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Validation ID number auto-generated' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language Code: EN-English, ES-Spanish, FR-French' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'LangCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Page name the validation is applied to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'RefTabPageId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Field name on Page validation is applied to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValFieldName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If data is required in field' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRequired'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message indicating field is required' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRequiredMessage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If data must be unique in field' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValUnique'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message indicating field must be unique' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValUniqueMessage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Regular Expression text or Field Name to applied logic on' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegEx1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message text if Regular Expression 1 is false' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExMessage1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Operator logic applied on first and second Expressions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExLogic1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Regular Expression text or Field Name to applied logic on' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegEx2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message text if Regular Expression 2 is false' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExMessage2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Operator logic applied on second and third Expressions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExLogic2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Regular Expression text or Field Name to applied logic on' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegEx3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message text if Regular Expression 3 is false' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExMessage3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Operator logic applied on third and fourth Expressions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExLogic3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Regular Expression text or Field Name to applied logic on' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegEx4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message text if Regular Expression 4 is false' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExMessage4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Operator logic applied on fourth and fifth Expressions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExLogic4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Regular Expression text or Field Name to applied logic on' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegEx5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message text if Regular Expression 5 is false' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ValRegExMessage5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Entered for the First Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By Whom?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed On Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed by Whom?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Validation', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
