SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[COMP000Master](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CompOrgId] [bigint] NOT NULL,
	[CompTableName] [nvarchar](100) NOT NULL,
	[CompPrimaryRecordId] [bigint] NOT NULL,
	[CompCode] [nvarchar](50) NOT NULL,
	[CompTitle] [nvarchar](50) NOT NULL,
	[StatusId] [int] NOT NULL,
	[DateEntered] [datetime2](7) NOT NULL CONSTRAINT [COMP000MasterDF_DateEntered]  DEFAULT (getutcdate()),
	[EnteredBy] [nvarchar](50) NOT NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_COMP000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[COMP000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_COMP000Master_CompOrgId_ORGAN000Master] FOREIGN KEY([CompOrgId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO

ALTER TABLE [dbo].[COMP000Master] CHECK CONSTRAINT [FK_COMP000Master_CompOrgId_ORGAN000Master]
GO

ALTER TABLE [dbo].[COMP000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_COMP000Master_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[COMP000Master] CHECK CONSTRAINT [FK_COMP000Master_Status_SYSTM000Ref_Options]
GO



