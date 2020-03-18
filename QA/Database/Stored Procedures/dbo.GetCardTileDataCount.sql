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
	,@whereContition VARCHAR(MAX)
AS
BEGIN
	DECLARE @where NVARCHAR(500) = ' AND JobCard.StatusId = 1 '
		,@CountQuery NVARCHAR(Max) = ''
		,@RecordCount INT = 0
		,@IsJobAdmin BIT = 0
		,@CurrentCustomQuery NVARCHAR(4000) = ''
		
		
		SET @where = ' ' + ISNULL(@whereContition,'') + @where

SELECT @CurrentCustomQuery = CustomQuery FROM DashboardCategoryRelation WHERE DashboardCategoryRelationId = @dashboardRelationalId;
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
			SET @CountQuery = 'Select Count(DISTINCT JobId) From JOBDL000Master JobCard
					INNER JOIN JOBDL020Gateways Gateway ON JobCard.Id = Gateway.JobId
					INNER JOIN dbo.PRGRM000Master Program ON Program.Id = JobCard.ProgramID'

			IF (@IsJobAdmin = 0)
			BEGIN
				SET @CountQuery = @CountQuery + ' INNER JOIN #EntityIdTemp SecurityEntity ON  SecurityEntity.EntityId = JobCard.Id '
			END

			SET @CountQuery = @CountQuery + ' Where  Gateway.StatusId IN (select Id from SYSTM000Ref_Options where SysOptionName in (''Active'',''Completed''))  ' + @where + @CurrentCustomQuery + '  AND Program.PrgCustID =  ' + + CONVERT(NVARCHAR, @CompanyId)
		END
		ELSE
		BEGIN
			SET @CountQuery = 'Select COUNT(DISTINCT JobCard.Id) FROM [dbo].[JOBDL000Master] (NOLOCK) JobCard INNER JOIN JOBDL020Gateways Gateway ON Gateway.JobId =  JobCard.Id'

			IF (@IsJobAdmin = 0)
			BEGIN
				SET @CountQuery = @CountQuery + ' INNER JOIN #EntityIdTemp SecurityEntity ON  SecurityEntity.EntityId = JobCard.Id '
			END

			SET @CountQuery = @CountQuery + ' Where Gateway.StatusId IN (select Id from SYSTM000Ref_Options where SysOptionName in (''Active'',''Completed''))  ' + @where + @CurrentCustomQuery
		END

		EXEC sp_executesql @CountQuery
			--,N'@RecordCount int OUTPUT'
			--,@RecordCount = @RecordCount OUTPUT
	END
	ELSE
	BEGIN
		SELECT 0;
	END
END