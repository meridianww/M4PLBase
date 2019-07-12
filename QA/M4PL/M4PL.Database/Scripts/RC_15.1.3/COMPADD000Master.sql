SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[COMPADD000Master](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AddCompId] [bigint] NOT NULL,
	[AddItemNumber] [int] NULL,
	[Address1] [nvarchar](255) NULL,
	[Address2] [nvarchar](150) NULL,
	[City] [nvarchar](25) NULL,
	[StateId] [int] NULL,
	[ZipPostal] [nvarchar](20) NULL,
	[CountryId] [int] NULL,
	[AddTypeId] [int] NULL,
	[DateEntered] [datetime2](7) NOT NULL CONSTRAINT [COMPADD000MasterDF_DateEntered]  DEFAULT (getutcdate()),
	[EnteredBy] [nvarchar](50) NOT NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_COMPADD000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[COMPADD000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_COMPADD000Master_AddCompId_COMP000Master] FOREIGN KEY([AddCompId])
REFERENCES [dbo].[COMP000Master] ([Id])
GO

ALTER TABLE [dbo].[COMPADD000Master] CHECK CONSTRAINT [FK_COMPADD000Master_AddCompId_COMP000Master]
GO

ALTER TABLE [dbo].[COMPADD000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_COMPADD000Master_Type_SYSTM000Ref_Options] FOREIGN KEY([AddTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[COMPADD000Master] CHECK CONSTRAINT [FK_COMPADD000Master_Type_SYSTM000Ref_Options]
GO


