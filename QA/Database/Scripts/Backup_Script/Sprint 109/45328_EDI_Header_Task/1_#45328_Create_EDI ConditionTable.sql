
GO

/****** Object:  Table [dbo].[PRGRM072EdiConditions]    Script Date: 9/4/2019 11:13:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PRGRM072EdiConditions](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PecParentProgramId] [bigint] NULL,
	[PecProgramId] [bigint] NULL,
	[PecJobField] [nvarchar](50) NULL,
	[PecCondition] [nvarchar](50) NULL,
	[PerLogical] [nvarchar](20) NULL,
	[PecJobField2] [nvarchar](50) NULL,
	[PecCondition2] [nvarchar](50) NULL,
	[StatusId] [int] NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_PRGRM072EdiConditions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PRGRM072EdiConditions] ADD  CONSTRAINT [DF_PRGRM072EdiConditions_StatusId]  DEFAULT ((1)) FOR [StatusId]
GO

ALTER TABLE [dbo].[PRGRM072EdiConditions]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM072EdiConditions_PRGRM_MASTER] FOREIGN KEY([PecParentProgramId])
REFERENCES [dbo].[PRGRM000Master] ([Id])
NOT FOR REPLICATION 
GO

ALTER TABLE [dbo].[PRGRM072EdiConditions] CHECK CONSTRAINT [FK_PRGRM072EdiConditions_PRGRM_MASTER]
GO


