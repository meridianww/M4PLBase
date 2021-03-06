SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/14/2018        
-- Description:               Ins a  Program Ref Gateway Default  
-- Execution:                 EXEC [dbo].[InsPrgRefGatewayDefault]  
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)    
-- Modified Desc:    
-- =============================================     
CREATE PROCEDURE [dbo].[InsPrgRefGatewayDefault] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@pgdProgramId BIGINT
	,@pgdGatewaySortOrder INT
	,@pgdGatewayCode NVARCHAR(20)
	,@pgdGatewayTitle NVARCHAR(50)
	,@pgdGatewayDuration DECIMAL(18, 0)
	,@unitTypeId INT
	,@pgdGatewayDefault BIT
	,@gatewayTypeId INT
	,@gatewayDateRefTypeId INT
	,@scanner BIT
	,@pgdShipApptmtReasonCode NVARCHAR(20)
	,@pgdShipStatusReasonCode NVARCHAR(20)
	,@pgdOrderType NVARCHAR(20)
	,@pgdShipmentType NVARCHAR(20)
	,@pgdGatewayResponsible BIGINT
	,@pgdGatewayAnalyst BIGINT
	,@pgdGatewayDefaultComplete BIT = 0
	,@statusId INT
	,@dateEntered DATETIME2(7)
	,@enteredBy NVARCHAR(50)
	,@where NVARCHAR(200) = NULL
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
	--EXEC [dbo].[ResetItemNumber] @userId, 0, @pgdProgramId, @entity, @pgdGatewaySortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
	--EXEC [dbo].[GetLineNumberForProgramGateways] NULL,@pgdProgramId, @gatewayTypeId,@pgdOrderType,@pgdShipmentType,@updatedItemNumber OUTPUT 
	DECLARE @currentId BIGINT;

	INSERT INTO [dbo].[PRGRM010Ref_GatewayDefaults] (
		[PgdProgramID]
		,[PgdGatewaySortOrder]
		,[PgdGatewayCode]
		,[PgdGatewayTitle]
		,[PgdGatewayDuration]
		,[UnitTypeId]
		,[PgdGatewayDefault]
		,[GatewayTypeId]
		,[GatewayDateRefTypeId]
		,[Scanner]
		,[PgdShipApptmtReasonCode]
		,[PgdShipStatusReasonCode]
		,[PgdOrderType]
		,[PgdShipmentType]
		,[PgdGatewayResponsible]
		,[PgdGatewayDefaultComplete]
		,[PgdGatewayAnalyst]
		,[PgdGatewayStatusCode]
		,[StatusId]
		,[DateEntered]
		,[EnteredBy]
		,[MappingId]
		,[TransitionStatusId]
		,[PgdGatewayDefaultForJob]
		,[PgdGatewayNavOrderOption]
		)
	VALUES (
		@pgdProgramID
		,@pgdGatewaySortOrder
		,@pgdGatewayCode
		,@pgdGatewayTitle
		,@pgdGatewayDuration
		,@unitTypeId
		,@pgdGatewayDefault
		,@gatewayTypeId
		,@gatewayDateRefTypeId
		,@scanner
		,@pgdShipApptmtReasonCode
		,@pgdShipStatusReasonCode
		,@pgdOrderType
		,@pgdShipmentType
		,@pgdGatewayResponsible
		,@pgdGatewayDefaultComplete
		,@pgdGatewayAnalyst
		,@PgdGatewayStatusCode
		,@statusId
		,@dateEntered
		,@enteredBy
		,@MappingId
		,@TransitionStatusId
		,@PgdGatewayDefaultForJob
		,@PgdGatewayNavOrderOption
		)

	SET @currentId = SCOPE_IDENTITY();

	SELECT *
	FROM [dbo].[PRGRM010Ref_GatewayDefaults]
	WHERE Id = @currentId;
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
