SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               08/16/2018        
-- Description:               Upd a Program Ref Gateway Default  
-- Execution:                 EXEC [dbo].[UpdPrgRefGatewayDefault]  
-- Modified on:               04/27/2018
-- Modified Desc:             Added Scanner Field
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.) 
-- =============================================  
CREATE PROCEDURE [dbo].[UpdPrgRefGatewayDefault] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@pgdProgramId BIGINT = NULL
	,@pgdGatewaySortOrder INT = NULL
	,@pgdGatewayCode NVARCHAR(20) = NULL
	,@pgdGatewayTitle NVARCHAR(50) = NULL
	,@pgdGatewayDuration DECIMAL(18, 0) = NULL
	,@unitTypeId INT = NULL
	,@pgdGatewayDefault BIT = NULL
	,@gatewayTypeId INT = NULL
	,@scanner BIT = NULL
	,@pgdShipApptmtReasonCode NVARCHAR(20) = NULL
	,@pgdShipStatusReasonCode NVARCHAR(20) = NULL
	,@pgdOrderType NVARCHAR(20) = NULL
	,@pgdShipmentType NVARCHAR(20) = NULL
	,@pgdGatewayResponsible BIGINT = NULL
	,@pgdGatewayAnalyst BIGINT = NULL
	,@pgdGatewayDefaultComplete BIT = 0
	,@statusId INT = NULL
	,@gatewayDateRefTypeId INT = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@isFormView BIT = 0
	,@where NVARCHAR(200) = NULL
	,@InstallStatusId BIGINT = NULL
	,@PgdGatewayStatusCode NVARCHAR(20) = NULL
	,@MappingId NVARCHAR(MAX) = NULL
	,@TransitionStatusId INT = NULL
	,@PgdGatewayDefaultForJob BIT = 0
	,@PgdGatewayNavOrderOption INT = NULL
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	IF (
			@pgdProgramId IS NOT NULL
			AND @pgdProgramId > 0
			AND @MappingId IS NOT NULL
			AND @MappingId <> ''
			)
	BEGIN
		SELECT 1 NUMBER
			,PG.ID
		INTO #Temp
		FROM PRGRM010Ref_GatewayDefaults PG
		INNER JOIN fnSplitString(@MappingId, ',') FU ON FU.Item = PG.PgdGatewayCode
		WHERE PgdProgramID = @pgdProgramId

		SET @MappingId = (
				SELECT STUFF((
							SELECT ',' + CAST(ID AS VARCHAR(10)) [text()]
							FROM #Temp
							WHERE NUMBER = t.NUMBER
							FOR XML PATH('')
								,TYPE
							).value('.', 'NVARCHAR(MAX)'), 1, 1, '') List_Output
				FROM #Temp t
				GROUP BY NUMBER
				)

		DROP TABLE #Temp
	END

	--DECLARE @updatedItemNumber INT 
	--DECLARE @where NVARCHAR(MAX) =' AND GatewayTypeId ='  +  CAST(@gatewayTypeId AS VARCHAR) + ' AND PgdOrderType ='''  +  CAST(@pgdOrderType AS VARCHAR)  +''' AND PgdShipmentType ='''  +  CAST(@pgdShipmentType AS VARCHAR) +''''
	--EXEC [dbo].[ResetItemNumber] @userId, @id, @pgdProgramId, @entity, @pgdGatewaySortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
	--EXEC [dbo].[GetLineNumberForProgramGateways] @id ,@pgdProgramId, @gatewayTypeId,@pgdOrderType,@pgdShipmentType,@updatedItemNumber OUTPUT 
	UPDATE [dbo].[PRGRM010Ref_GatewayDefaults]
	SET [PgdProgramID] = CASE 
			WHEN (@isFormView = 1)
				THEN @pgdProgramId
			WHEN (
					(@isFormView = 0)
					AND (@pgdProgramId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@pgdProgramId, PgdProgramID)
			END
		,[PgdGatewaySortOrder] = @pgdGatewaySortOrder --CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PgdGatewaySortOrder) END  
		,[PgdGatewayCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @pgdGatewayCode
			WHEN (
					(@isFormView = 0)
					AND (@pgdGatewayCode = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pgdGatewayCode, PgdGatewayCode)
			END
		,[PgdGatewayTitle] = CASE 
			WHEN (@isFormView = 1)
				THEN @pgdGatewayTitle
			WHEN (
					(@isFormView = 0)
					AND (@pgdGatewayTitle = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pgdGatewayTitle, PgdGatewayTitle)
			END
		,[PgdGatewayDuration] = CASE 
			WHEN (@isFormView = 1)
				THEN @pgdGatewayDuration
			WHEN (
					(@isFormView = 0)
					AND (@pgdGatewayDuration = - 100.00)
					)
				THEN NULL
			ELSE ISNULL(@pgdGatewayDuration, PgdGatewayDuration)
			END
		,[UnitTypeId] = CASE 
			WHEN (@isFormView = 1)
				THEN @unitTypeId
			WHEN (
					(@isFormView = 0)
					AND (@unitTypeId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@unitTypeId, UnitTypeId)
			END
		,[PgdGatewayDefault] = ISNULL(@pgdGatewayDefault, PgdGatewayDefault)
		,[PgdGatewayDefaultComplete] = ISNULL(@pgdGatewayDefaultComplete, PgdGatewayDefaultComplete)
		,[GatewayTypeId] = CASE 
			WHEN (@isFormView = 1)
				THEN @gatewayTypeId
			WHEN (
					(@isFormView = 0)
					AND (@gatewayTypeId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@gatewayTypeId, GatewayTypeId)
			END
		,[GatewayDateRefTypeId] = CASE 
			WHEN (@isFormView = 1)
				THEN @gatewayDateRefTypeId
			WHEN (
					(@isFormView = 0)
					AND (@gatewayDateRefTypeId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@gatewayDateRefTypeId, GatewayDateRefTypeId)
			END
		,[Scanner] = ISNULL(@scanner, Scanner)
		,[PgdShipApptmtReasonCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @pgdShipApptmtReasonCode
			WHEN (
					(@isFormView = 0)
					AND (@pgdShipApptmtReasonCode = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pgdShipApptmtReasonCode, PgdShipApptmtReasonCode)
			END
		,[PgdShipStatusReasonCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @pgdShipStatusReasonCode
			WHEN (
					(@isFormView = 0)
					AND (@pgdShipStatusReasonCode = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pgdShipStatusReasonCode, PgdShipStatusReasonCode)
			END
		,[PgdOrderType] = CASE 
			WHEN (@isFormView = 1)
				THEN @pgdOrderType
			WHEN (
					(@isFormView = 0)
					AND (@pgdOrderType = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pgdOrderType, PgdOrderType)
			END
		,[PgdShipmentType] = CASE 
			WHEN (@isFormView = 1)
				THEN @pgdShipmentType
			WHEN (
					(@isFormView = 0)
					AND (@pgdShipmentType = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pgdShipmentType, PgdShipmentType)
			END
		,[PgdGatewayResponsible] = CASE 
			WHEN (@isFormView = 1)
				THEN @pgdGatewayResponsible
			WHEN (
					(@isFormView = 0)
					AND (@pgdGatewayResponsible = - 100)
					)
				THEN NULL
			ELSE ISNULL(@pgdGatewayResponsible, PgdGatewayResponsible)
			END
		,[PgdGatewayAnalyst] = CASE 
			WHEN (@isFormView = 1)
				THEN @pgdGatewayAnalyst
			WHEN (
					(@isFormView = 0)
					AND (@pgdGatewayAnalyst = - 100)
					)
				THEN NULL
			ELSE ISNULL(@pgdGatewayAnalyst, PgdGatewayAnalyst)
			END
		,[PgdGatewayStatusCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @PgdGatewayStatusCode
			WHEN (
					(@isFormView = 0)
					AND (@PgdGatewayStatusCode = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@PgdGatewayStatusCode, PgdGatewayStatusCode)
			END
		,[StatusId] = CASE 
			WHEN (@isFormView = 1)
				THEN @statusId
			WHEN (
					(@isFormView = 0)
					AND (@statusId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@statusId, StatusId)
			END
		,[DateChanged] = @dateChanged
		,[ChangedBy] = @changedBy
		,[InstallStatusId] = CASE 
			WHEN @InstallStatusId > 0
				THEN @InstallStatusId
			ELSE InstallStatusId
			END
		,[MappingId] = @MappingId
		,[TransitionStatusId] = @TransitionStatusId
		,[PgdGatewayDefaultForJob] = @PgdGatewayDefaultForJob
		,[PgdGatewayNavOrderOption] = @PgdGatewayNavOrderOption
	WHERE [Id] = @id

	SELECT prg.[Id]
		,prg.[PgdProgramID]
		,prg.[PgdGatewaySortOrder]
		,prg.[PgdGatewayCode]
		,prg.[PgdGatewayTitle]
		,prg.[PgdGatewayDuration]
		,prg.[UnitTypeId]
		,prg.[PgdGatewayDefault]
		,prg.[GatewayTypeId]
		,prg.[GatewayDateRefTypeId]
		,prg.[Scanner]
		,prg.[PgdShipApptmtReasonCode]
		,prg.[PgdShipStatusReasonCode]
		,prg.[PgdOrderType]
		,prg.[PgdShipmentType]
		,prg.[PgdGatewayResponsible]
		,prg.[PgdGatewayAnalyst]
		,prg.[PgdGatewayDefaultComplete]
		,prg.[StatusId]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
		,prg.[InstallStatusId]
		,prg.[MappingId]
		,prg.[TransitionStatusId]
		,prg.[PgdGatewayDefaultForJob]
		,prg.[PgdGatewayNavOrderOption]
	FROM [dbo].[PRGRM010Ref_GatewayDefaults] prg
	WHERE [Id] = @id
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH
GO
