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
		,@dashboardCategory NVARCHAR(20) = ''
		,@dashboardSubCategory NVARCHAR(20) = ''
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

	--CREATE TABLE #EntityIdTemp (EntityId BIGINT)

	--INSERT INTO #EntityIdTemp
	--SELECT ID
	--FROM @PermissionEnityIds

	IF (ISNULL(@CurrentCustomQuery, '') <> '' AND ISNULL(@dashboardRelationalId, 0) > 0)
	BEGIN
		SELECT @dashboardCategory = DashboardCategory.DashboardCategoryName FROM DashboardCategory 
		JOIN DashboardCategoryRelation ON DashboardCategory.DashboardCategoryId = DashboardCategoryRelation.DashboardCategoryId
		WHERE DashboardCategoryRelation.DashboardCategoryRelationId = @dashboardRelationalId
		
		SELECT @dashboardSubCategory = DashboardSubCategory.DashboardSubCategoryName FROM DashboardSubCategory 
		JOIN DashboardCategoryRelation ON DashboardSubCategory.DashboardSubCategoryId = DashboardCategoryRelation.DashboardSubCategory
		WHERE DashboardCategoryRelation.DashboardCategoryRelationId = @dashboardRelationalId
		
		IF(@dashboardCategory <> '' AND @dashboardSubCategory <> '')
		BEGIN
			IF (@CompanyId > 0)
				BEGIN
					SET @CountQuery = 'Select Count(DISTINCT JOBDL000Master.Id) From #ProgramTable  					
							INNER JOIN  dbo.vwJobMasterData (NOEXPAND) JOBDL000Master ON #ProgramTable.ProgramId = JOBDL000Master.ProgramID '					
					
				END
				ELSE
				BEGIN
					SET @CountQuery = 'Select COUNT(DISTINCT JOBDL000Master.Id) FROM dbo.vwJobMasterData (NOEXPAND) JOBDL000Master '
				END
			
			    IF (@IsJobAdmin = 0)
					BEGIN
						SET @CountQuery = @CountQuery + ' INNER JOIN @PermissionEnityIds PE  ON  PE.Id = JOBDL000Master.Id '
					END

					IF (@dashboardCategory = 'NotScheduled' AND (@dashboardSubCategory = 'InTransit' OR @dashboardSubCategory = 'OnHand' OR @dashboardSubCategory = 'LoadOnTruck'))
					BEGIN 
						 SET @CountQuery = @CountQuery + ' Where 1 = 1 AND (JOBDL000Master.JobIsSchedule = 0 OR JOBDL000Master.JobIsSchedule IS NULL) '
					END
					ELSE IF ((@dashboardCategory = 'SchedulePastDue' OR @dashboardCategory = 'ScheduledForToday')
					AND (@dashboardSubCategory = 'InTransit' OR @dashboardSubCategory = 'OnHand' OR @dashboardSubCategory = 'LoadOnTruck'))
					BEGIN
						SET @CountQuery = @CountQuery + ' Where 1 = 1 AND JOBDL000Master.JobIsSchedule = 1 '
					END					
					ELSE IF (@dashboardCategory = 'Other' AND @dashboardSubCategory = 'NoPODUpload')
					BEGIN
						SET @CountQuery = @CountQuery + ' Where 1 = 1 '
					END
					ELSE IF ((@dashboardCategory = 'NotScheduled' OR @dashboardCategory = 'SchedulePastDue' OR @dashboardCategory = 'ScheduledForToday') AND @dashboardSubCategory = 'Returns')
					BEGIN
					  SET @CountQuery = @CountQuery + ' Where 1 = 1 '
					END
					ELSE IF( @dashboardCategory = 'xCBL')
					BEGIN
					  SET @CountQuery = @CountQuery + 'INNER JOIN JOBDL020Gateways ON JOBDL000Master.Id = JOBDL020Gateways.JobId 
													   AND ISNULL(JOBDL020Gateways.ProgramId,0) = JOBDL000Master.ProgramId
													   AND JOBDL000Master.StatusId=1 AND JOBDL020Gateways.GatewayTypeId = 86
													   AND JOBDL020Gateways.GwyGatewayCode like ''XCBL%''
													   INNER JOIN  SYSTM000Ref_Options ON SYSTM000Ref_Options.Id = JOBDL020Gateways.StatusId 
													   AND SYSTM000Ref_Options.SysOptionName in (''Active'',''Completed'')'
					  SET @CountQuery = @CountQuery + ' Where 1 = 1 '
					END

					--ELSE IF (@dashboardCategory = 'xCBL' AND @dashboardSubCategory = 'AddressChange')
					--BEGIN
					--	SET @CurrentCustomQuery = @CurrentCustomQuery + ' JOBDL020Gateways.GwyGatewayCode =''XCBL-Address Change'' AND JOBDL020Gateways.GwyCompleted = 0 AND JOBDL000Master.IsCancelled = 0 '
					--END
					 
			SET @CountQuery = @CountQuery + @where + @CurrentCustomQuery 
				EXEC sp_executesql @CountQuery
				,N'@PermissionEnityIds uttIDList READONLY'
				,@PermissionEnityIds
		END
		ELSE
		BEGIN
			SELECT 0;
		END
	END
	ELSE
	BEGIN
		SELECT 0;
	END
END
