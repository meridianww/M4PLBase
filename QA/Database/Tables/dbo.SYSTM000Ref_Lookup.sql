SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Ref_Lookup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LkupCode] [nvarchar](100) NOT NULL,
	[LkupTableName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_SYSTM000Ref_Lookup_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Lookup]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Ref_Lookup_SYSTM000Ref_Table] FOREIGN KEY([LkupTableName])
REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName])
GO
ALTER TABLE [dbo].[SYSTM000Ref_Lookup] CHECK CONSTRAINT [FK_SYSTM000Ref_Lookup_SYSTM000Ref_Table]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Look name like Main Module ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Lookup', @level2type=N'COLUMN',@level2name=N'LkupCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entity name used in application for development' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Lookup', @level2type=N'COLUMN',@level2name=N'LkupTableName'
GO
