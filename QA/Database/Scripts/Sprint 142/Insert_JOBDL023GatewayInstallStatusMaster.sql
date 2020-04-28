IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Canceled' AND [ExceptionType] = 'exception 1')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Canceled'
           ,'exception 1')

END

IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Complete' AND [ExceptionType] = 'exception 1')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Complete'
           ,'exception 1')

END

IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Dispatched' AND [ExceptionType] = 'exception 1')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Dispatched'
           ,'exception 1')

END

IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'New order' AND [ExceptionType] = 'exception 1')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('New order'
           ,'exception 1')

END

IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Out for delivery' AND [ExceptionType] = 'exception 1')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Out for delivery'
           ,'exception 1')

END

IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Pending receipt' AND [ExceptionType] = 'exception 1')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Pending receipt'
           ,'exception 1')

END

IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Picked Up' AND [ExceptionType] = 'exception 1')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Picked Up'
           ,'exception 1')

END

IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Received' AND [ExceptionType] = 'exception 1')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Received'
           ,'exception 1')

END


IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Scheduled' AND [ExceptionType] = 'exception 1')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Scheduled'
           ,'exception 1')

END


IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Attempted' AND [ExceptionType] = 'exception 0')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Attempted'
           ,'exception 0')

END


IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Damaged' AND [ExceptionType] = 'exception 0')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Damaged'
           ,'exception 0')

END


IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Hold' AND [ExceptionType] = 'exception 0')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Hold'
           ,'exception 0')

END

IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Notused' AND [ExceptionType] = 'exception 0')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Notused'
           ,'exception 0')

END

IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Refused' AND [ExceptionType] = 'exception 0')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Refused'
           ,'exception 0')

END

IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Refused' AND [ExceptionType] = 'exception 0')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Return'
           ,'exception 0')

END

IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL023GatewayInstallStatusMaster] WHERE [ExStatusDescription] = 'Refused' AND [ExceptionType] = 'exception 0')
BEGIN
INSERT INTO [dbo].[JOBDL023GatewayInstallStatusMaster]
           ([ExStatusDescription]
           ,[ExceptionType])
     VALUES
           ('Received Short'
           ,'exception 0')

END