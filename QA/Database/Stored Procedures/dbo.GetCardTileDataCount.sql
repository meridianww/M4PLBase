SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetCardTileDataCount]
	@CompanyId BIGINT = 0
	,@dashboardRelationalId BIGINT
	,@PermissionEnityIds uttIDList READONLY
AS
BEGIN
	DECLARE @where NVARCHAR(500) = ' AND JobCard.StatusId = 1 '
		,@CountQuery NVARCHAR(Max) = ''
		,@RecordCount INT = 0
		,@IsJobAdmin BIT = 0
		,@CurrentCustomQuery NVARCHAR(MAX) = '', @GatewayIsScheduleQuery NVARCHAR(MAX) = '', @GatewayStatus NVARCHAR(500) = ' INNER JOIN  SYSTM000Ref_Options SRO ON SRO.Id = Gateway.StatusId AND SRO.SysOptionName in (''Active'',''Completed'')';

		DECLARE @GatewayTypeId INT = 0, @GatewayActionTypeId INT = 0

	SELECT @GatewayTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Gateway'

		SELECT @GatewayActionTypeId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'GatewayType'
		AND SysOptionName = 'Action'

SELECT @CurrentCustomQuery = CustomQuery FROM DashboardCategoryRelation WHERE DashboardCategoryRelationId = @dashboardRelationalId;
IF(@dashboardRelationalId = 1 OR @dashboardRelationalId = 2 OR @dashboardRelationalId = 3)
		BEGIN
			SET @GatewayIsScheduleQuery = ' INNER JOIN LatestNotSceduleGatewayIds LSCHGWY on   LSCHGWY.LatestGatewayId = Gateway.ID '
		END
		ELSE IF(@dashboardRelationalId = 5 OR @dashboardRelationalId = 6 OR @dashboardRelationalId =7 OR @dashboardRelationalId=9 OR @dashboardRelationalId=10 OR @dashboardRelationalId=11)
		BEGIN 
			SET @GatewayIsScheduleQuery = ' INNER JOIN LatestSceduleGatewayIds LNSCHGWY on   LNSCHGWY.LatestGatewayId = Gateway.ID '
		END

	IF EXISTS (
			SELECT 1
			FROM @PermissionEnityIds
			WHERE ID = -1
			)
	BEGIN
		SET @IsJobAdmin = 1;
	END

	CREATE TABLE #EntityIdTemp (EntityId BIGINT)

	INSERT INTO #EntityIdTemp
	SELECT ID
	FROM @PermissionEnityIds

	IF (ISNULL(@CurrentCustomQuery, '') <> '')
	BEGIN
		IF (@CompanyId > 0)
		BEGIN
			SET @CountQuery = 'Select Count(DISTINCT JobCard.Id) From JOBDL000Master JobCard
					INNER JOIN JOBDL020Gateways Gateway ON JobCard.Id = Gateway.JobId ' 
					+ @GatewayIsScheduleQuery
					+ @GatewayStatus
					+ ' INNER JOIN dbo.PRGRM000Master Program ON Program.Id = JobCard.ProgramID '
			IF (@IsJobAdmin = 0)
			BEGIN
				SET @CountQuery = @CountQuery + ' INNER JOIN #EntityIdTemp SecurityEntity ON  SecurityEntity.EntityId = JobCard.Id '
			END

			SET @CountQuery = @CountQuery + ' Where  (1=1)  ' + @where + @CurrentCustomQuery + '  AND Program.PrgCustID =  ' + CONVERT(NVARCHAR, @CompanyId)
		END
		ELSE
		BEGIN
			SET @CountQuery = 'Select COUNT(DISTINCT JobCard.Id) FROM [dbo].[JOBDL000Master] (NOLOCK) JobCard INNER JOIN JOBDL020Gateways Gateway ON Gateway.JobId =  JobCard.Id '
			+ @GatewayIsScheduleQuery
			+ @GatewayStatus

			IF (@IsJobAdmin = 0)
			BEGIN
				SET @CountQuery = @CountQuery + ' INNER JOIN #EntityIdTemp SecurityEntity ON  SecurityEntity.EntityId = JobCard.Id '
			END

			SET @CountQuery = @CountQuery + ' Where (1=1)  ' + @where + @CurrentCustomQuery
		END

			PRINT(LEN(@CountQuery))
		PRINT(@CountQuery)
		EXEC sp_executesql @CountQuery
			--,N'@RecordCount int OUTPUT'
			--,@RecordCount = @RecordCount OUTPUT
	END
	ELSE
	BEGIN
		SELECT 0;
	END
END