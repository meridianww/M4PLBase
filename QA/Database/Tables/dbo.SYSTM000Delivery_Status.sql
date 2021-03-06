SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Delivery_Status](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [bigint] NULL,
	[ItemNumber] [int] NULL,
	[DeliveryStatusCode] [nvarchar](25) NULL,
	[DeliveryStatusTitle] [nvarchar](50) NULL,
	[SeverityId] [int] NULL,
	[DeliveryStatusDescription] [varbinary](max) NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM000Delivery_Status] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000Delivery_Status] ADD  CONSTRAINT [DF_SYSTM000Delivery_Status_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000Delivery_Status]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Delivery_Status_OrganizationId_ORGAN000Master] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Delivery_Status] CHECK CONSTRAINT [FK_SYSTM000Delivery_Status_OrganizationId_ORGAN000Master]
GO
ALTER TABLE [dbo].[SYSTM000Delivery_Status]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Delivery_Status_Severity_SYSTM000Ref_Options] FOREIGN KEY([SeverityId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Delivery_Status] CHECK CONSTRAINT [FK_SYSTM000Delivery_Status_Severity_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000Delivery_Status]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Delivery_Status_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Delivery_Status] CHECK CONSTRAINT [FK_SYSTM000Delivery_Status_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Delivery status ID number Auto generated' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Delivery_Status', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery status organization Id ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Delivery_Status', @level2type=N'COLUMN',@level2name=N'OrganizationId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If the Delivery status is to be ordered in lists' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Delivery_Status', @level2type=N'COLUMN',@level2name=N'ItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery status code ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Delivery_Status', @level2type=N'COLUMN',@level2name=N'DeliveryStatusCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Status Title (Long Name)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Delivery_Status', @level2type=N'COLUMN',@level2name=N'DeliveryStatusTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Status Severity level (Different from High, low' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Delivery_Status', @level2type=N'COLUMN',@level2name=N'SeverityId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status - Active, Archive, Delete' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Delivery_Status', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date DeliveryStatus Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Delivery_Status', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Delivery_Status', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Delivery_Status', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Delivery_Status', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
