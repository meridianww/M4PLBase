SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group          
   All Rights Reserved Worldwide */
-- =============================================                  
-- Author:                    Janardana                       
-- Create date:               14/08/2018                
-- Description:               Get all Customer Program treeview Data under the specified Organization     for copy feature     
-- Execution:                 EXEC [dbo].[GetProgramCopyTreeViewData]          
-- Modified on:            
-- Modified Desc:            
-- =============================================                               
CREATE PROCEDURE [dbo].[GetProgramCopyTreeViewData] --1,0,60,1,2, 1,'Program'  
	@userId BIGINT
	,@isSource BIT = 0
	,@programId BIGINT = 0
	,@orgId BIGINT = 0
	,@parentId BIGINT
	,@isCustNode BIT = 0
	,@entity NVARCHAR(100) = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @HierarchyID NVARCHAR(100)
		,@HierarchyLevel INT

	--GET CUSTOMERS   WHERE ParentId is null            
	IF @parentId IS NULL
	BEGIN
		SELECT @HierarchyID = PrgHierarchyID.ToString()
			,@HierarchyLevel = PrgHierarchyLevel
		FROM [PRGRM000Master]
		WHERE Id = @programId;

		SELECT DISTINCT c.Id AS Id
			,NULL AS ParentId
			,CAST(0 AS VARCHAR) + '_' + CAST(c.Id AS VARCHAR) AS [Name]
			,c.CustCode AS [Text]
			,c.CustTitle AS ToolTip
			,'mail_contact_16x16' AS IconCss
			,CASE 
				WHEN (
						@HierarchyLevel = 1
						AND @isSource = 0
						)
					THEN CAST(1 AS BIT)
				ELSE CAST(0 AS BIT)
				END AS IsLeaf
		FROM [dbo].[CUST000Master] c
		LEFT JOIN PRGRM000Master pm ON c.Id = pm.PrgCustID
		WHERE c.CustOrgID = @orgId
			AND c.StatusId = 1
			AND pm.Id = CASE @isSource
				WHEN 1
					THEN @programId
				ELSE pm.Id
				END;
	END
	ELSE IF @parentId IS NOT NULL
		AND @isCustNode = 1
	BEGIN
		DECLARE @parentProgramID BIGINT
		DECLARE @ance1 NVARCHAR(10)
		DECLARE @ance2 NVARCHAR(10)
		DECLARE @hLevel INT

		SELECT @ance1 = PrgHierarchyID.GetAncestor(1).ToString()
			,@ance2 = PrgHierarchyID.GetAncestor(2).ToString()
			,@hLevel = PrgHierarchyLevel
		FROM PRGRM000Master
		WHERE Id = @programId

		IF @ance1 = '/'
		BEGIN
			SET @parentProgramID = @programId
		END
		ELSE IF @ance2 = '/'
		BEGIN
			SELECT @parentProgramID = Id
			FROM PRGRM000Master
			WHERE PrgHierarchyID.ToString() = @ance1
		END
		ELSE
		BEGIN
			SELECT @parentProgramID = Id
			FROM PRGRM000Master
			WHERE PrgHierarchyID.ToString() = @ance2
		END

		SELECT @HierarchyID = PrgHierarchyID.ToString()
			,@HierarchyLevel = PrgHierarchyLevel
		FROM [PRGRM000Master]
		WHERE Id = @parentProgramID;

		SELECT prg.Id AS Id
			,cst.Id AS ParentId
			,CAST(cst.Id AS VARCHAR) + '_' + CAST(prg.Id AS VARCHAR) AS Name
			,prg.[PrgProgramCode] AS [Text]
			,prg.[PrgProgramTitle] AS ToolTip
			,'functionlibrary_morefunctions_16x16' AS IconCss
			--,CASE WHEN  prg.[PrgHierarchyLevel]  <  @hLevel AND  @isSource =0  THEN CAST(1 AS BIT)
			,CASE 
				WHEN @hLevel = 2
					AND @isSource = 0
					THEN CAST(1 AS BIT)
				ELSE CAST(0 AS BIT)
				END AS IsLeaf
		FROM [dbo].[PRGRM000Master](NOLOCK) prg
		INNER JOIN CUST000Master cst ON prg.PrgCustID = cst.Id
		WHERE prg.StatusId = 1
			AND prg.[PrgHierarchyLevel] = 1
			AND PrgCustID = @parentId
			AND prg.Id = CASE @isSource
				WHEN 1
					THEN @parentProgramID
				ELSE prg.Id
				END;
	END
	ELSE
	BEGIN
		SELECT @HierarchyID = PrgHierarchyID.ToString()
			,@HierarchyLevel = PrgHierarchyLevel
		FROM [PRGRM000Master]
		WHERE Id = @parentId;

		DECLARE @currentHierarchyLevel INT

		SELECT @currentHierarchyLevel = PrgHierarchyLevel
		FROM [PRGRM000Master]
		WHERE Id = @programId;

		IF @currentHierarchyLevel > 1
			AND @isSource = 1 --AND @programId <> @parentId  
		BEGIN
			SELECT @HierarchyID = PrgHierarchyID.GetAncestor(1).ToString() + '%'
			FROM [PRGRM000Master]
			WHERE Id = @programId;
		END
		ELSE
		BEGIN
			SET @HierarchyID = @HierarchyID + '%';
		END

		DECLARE @TreeTable TABLE (
			Id BIGINT
			,ParentId BIGINT NULL
			,Name NVARCHAR(200)
			,[Text] NVARCHAR(200)
			,ToolTip NVARCHAR(200)
			,IconCss NVARCHAR(50)
			,IsLeaf BIT
			);

		IF (
				@isSource = 1
				AND @currentHierarchyLevel <= @HierarchyLevel
				)
		BEGIN
			INSERT INTO @TreeTable (
				Id
				,ParentId
				,Name
				,[Text]
				,ToolTip
				,IconCss
				,IsLeaf
				)
			SELECT Id
				,@parentId AS ParentId
				,'Tab' + CAST(@parentId AS VARCHAR) + '_' + CAST(TabTableName AS VARCHAR) AS Name
				,TabPageTitle AS [Text]
				,TabPageTitle AS ToolTip
				,NULL AS IconCss
				,CAST(1 AS BIT) AS IsLeaf
			FROM [dbo].[SYSTM030Ref_TabPageName]
			WHERE RefTablename = @entity
				AND TabTableName <> @entity
				AND TabTableName NOT IN (
					SELECT RefTableName
					FROM [dbo].[SYSTM000SecurityByRole] Sbr
					INNER JOIN [dbo].[SYSTM010SubSecurityByRole] subSbr ON sbr.Id = subSbr.SecByRoleId
					INNER JOIN [dbo].[CONTC010Bridge] cb ON cb.ConCodeId = Sbr.OrgRefRoleId
						AND cb.ConTableName = [dbo].fnGetEntityName(1)
					WHERE cb.ContactMSTRID = @userId
						AND cb.ConOrgId = @OrgId
						AND sbr.StatusID = 1
						AND sbr.SecMainModuleId = 12
						AND subSbr.StatusId = 1
					);
		END

		INSERT INTO @TreeTable (
			Id
			,ParentId
			,Name
			,[Text]
			,ToolTip
			,IconCss
			,IsLeaf
			)
		SELECT prg.Id AS Id
			,@parentId AS ParentId
			,CAST(@parentId AS VARCHAR) + '_' + CAST(prg.Id AS VARCHAR) AS Name
			,CASE 
				WHEN @HierarchyLevel = 1
					THEN prg.[PrgProjectCode]
				WHEN @HierarchyLevel = 2
					THEN prg.[PrgPhaseCode]
				END AS [Text]
			,prg.[PrgProgramTitle] AS ToolTip
			,CASE 
				WHEN @HierarchyLevel = 1
					THEN 'functionlibrary_statistical_16x16'
				WHEN @HierarchyLevel = 2
					THEN 'functionlibrary_recentlyuse_16x16'
				END AS IconCss
			--,CASE WHEN @HierarchyLevel = prg.PrgHierarchyLevel AND @isSource =0  THEN CAST(1 AS BIT) 
			,CASE 
				WHEN @currentHierarchyLevel > prg.PrgHierarchyLevel
					AND @isSource = 0
					THEN CAST(1 AS BIT)
				ELSE CAST(0 AS BIT)
				END AS IsLeaf
		FROM [dbo].[PRGRM000Master](NOLOCK) prg
		INNER JOIN CUST000Master cst ON prg.PrgCustID = cst.Id
		WHERE prg.StatusId = 1
			AND prg.PrgHierarchyID.ToString() LIKE @HierarchyID
			AND prg.PrgHierarchyLevel = (@HierarchyLevel + 1);

		IF EXISTS (
				SELECT Id
				FROM @TreeTable
				WHERE Id = @programId
				)
		BEGIN
			SELECT Id
				,ParentId
				,Name
				,[Text]
				,ToolTip
				,IconCss
				,IsLeaf
			FROM @TreeTable
			WHERE Id = @programId
		END
		ELSE
		BEGIN
			SELECT Id
				,ParentId
				,Name
				,[Text]
				,ToolTip
				,IconCss
				,IsLeaf
			FROM @TreeTable
		END
	END
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

