SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONTC000Master](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ConERPId] [nvarchar](50) NULL,
	[ConOrgId] [bigint] NULL,
	[ConCompanyName] [nvarchar](100) NULL,
	[ConTitleId] [int] NULL,
	[ConLastName] [nvarchar](25) NULL,
	[ConFirstName] [nvarchar](25) NULL,
	[ConMiddleName] [nvarchar](25) NULL,
	[ConEmailAddress] [nvarchar](100) NULL,
	[ConEmailAddress2] [nvarchar](100) NULL,
	[ConImage] [image] NULL,
	[ConJobTitle] [nvarchar](50) NULL,
	[ConBusinessPhone] [nvarchar](25) NULL,
	[ConBusinessPhoneExt] [nvarchar](15) NULL,
	[ConHomePhone] [nvarchar](25) NULL,
	[ConMobilePhone] [nvarchar](25) NULL,
	[ConFaxNumber] [nvarchar](25) NULL,
	[ConBusinessAddress1] [nvarchar](255) NULL,
	[ConBusinessAddress2] [varchar](150) NULL,
	[ConBusinessCity] [nvarchar](25) NULL,
	[ConBusinessStateId] [int] NULL,
	[ConBusinessZipPostal] [nvarchar](20) NULL,
	[ConBusinessCountryId] [int] NULL,
	[ConHomeAddress1] [nvarchar](150) NULL,
	[ConHomeAddress2] [nvarchar](150) NULL,
	[ConHomeCity] [nvarchar](25) NULL,
	[ConHomeStateId] [int] NULL,
	[ConHomeZipPostal] [nvarchar](20) NULL,
	[ConHomeCountryId] [int] NULL,
	[ConAttachments] [int] NULL,
	[ConWebPage] [ntext] NULL,
	[ConNotes] [ntext] NULL,
	[StatusId] [int] NULL,
	[ConTypeId] [int] NULL,
	[ConFullName]  AS ((isnull([ConFirstName],'')+' ')+isnull([ConLastName],'')),
	[ConFileAs]  AS (([ConLastName]+', ')+[ConFirstName]),
	[ConOutlookId] [nvarchar](50) NULL,
	[ConUDF01] [int] NULL,
	[ConUDF02] [nvarchar](20) NULL,
	[ConUDF03] [nvarchar](20) NULL,
	[ConUDF04] [nvarchar](20) NULL,
	[ConUDF05] [nvarchar](20) NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ConCompanyId] [bigint] NULL,
 CONSTRAINT [PK_CONTC000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CONTC000Master] ADD  CONSTRAINT [DF_CONTC000Master_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[CONTC000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC000Master_Business_State_SYSTM000Ref_States] FOREIGN KEY([ConBusinessStateId])
REFERENCES [dbo].[SYSTM000Ref_States] ([Id])
GO
ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_Business_State_SYSTM000Ref_States]
GO
ALTER TABLE [dbo].[CONTC000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC000Master_ConCompanyId] FOREIGN KEY([ConCompanyId])
REFERENCES [dbo].[COMP000Master] ([Id])
GO
ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_ConCompanyId]
GO
ALTER TABLE [dbo].[CONTC000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC000Master_ConOrgId_ORGAN000Master] FOREIGN KEY([ConOrgId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_ConOrgId_ORGAN000Master]
GO
ALTER TABLE [dbo].[CONTC000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC000Master_ConUDF01_SYSTM000Ref_Options] FOREIGN KEY([ConUDF01])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_ConUDF01_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[CONTC000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC000Master_Country_SYSTM000Ref_Options] FOREIGN KEY([ConBusinessCountryId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_Country_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[CONTC000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC000Master_Home_Country_SYSTM000Ref_Options] FOREIGN KEY([ConHomeCountryId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_Home_Country_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[CONTC000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC000Master_Home_State_SYSTM000Ref_States] FOREIGN KEY([ConHomeStateId])
REFERENCES [dbo].[SYSTM000Ref_States] ([Id])
GO
ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_Home_State_SYSTM000Ref_States]
GO
ALTER TABLE [dbo].[CONTC000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC000Master_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[CONTC000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC000Master_Title_CONTC000Master] FOREIGN KEY([ConTitleId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_Title_CONTC000Master]
GO
ALTER TABLE [dbo].[CONTC000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC000Master_Type_SYSTM000Ref_Options] FOREIGN KEY([ConTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_Type_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact Id that can be associated to Organization, Program, Job, and all job related tables where assigned.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ERP like Dynamics NAV Reference (CHAR Type)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConERPId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConLastName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'First Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConFirstName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Middle Name or Initial' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConMiddleName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email Address 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConEmailAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email Address #2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConEmailAddress2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Job Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConJobTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Business Phone' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessPhone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Extension' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessPhoneExt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Home Phone' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConHomePhone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mobile Phone' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConMobilePhone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fax Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConFaxNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Business Address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessAddress1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessStateId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Postal Code (Canadian and Mexican as well)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessZipPostal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Country' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConBusinessCountryId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Counts the number of attachments from the attachments list' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConAttachments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Web Page Address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConWebPage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact Notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active, Delete, Archive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'May need a reference table Type=Customer, Vendor, CSR, Driver, and other (Temporary or Permanent)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Outlook Id to Update' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ConOutlookId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By User Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Changed By User Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CONTC000Master', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
