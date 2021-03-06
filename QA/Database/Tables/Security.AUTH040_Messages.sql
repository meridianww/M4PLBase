SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Security].[AUTH040_Messages](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LangId] [int] NOT NULL,
	[MessageCode] [nvarchar](25) NULL,
	[MsgType] [nvarchar](50) NULL,
	[MessageScreenTitle] [nvarchar](50) NULL,
	[MessageTitle] [nvarchar](50) NULL,
	[MessageDescription] [nvarchar](max) NULL,
	[MessageInstruction] [nvarchar](max) NULL,
	[MessageButtonSelection] [int] NULL,
 CONSTRAINT [PK_AUTH040_Messages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Security].[AUTH040_Messages] ADD  DEFAULT ((1)) FOR [LangId]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System Message Record Identification' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Language: EN, ES, FR' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'LangId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Message Code for Organizing' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MessageCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System ref option id' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MsgType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Screen Title for Window of Message' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MessageScreenTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title Internal to Message Window' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MessageTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Written Description of Error and can be apended with Systemic Issues' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MessageDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'What to do to Correct Issue' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MessageInstruction'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Button Selection' , @level0type=N'SCHEMA',@level0name=N'Security', @level1type=N'TABLE',@level1name=N'AUTH040_Messages', @level2type=N'COLUMN',@level2name=N'MessageButtonSelection'
GO
