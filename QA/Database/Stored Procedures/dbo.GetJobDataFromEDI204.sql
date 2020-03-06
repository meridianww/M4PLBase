SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************
* Copyright(C) 2020 Meridian Worldwide Transportation Group. All Rights Reserved. 
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
-- ====================================================================
-- Author:		Prashant Aggarwal
-- Create date: 03/05/2020
-- Description:	Get the Complete Job Data From EDI 204
-- Execution Sample: EXEC [dbo].[GetJobDataFromEDI204] 236770
-- =====================================================================
CREATE PROCEDURE [dbo].[GetJobDataFromEDI204] (@eshHeaderID BIGINT)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @Columns VARCHAR(MAX)
		,@SelectQuery NVARCHAR(Max)
		,@ProgramId BIGINT
		,@ParentProgramId BIGINT
		,@TradingPartner VARCHAR(150)
		,@HierarchyID NVARCHAR(100)
		,@HierarchyLevel INT
		,@PecJobField VARCHAR(150)
		,@PecCondition VARCHAR(150)
		,@PerLogical VARCHAR(150)
		,@PecJobField2 VARCHAR(150)
		,@PecCondition2 VARCHAR(150)
		,@Condition1 VARCHAR(Max) = ''
		,@Condition2 VARCHAR(Max) = ''
		,@TotalCount INT
		,@Counter INT = 1
		,@CurrentProgramId BIGINT
		,@WhereCondition NVARCHAR(Max)
		,@SelectQueryForProgram NVARCHAR(Max)
		,@MatchedHeaderId BIGINT

	CREATE TABLE #TempChildProgram (
		ID INT IDENTITY(1, 1)
		,ProgramId BIGINT
		)

	SELECT @TradingPartner = eshTradingPartner
	FROM [dbo].[EDI204SummaryHeader]
	WHERE eshHeaderID = @eshHeaderID

	SELECT @ParentProgramId = CASE 
			WHEN ISNULL(PehParentEDI, 0) = 1
				THEN PehProgramID
			ELSE - 1
			END
		,@ProgramId = CASE 
			WHEN ISNULL(PehParentEDI, 0) = 0
				THEN PehProgramID
			ELSE - 1
			END
	FROM [dbo].[PRGRM070EdiHeader]
	WHERE PehTradingPartner = @TradingPartner
		AND PehEdiTitle LIKE '%EDI 204 Document'

	IF (@ProgramId = - 1)
	BEGIN
		SELECT @HierarchyID = PrgHierarchyID.ToString()
			,@HierarchyLevel = PrgHierarchyLevel
		FROM PRGRM000Master
		WHERE Id = @ParentProgramId;

		INSERT INTO #TempChildProgram (ProgramId)
		SELECT prg.Id
		FROM PRGRM000Master(NOLOCK) prg
		WHERE prg.PrgHierarchyLevel = (@HierarchyLevel + 1)
			AND Prg.StatusId = 1
			AND prg.PrgHierarchyID.ToString() LIKE @HierarchyID + '%'

		SELECT @TotalCount = ISNULL(Count(Id), 0)
		FROM #TempChildProgram

		WHILE (@TotalCount > 0)
		BEGIN
			IF (@ProgramId <= 0)
			BEGIN
				SET @PecJobField = ''
				SET @PecCondition = ''
				SET @PerLogical = ''
				SET @PecJobField2 = ''
				SET @PecCondition2 = ''
				SET @Condition1 = ''
				SET @Condition2 = ''
				SET @WhereCondition = ''

				SELECT @CurrentProgramId = ProgramId
				FROM #TempChildProgram
				WHERE Id = @Counter

				SELECT @PecJobField = PecJobField
					,@PecCondition = PecCondition
					,@PerLogical = PerLogical
					,@PecJobField2 = PecJobField2
					,@PecCondition2 = PecCondition2
				FROM [M4PL_Staging].[dbo].[PRGRM072EdiConditions]
				WHERE PecProgramId = @CurrentProgramId
					AND StatusId = 1

				IF (
						ISNULL(@PecJobField, '') <> ''
						AND ISNULL(@PecCondition, '') <> ''
						)
				BEGIN
					SELECT @Condition1 = @Condition1 + ' OR ' + CONCAT (
							@PecJobField
							,' Like '
							) + CONCAT (
							''''
							,RTRIM(LTRIM(Item))
							,''''
							)
					FROM [dbo].[fnSplitString](@PecCondition, ',')
				END

				IF (
						ISNULL(@PecJobField2, '') <> ''
						AND ISNULL(@PecCondition2, '') <> ''
						)
				BEGIN
					SELECT @Condition2 = @Condition2 + ' OR ' + CONCAT (
							@PecJobField2
							,' Like '
							) + CONCAT (
							''''
							,RTRIM(LTRIM(Item))
							,''''
							)
					FROM [dbo].[fnSplitString](@PecCondition2, ',')
				END

				IF (
						ISNULL(@Condition1, '') <> ''
						AND ISNULL(@Condition2, '') <> ''
						)
				BEGIN
					SET @WhereCondition = CONCAT (
							'('
							,Substring(@Condition1, 4, LEN(@Condition1))
							,')'
							,' ' + @PerLogical + ' (' + Substring(@Condition2, 4, LEN(@Condition2))
							,')'
							)
				END
				ELSE IF (ISNULL(@Condition1, '') <> '')
				BEGIN
					SET @WhereCondition = CONCAT (
							'('
							,Substring(@Condition1, 4, LEN(@Condition1))
							,')'
							)
				END

				IF (ISNULL(@WhereCondition, '') <> '')
				BEGIN
					SET @SelectQueryForProgram = CONCAT (
							'Select @MatchedHeaderId = eshHeaderID From [EDI204SummaryHeader] Where eshHeaderID = '
							,@eshHeaderID
							,' AND '
							,@WhereCondition
							)

					EXEC sp_executesql @SelectQueryForProgram
						,N'@MatchedHeaderId VARCHAR(MAX) OUTPUT'
						,@MatchedHeaderId OUTPUT

					IF (ISNULL(@MatchedHeaderId, 0) > 0)
					BEGIN
						SET @ProgramId = @CurrentProgramId
					END
				END
			END

			SET @Counter = @Counter + 1
			SET @TotalCount = @TotalCount - 1
		END
	END

	SET @Columns = ''

	SELECT @Columns = @Columns + CONCAT (
			[PemEdiTableName]
			,'.'
			,[PemEdiFieldName]
			,' '
			,[PemSysFieldName]
			) + ', '
	FROM [dbo].[PRGRM071EdiMapping] PEM
	INNER JOIN [dbo].[PRGRM070EdiHeader] PEH ON PEH.Id = PEM.PemHeaderID
	WHERE [PemSysTableName] = 'JOBDL000Master'
		AND PEM.StatusId = 1
		AND PemEdiTableName LIKE '%204%'
		AND PehEdiCode LIKE '%204%'
		AND PehProgramID = @ParentProgramId

	SET @SelectQuery = 'Select TOP 1 ' + CAST(@ProgramId AS VARCHAR(50)) + ' ProgramID, ' + SUBSTRING(@Columns, 0, LEN(@Columns)) + ' From dbo.EDI204SummaryHeader EDI204SummaryHeader
               INNER JOIN dbo.EDI204SummaryDetail EDI204SummaryDetail ON EDI204SummaryDetail.eshHeaderID = EDI204SummaryHeader.eshHeaderID' + ' Where EDI204SummaryHeader.eshHeaderID=' + '' + CAST(@eshHeaderID AS VARCHAR) + ''

	EXEC (@SelectQuery)

	DROP TABLE #TempChildProgram
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

