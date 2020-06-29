IF NOT EXISTS (Select 1 From [dbo].[JOBDL023GatewayInstallStatusMaster] Where ExStatusDescription = 'Invoiced')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster] (ExStatusDescription,ExceptionType,CompanyId)
Values ('Invoiced', 1, 10122)
END