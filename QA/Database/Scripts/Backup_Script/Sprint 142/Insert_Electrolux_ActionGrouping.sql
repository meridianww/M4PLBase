
DECLARE @CustomerID INT
SELECT @CustomerID = Id from [dbo].[CUST000Master] WHERE CustCode = 'Electrolux'

IF NOT EXISTS (SELECT 1 FROM  [dbo].[JOBDL021GatewayExceptionCode] WHERE CustomerId = @CustomerID AND [JgeReferenceCode] = 'Reschedule-39')
BEGIN

INSERT INTO [dbo].[JOBDL021GatewayExceptionCode]
           ([CustomerId]
           ,[JgeReferenceCode]
           ,[JgeReasonCode]
           ,[CreateDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@CustomerID
           ,'Reschedule-39'
           ,'EDC Delay'
           ,GETDATE()
           ,'nfujimoto'
           ,GETDATE()
           ,'nfujimoto')

END

IF NOT EXISTS (SELECT 1 FROM  [dbo].[JOBDL021GatewayExceptionCode] WHERE CustomerId = @CustomerID AND [JgeReferenceCode] = 'Reschedule-44')
BEGIN

INSERT INTO [dbo].[JOBDL021GatewayExceptionCode]
           ([CustomerId]
           ,[JgeReferenceCode]
           ,[JgeReasonCode]
           ,[CreateDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@CustomerID
           ,'Reschedule-44'
           ,'Site Not Ready'
           ,GETDATE()
           ,'nfujimoto'
           ,GETDATE()
           ,'nfujimoto')

END




DECLARE @JOBDL021GatewayExceptionCodeId INT 

SELECT @JOBDL021GatewayExceptionCodeId =  Id FROM  [dbo].[JOBDL021GatewayExceptionCode] WHERE CustomerId = @CustomerID AND [JgeReferenceCode] = 'Reschedule-39'


IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL022GatewayExceptionReason] WHERE [JGExceptionId] = @JOBDL021GatewayExceptionCodeId AND JgeTitle = 'EDC Scheduling Efficeincy')

BEGIN

INSERT INTO [dbo].[JOBDL022GatewayExceptionReason]
           ([JGExceptionId]
           ,[JgeTitle]
           ,[CreateDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@JOBDL021GatewayExceptionCodeId
           ,'EDC Scheduling Efficeincy'
           ,GETDATE()
           ,'nfujimoto'
           ,GETDATE()
           ,'nfujimoto')

END



IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL022GatewayExceptionReason] WHERE [JGExceptionId] = @JOBDL021GatewayExceptionCodeId AND JgeTitle = 'Traffic Delay')

BEGIN

INSERT INTO [dbo].[JOBDL022GatewayExceptionReason]
           ([JGExceptionId]
           ,[JgeTitle]
           ,[CreateDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@JOBDL021GatewayExceptionCodeId
           ,'Traffic Delay'
           ,GETDATE()
           ,'nfujimoto'
           ,GETDATE()
           ,'nfujimoto')

END


IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL022GatewayExceptionReason] WHERE [JGExceptionId] = @JOBDL021GatewayExceptionCodeId AND JgeTitle = 'Weather Delay')

BEGIN

INSERT INTO [dbo].[JOBDL022GatewayExceptionReason]
           ([JGExceptionId]
           ,[JgeTitle]
           ,[CreateDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@JOBDL021GatewayExceptionCodeId
           ,'Weather Delay'
           ,GETDATE()
           ,'nfujimoto'
           ,GETDATE()
           ,'nfujimoto')

END


IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL022GatewayExceptionReason] WHERE [JGExceptionId] = @JOBDL021GatewayExceptionCodeId AND JgeTitle = 'Bad Scheduling')

BEGIN

INSERT INTO [dbo].[JOBDL022GatewayExceptionReason]
           ([JGExceptionId]
           ,[JgeTitle]
           ,[CreateDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@JOBDL021GatewayExceptionCodeId
           ,'Bad Scheduling'
           ,GETDATE()
           ,'nfujimoto'
           ,GETDATE()
           ,'nfujimoto')

END


IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL022GatewayExceptionReason] WHERE [JGExceptionId] = @JOBDL021GatewayExceptionCodeId AND JgeTitle = 'Route Efficiency')

BEGIN

INSERT INTO [dbo].[JOBDL022GatewayExceptionReason]
           ([JGExceptionId]
           ,[JgeTitle]
           ,[CreateDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@JOBDL021GatewayExceptionCodeId
           ,'Route Efficiency'
           ,GETDATE()
           ,'nfujimoto'
           ,GETDATE()
           ,'nfujimoto')

END



SELECT @JOBDL021GatewayExceptionCodeId =  Id FROM  [dbo].[JOBDL021GatewayExceptionCode] WHERE CustomerId = @CustomerID AND [JgeReferenceCode] = 'Reschedule-44'




IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL022GatewayExceptionReason] WHERE [JGExceptionId] = @JOBDL021GatewayExceptionCodeId AND JgeTitle = 'No Cabinet Counter Tops')

BEGIN

INSERT INTO [dbo].[JOBDL022GatewayExceptionReason]
           ([JGExceptionId]
           ,[JgeTitle]
           ,[CreateDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@JOBDL021GatewayExceptionCodeId
           ,'No Cabinet Counter Tops'
           ,GETDATE()
           ,'nfujimoto'
           ,GETDATE()
           ,'nfujimoto')

END


IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL022GatewayExceptionReason] WHERE [JGExceptionId] = @JOBDL021GatewayExceptionCodeId AND JgeTitle = 'No Flooring')

BEGIN

INSERT INTO [dbo].[JOBDL022GatewayExceptionReason]
           ([JGExceptionId]
           ,[JgeTitle]
           ,[CreateDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@JOBDL021GatewayExceptionCodeId
           ,'No Flooring'
           ,GETDATE()
           ,'nfujimoto'
           ,GETDATE()
           ,'nfujimoto')

END




IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL022GatewayExceptionReason] WHERE [JGExceptionId] = @JOBDL021GatewayExceptionCodeId AND JgeTitle = 'No Water')

BEGIN

INSERT INTO [dbo].[JOBDL022GatewayExceptionReason]
           ([JGExceptionId]
           ,[JgeTitle]
           ,[CreateDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@JOBDL021GatewayExceptionCodeId
           ,'No Water'
           ,GETDATE()
           ,'nfujimoto'
           ,GETDATE()
           ,'nfujimoto')

END




IF NOT EXISTS (SELECT 1 FROM [dbo].[JOBDL022GatewayExceptionReason] WHERE [JGExceptionId] = @JOBDL021GatewayExceptionCodeId AND JgeTitle = 'No Electric')

BEGIN

INSERT INTO [dbo].[JOBDL022GatewayExceptionReason]
           ([JGExceptionId]
           ,[JgeTitle]
           ,[CreateDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
     VALUES
           (@JOBDL021GatewayExceptionCodeId
           ,'No Electric'
           ,GETDATE()
           ,'nfujimoto'
           ,GETDATE()
           ,'nfujimoto')

END




