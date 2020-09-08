/****** Object:  StoredProcedure [dbo].[Uncancelpreviouslycancelledjob]    Script Date: 9/3/2020 8:52:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Uncancelpreviouslycancelledjob] (
	@JobCustomerSalesOrder VARCHAR(30)
	,@dateEntered DATETIME2(7)
	,@enteredBy NVARCHAR(50)
	,@userId BIGINT
	)
AS
BEGIN
	DECLARE @IsRelatedAttributeUpdate BIT = 0
		,@GatewayTypeId BIGINT
		,@JobId BIGINT
		,@PrgID BIGINT
		,@IsCanceled BIT
		,@Error_Message NVARCHAR(MAX)=''
		,@IsSuccess BIT=0
		,@CurrentGatewayId BIGINT=0
		,@ArchivedGatewayStatusId BIGINT
		,@JobOriginDateTimePlanned DateTime2
		,@JobDeliveryDateTimePlanned DateTime2;

		DECLARE @TempGatewayTypes table (GatewayTypeId BIGINT,GatewayType NVARCHAR(55))
		INSERT INTO @TempGatewayTypes
		SELECT Id
		,SysOptionName
		FROM [dbo].SYSTM000Ref_Options WHERE SysLookupCode='GatewayType'
		
SELECT @ArchivedGatewayStatusId=Id 
FROM [dbo].SYSTM000Ref_Options WHERE SysLookupCode='GatewayStatus' AND SysOptionName='Archive' 

	DECLARE @JobTemp TABLE (
		jobid BIGINT
		,prgid BIGINT
		,jobgatewaystatus NVARCHAR(20)
		,iscancelled BIT
		,jobtype NVARCHAR(55)
		,shipmenttype NVARCHAR(55)
		,custid BIGINT
		,JobOriginDateTimePlanned DateTime2
		,JobDeliveryDateTimePlanned DateTime2
		)

	SELECT @GatewayTypeId = id
	FROM [dbo].[systm000ref_options]
	WHERE sysoptionname = 'Gateway'
		AND [syslookupcode] = 'GatewayType'

	INSERT INTO @JobTemp
	SELECT TOP 1 job.id
		,prg.id
		,job.jobgatewaystatus
		,job.iscancelled
		,job.jobtype
		,job.shipmenttype
		,prg.prgcustid
		,JobOriginDateTimePlanned
		,JobDeliveryDateTimePlanned
	FROM [dbo].[jobdl000master] job
	INNER JOIN prgrm000master prg ON job.programid = prg.id
	INNER JOIN dbo.cust000master Customer ON Customer.id = prg.prgcustid
	WHERE job.jobcustomersalesorder = @JobCustomerSalesOrder
		AND job.statusId <>(select Id FROM [dbo].SYSTM000Ref_Options WHERE SysLookupCode ='status' AND SysOptionName='Archive')
	ORDER BY job.id DESC


	SELECT @JobId = jobid
		,@PrgID = prgid
		,@IsCanceled=iscancelled
		,@JobOriginDateTimePlanned=JobOriginDateTimePlanned
		,@JobDeliveryDateTimePlanned=JobDeliveryDateTimePlanned
	FROM @JobTemp


	IF (
			(
				SELECT Count(*)
				FROM @JobTemp
				) = 0
			)
	BEGIN
		SELECT @Error_Message='Order number passed in the service is not available in Meridian System, please contact to Meridian support team for any further action.',@IsSuccess=0
	END
	ELSE IF(@IsCanceled=0)
	BEGIN
	SELECT @Error_Message='Order number passed in the service is not a canceled order in Meridian System, please contact to Meridian support team for any further action.',@IsSuccess=0
	END
	ELSE
	BEGIN
		UPDATE JOBDL000Master
				SET IsCancelled = 0
				,StatusId=(select Id FROM [dbo].SYSTM000Ref_Options WHERE SysLookupCode ='status' AND SysOptionName='Active')
				WHERE Id = (SELECT JobId FROM @JobTemp)


		--Archive All the Current gateways
		UPDATE Jobgwy
		SET Jobgwy.StatusId=@ArchivedGatewayStatusId
		FROM [dbo].[jobdl020gateways] Jobgwy
		INNER JOIN @TempGatewayTypes gtypes
		ON Jobgwy.GatewayTypeId=gtypes.GatewayTypeId
		AND gtypes.GatewayType='Gateway'
		WHERE  Jobgwy.JobId = @JobId

		--Archive Schedule/Reschedule Actions
				UPDATE Jobgwy
		SET Jobgwy.StatusId=@ArchivedGatewayStatusId
		FROM [dbo].[jobdl020gateways] Jobgwy
		INNER JOIN @TempGatewayTypes gtypes
		ON Jobgwy.GatewayTypeId=gtypes.GatewayTypeId
		AND gtypes.GatewayType='Action'
		WHERE  Jobgwy.JobId = @JobId
		AND (Jobgwy.gwyGatewayCOde like '%schedule%'	OR 	Jobgwy.gwyGatewayCOde like '%cancel%')

		--Archive Cancelation comments
		UPDATE Jobgwy
		SET Jobgwy.StatusId=@ArchivedGatewayStatusId
		FROM [dbo].[jobdl020gateways] Jobgwy
		INNER JOIN @TempGatewayTypes gtypes
		ON Jobgwy.GatewayTypeId=gtypes.GatewayTypeId
		AND gtypes.GatewayType='Comment'
		WHERE  Jobgwy.JobId = @JobId
		AND Jobgwy.gwyGatewayTitle like '%cancel%'		

		SET @IsRelatedAttributeUpdate = CASE 
				WHEN (
						SELECT TOP 1 GwyGatewayCode
						FROM [dbo].[jobdl020gateways]
						WHERE JobId = @JobId
						ORDER BY GwyGatewaySortOrder ASC
						) = 'In Transit'
					THEN 1
				ELSE 0
				END
			EXEC [dbo].[CopyJobGatewayFromProgram] @JobId,@PrgID,@dateEntered,@enteredBy,@userId,@IsRelatedAttributeUpdate
			SET @CurrentGatewayId=(SELECT top 1 Id FROM [dbo].[jobdl020gateways]
						WHERE JobId = @JobId
						ORDER BY GwyGatewaySortOrder DESC)
			SET @IsSuccess=1
	END

	SELECT @JobId 'JobId'
	,@PrgID 'ProgramId'
	,@CurrentGatewayId 'CurrentGatewayId'
	,@Error_Message 'ErrorMessage'
	,@IsSuccess 'IsSuccess'
	,@JobOriginDateTimePlanned 'JobOriginDateTimePlanned'
	,@JobDeliveryDateTimePlanned 'JobDeliveryDateTimePlanned'

END
GO


