SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 07/28/2010
-- Description:	Import Gateway and Actions for a Program
-- =============================================
CREATE PROCEDURE [dbo].[ImportGatewayActionForProgram] @programId BIGINT
	,@changedBy NVARCHAR(150)
	,@dateChanged DATETIME2(7)
	,@uttGateway [dbo].[uttGateway] READONLY
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CompanyId BIGINT
		,@temp VARCHAR(5000)
		,@Count INT
		,@StartCount INT = 1
		,@MappingId VARCHAR(5000)

	SELECT @CompanyId = Comp.Id
	FROM dbo.COMP000Master Comp
	INNER JOIN dbo.PRGRM000Master Program ON Program.PrgCustID = Comp.CompPrimaryRecordId
	WHERE COMP.CompTableName = 'Customer'
		AND Program.Id = @programId

	CREATE TABLE #TempGateway (
		[Id] INT IDENTITY(1, 1)
		,[TempId] BIGINT NULL
		,[Code] [nvarchar](20) NULL
		,[Type] [int] NULL
		,[OrderType] [nvarchar](20) NULL
		,[ShipmentType] [nvarchar](20) NULL
		,[NextGateway] [varchar](5000) NULL
		,[NextGatewayId] [varchar](5000) NULL
		,[InstallStatus] [nvarchar](150) NULL
		,[InstallStatusId] BIGINT NULL
		)

	INSERT INTO #TempGateway (
		[Code]
		,[Type]
		,[OrderType]
		,[ShipmentType]
		,[NextGateway]
		,[InstallStatus]
		,[InstallStatusId]
		)
	SELECT UG.Code
		,UG.[Type]
		,UG.OrderType
		,UG.ShipmentType
		,UG.NextGateway
		,UG.InstallStatus
		,JM.Id
	FROM @uttGateway UG
	LEFT JOIN dbo.JOBDL023GatewayInstallStatusMaster JM ON JM.ExStatusDescription = UG.InstallStatus
		AND JM.CompanyId = @CompanyId

	MERGE [dbo].[PRGRM010Ref_GatewayDefaults] T
	USING @uttGateway S
		ON (
				S.Code = T.PgdGatewayCode
				AND S.OrderType = T.PgdOrderType
				AND S.ShipmentType = T.PgdShipmentType
				AND S.[Type] = T.GatewayTypeId
				AND T.PgdProgramID = @programId
				)
	WHEN MATCHED
		THEN
			UPDATE
			SET T.PgdGatewayTitle = Title
				,T.UnitTypeId = S.Units
				,T.PgdGatewayDefault = S.[Default]
				,T.GatewayDateRefTypeId = S.DateReference
				,T.PgdShipStatusReasonCode = S.StatusReasonCode
				,T.PgdShipApptmtReasonCode = S.AppointmentReasonCode
				,T.StatusId = 1
				,T.PgdGatewayStatusCode = S.GatewayStatusCode
				,T.PgdGatewayDefaultComplete = S.IsDefaultComplete
				,T.TransitionStatusId = S.TransitionStatus
				,T.PgdGatewayDefaultForJob = S.IsStartGateway
				,T.ChangedBy = @changedBy
				,T.DateChanged = @dateChanged
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (
				PgdProgramID
				,PgdGatewayCode
				,PgdOrderType
				,PgdShipmentType
				,PgdGatewayTitle
				,UnitTypeId
				,PgdGatewayDefault
				,GatewayTypeId
				,GatewayDateRefTypeId
				,PgdShipStatusReasonCode
				,PgdShipApptmtReasonCode
				,StatusId
				,PgdGatewayStatusCode
				,PgdGatewayDefaultComplete
				,TransitionStatusId
				,PgdGatewayDefaultForJob
				,EnteredBy
				,DateEntered
				)
			VALUES (
				@programId
				,Code
				,OrderType
				,ShipmentType
				,Title
				,Units
				,[Default]
				,[Type]
				,DateReference
				,StatusReasonCode
				,AppointmentReasonCode
				,1
				,GatewayStatusCode
				,IsDefaultComplete
				,TransitionStatus
				,IsStartGateway
				,@changedBy
				,@dateChanged
				);
	UPDATE TEMP
	SET TEMP.TempId = PG.Id
	FROM #TempGateway TEMP
	INNER JOIN [dbo].[PRGRM010Ref_GatewayDefaults] PG ON TEMP.Code = PG.PgdGatewayCode
		AND TEMP.OrderType = PG.PgdOrderType
		AND TEMP.ShipmentType = PG.PgdShipmentType
		AND TEMP.[Type] = PG.GatewayTypeId
		AND PG.PgdProgramID = @programId

	SELECT @Count = ISNULL(Count(TempId), 0)
	FROM #TempGateway

	IF (@Count > 0)
	BEGIN
		WHILE (@Count >= @StartCount)
		BEGIN
			SET @temp = ''

			SELECT @MappingId = NextGateway
			FROM #TempGateway
			WHERE Id = @StartCount

			SELECT @temp = COALESCE(@temp + ',', '') + CAST(PG.Id AS VARCHAR(100))
			FROM [dbo].[PRGRM010Ref_GatewayDefaults] PG
			INNER JOIN dbo.fnSplitString(REPLACE(REPLACE(@MappingId, ', ', ','), ' ,', ','), ',') ST ON St.Item = Pg.PgdGatewayCode
			WHERE PG.PgdProgramId = @programId

			UPDATE #TempGateway
			SET NextGatewayId = CASE 
					WHEN LEN(@temp) > 1
						THEN REPLACE(SUBSTRING(@temp, 1, 1), ',', '') + SUBSTRING(@temp, 2, LEN(@temp) - 2) + REPLACE(SUBSTRING(@temp, LEN(@temp), 1), ',', '')
					ELSE NULL
					END
			WHERE Id = @StartCount

			SET @StartCount = @StartCount + 1
		END
	END

	UPDATE PG
	SET PG.InstallStatusId = TEMP.InstallStatusId
		,PG.MappingId = TEMP.NextGatewayId
	FROM [dbo].[PRGRM010Ref_GatewayDefaults] PG
	INNER JOIN #TempGateway TEMP ON TEMP.TempId = PG.Id

	DROP TABLE #TempGateway
END
GO

