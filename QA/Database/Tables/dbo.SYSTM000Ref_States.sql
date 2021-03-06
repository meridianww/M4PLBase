SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Ref_States](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StateCountryId] [int] NOT NULL,
	[StateAbbr] [nvarchar](10) NOT NULL,
	[StateName] [nvarchar](100) NOT NULL,
	[StateIsDefault] [bit] NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM000Ref_States] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000Ref_States] ADD  CONSTRAINT [DF_SYSTM000Ref_States_StateIsDefault]  DEFAULT ((0)) FOR [StateIsDefault]
GO
ALTER TABLE [dbo].[SYSTM000Ref_States] ADD  CONSTRAINT [DF__SYSTM000R__DateE__129488B5]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000Ref_States]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Ref_States_Country_SYSTM000Ref_Options] FOREIGN KEY([StateCountryId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Ref_States] CHECK CONSTRAINT [FK_SYSTM000Ref_States_Country_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000Ref_States]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Ref_States_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Ref_States] CHECK CONSTRAINT [FK_SYSTM000Ref_States_Status_SYSTM000Ref_Options]
GO
