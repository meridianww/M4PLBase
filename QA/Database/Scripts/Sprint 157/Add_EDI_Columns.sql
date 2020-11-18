ALTER TABLE [dbo].[EDI204SummaryHeader] Add eshConsigneeContactEmail  varchar(80)
ALTER TABLE [dbo].[EDI204SummaryHeader] Add eshConsigneeAltContEmail  varchar(80)
ALTER TABLE [dbo].[EDI204SummaryHeader] Add eshInterConsigneeContactEmail varchar(80)
ALTER TABLE [dbo].[EDI204SummaryHeader] Add eshInterConsigneeAltContEmail varchar(80)
ALTER TABLE [dbo].[EDI204SummaryHeader] Add eshShipFromContactEmail varchar(80)
ALTER TABLE [dbo].[EDI204SummaryHeader] Add eshShipFromAltContEmail varchar(80)
ALTER TABLE [dbo].[EDI204SummaryHeader] Add eshBillToContactEmail varchar(80)
ALTER TABLE [dbo].[EDI204SummaryHeader] Add eshBillToAltContEmail varchar(80)



ALTER TABLE dbo.EDI856ManifestHeader Add emhConsigneeContactEmail varchar(80)
ALTER TABLE dbo.EDI856ManifestHeader Add emhConsigneeAltContEmail varchar(80)
ALTER TABLE dbo.EDI856ManifestHeader Add emhInterConsigneeContactEmail varchar(80)
ALTER TABLE dbo.EDI856ManifestHeader Add emhInterConsigneeAltContEmail varchar(80)
ALTER TABLE dbo.EDI856ManifestHeader Add emhShipFromContactEmail varchar(80)
ALTER TABLE dbo.EDI856ManifestHeader Add emhShipFromAltContEmail varchar(80)
ALTER TABLE dbo.EDI856ManifestHeader Add emhBillToContactEmail varchar(80)
ALTER TABLE dbo.EDI856ManifestHeader Add emhBillToAltContEmail varchar(80)
