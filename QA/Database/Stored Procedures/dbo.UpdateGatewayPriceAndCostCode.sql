SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Kamal         
-- Create date:               03/30/2020        
-- Description:               Upd a Job by program id    
-- Execution:                 EXEC [dbo].[UpdateGatewayPriceAndCostCode]    114670,10007,2,GETUTCDATE(),null,null
-- Modified on:               
-- Modified Desc:    
-- =============================================      
ALTER PROCEDURE UpdateGatewayPriceAndCostCode @jobId BIGINT = 0
	,@programId BIGINT = 0
	,@UserId BIGINT = 0
	,@dateEntered DATETIME2(7) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@jobSiteCode NVARCHAR(30) = NULL
AS
BEGIN
	DECLARE @StatusArchive INT = 0, @GatewayStatusArchive INT = 0 ,@Count INT =0 ,@JobGatewayStatus NVARCHAR(50);
		

	SET @StatusArchive = (
			SELECT TOP 1 Id
			FROM SYSTM000Ref_Options
			WHERE SysLookupCode = 'Status'
				AND SysOptionName = 'Archive'
			)
	SET @GatewayStatusArchive = (
			SELECT Id
			FROM SYSTM000Ref_Options
			WHERE SysLookupCode = 'GatewayStatus'
				AND SysOptionName = 'Archive'
			)

	UPDATE JOBDL000Master
	SET ProgramID = @programId
	WHERE Id = @jobId --AND StatusId IN (1,2)

	UPDATE JOBDL020Gateways
	SET StatusId = @GatewayStatusArchive
	WHERE JobID = @JobId

	UPDATE JOBDL061BillableSheet
	SET StatusId = @StatusArchive
	WHERE JobID = @JobId

	UPDATE JOBDL062CostSheet
	SET StatusId = @StatusArchive
	WHERE JobID = @JobId

	
	EXEC [dbo].[CopyJobCostSheetFromProgram] @jobId
		,@programId
		,@dateEntered
		,@enteredBy
		,@jobSiteCode
		,@userId

	EXEC [dbo].[CopyJobBillableSheetFromProgram] @jobId
		,@programId
		,@dateEntered
		,@enteredBy
		,@jobSiteCode
		,@userId

	EXEC [dbo].[CopyJobGatewayFromProgram] @jobId
		,@programId
		,@dateEntered
		,@enteredBy
		,@userId
		
		SET @Count = (SELECT COUNT(*) FROM JOBDL020Gateways WHERE JobID = @jobId 
		AND StatusId IN (SELECT Id FROM SYSTM000Ref_Options WHERE SysLookupCode= 'GatewayStatus' and SysOptionName = 'Active'))
		print @Count
		IF(@Count <= 0)
		BEGIN
		  UPDATE JOBDL000Master SET JobGatewayStatus = '' WHERE ID =@jobId
		END
		ELSE IF (@Count > 0)
		BEGIN
		  SELECT TOP 1 @JobGatewayStatus = GwyGatewayCode FROM JOBDL020Gateways WHERE JobID = @jobId 
		  AND StatusId IN (SELECT Id FROM SYSTM000Ref_Options WHERE SysLookupCode= 'GatewayStatus' and SysOptionName = 'Active')
		  ORDER BY ID DESC 
		  UPDATE JOBDL000Master SET JobGatewayStatus = @JobGatewayStatus WHERE Id = @jobId
		END
END