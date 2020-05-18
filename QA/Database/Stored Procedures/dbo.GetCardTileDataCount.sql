SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCardTileDataCount] @CompanyId BIGINT = 0
	,@dashboardRelationalId BIGINT
	,@PermissionEnityIds uttIDList READONLY
	,@whereContition VARCHAR(MAX) = ''
AS
BEGIN
	DECLARE @where NVARCHAR(MAX) = ' AND JOBDL000Master.StatusId = 1 AND JOBDL000Master.JobSiteCode IS NOT NULL AND JOBDL000Master.JobSiteCode <> '''' '
		,@CountQuery NVARCHAR(Max) = ''
		,@RecordCount INT = 0
		,@IsJobAdmin BIT = 0
		,@CurrentCustomQuery NVARCHAR(4000) = ''

		IF(@CompanyId <> 0)
		  
		BEGIN
		  IF OBJECT_ID('tempdb..#ProgramTable') IS NOT NULL
		  BEGIN
		     DROP TABLE #ProgramTable
		  END
			CREATE TABLE #ProgramTable
			(
				ProgramId BIGINT
			)
			INSERT INTO #ProgramTable SELECT ID FROM PRGRM000Master WHERE PrgCustID =@CompanyId
		END

	SET @where = ' ' + ISNULL(@whereContition, '') + @where

	SELECT @CurrentCustomQuery = CustomQuery
	FROM DashboardCategoryRelation
	WHERE DashboardCategoryRelationId = @dashboardRelationalId;

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
		    SET @CountQuery = 'Select Count(DISTINCT JOBDL000Master.Id) From #ProgramTable  					
					INNER JOIN  JOBDL000Master ON #ProgramTable.ProgramId = JOBDL000Master.ProgramID 
					INNER JOIN JOBDL020Gateways ON JOBDL000Master.Id = JOBDL020Gateways.JobId
					INNER JOIN  SYSTM000Ref_Options ON SYSTM000Ref_Options.Id = JOBDL020Gateways.StatusId 
					AND SYSTM000Ref_Options.SysOptionName in (''Active'',''Completed'') '
					
			IF (@IsJobAdmin = 0)
			BEGIN
				SET @CountQuery = @CountQuery + ' INNER JOIN #EntityIdTemp  ON  #EntityIdTemp.EntityId = JOBDL000Master.Id '
			END

			IF (
					@dashboardRelationalId = 1
					OR @dashboardRelationalId = 2
					OR @dashboardRelationalId = 3
					)
			BEGIN
				SET @CountQuery = @CountQuery + ' INNER JOIN LatestNotSceduleGatewayIds on LatestNotSceduleGatewayIds.JobID = JOBDL020Gateways.JobID
				                                  AND LatestNotSceduleGatewayIds.LatestGatewayId = JOBDL020Gateways.ID '
			END
			ELSE IF (
					@dashboardRelationalId = 5
					OR @dashboardRelationalId = 6
					OR @dashboardRelationalId = 7
					OR @dashboardRelationalId = 9
					OR @dashboardRelationalId = 10
					OR @dashboardRelationalId = 11
					)
			BEGIN
				SET @CountQuery = @CountQuery + ' INNER JOIN LatestSceduleGatewayIds on LatestSceduleGatewayIds.JobID = JOBDL020Gateways.JobID 
				                                 AND LatestSceduleGatewayIds.LatestGatewayId = JOBDL020Gateways.ID '
			END

			SET @CountQuery = @CountQuery + ' Where 1 = 1 '  
			 + @where + @CurrentCustomQuery 
		END
		ELSE
		BEGIN
			SET @CountQuery = 'Select COUNT(DISTINCT JOBDL000Master.Id) FROM JOBDL000Master (NOLOCK)  
			                   INNER JOIN JOBDL020Gateways ON JOBDL020Gateways.JobId =  JOBDL000Master.Id'

			IF (@IsJobAdmin = 0)
			BEGIN
				SET @CountQuery = @CountQuery + ' INNER JOIN #EntityIdTemp ON  #EntityIdTemp.EntityId = JOBDL000Master.Id '
			END

			IF (
					@dashboardRelationalId = 1
					OR @dashboardRelationalId = 2
					OR @dashboardRelationalId = 3
					)
			BEGIN
				SET @CountQuery = @CountQuery + ' INNER JOIN LatestNotSceduleGatewayIds on LatestNotSceduleGatewayIds.JobID = JOBDL020Gateways.JobID 
				                                 AND LatestNotSceduleGatewayIds.LatestGatewayId = JOBDL020Gateways.ID '
			END
			ELSE IF (
					@dashboardRelationalId = 5
					OR @dashboardRelationalId = 6
					OR @dashboardRelationalId = 7
					OR @dashboardRelationalId = 9
					OR @dashboardRelationalId = 10
					OR @dashboardRelationalId = 11
					)
			BEGIN
				SET @CountQuery = @CountQuery + ' INNER JOIN LatestSceduleGatewayIds on  
				                                  LatestSceduleGatewayIds.JobID = JOBDL020Gateways.JobID AND LatestSceduleGatewayIds.LatestGatewayId = JOBDL020Gateways.ID '
			END
			SET @CountQuery = @CountQuery + ' INNER JOIN  SYSTM000Ref_Options ON SYSTM000Ref_Options.Id = JOBDL020Gateways.StatusId AND SYSTM000Ref_Options.SysOptionName in (''Active'',''Completed'') '
			SET @CountQuery = @CountQuery + ' WHERE 1 = 1 '
			 + @where + @CurrentCustomQuery
		END
		print @CountQuery
		EXEC sp_executesql @CountQuery
	END
	ELSE
	BEGIN
		SELECT 0;
	END
END
GO
