SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana             
-- Create date:               11/02/2018      
-- Description:               Get all Customer Program treeview Data under the specified Organization
-- Execution:                 EXEC [dbo].[GetProgramTreeViewData]
-- Modified on:  
-- Modified Desc:  
-- =============================================                     
CREATE PROCEDURE [dbo].[GetProgramTreeViewData] @orgId BIGINT = 0
	,@parentId BIGINT
	,@isCustNode BIT = 0
	,@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
AS
BEGIN TRY
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#EntityProgramIdTemp') IS NOT NULL
	BEGIN
		DROP TABLE #EntityProgramIdTemp
	END

	IF OBJECT_ID('tempdb..#EntityCustomerTemp') IS NOT NULL
	BEGIN
		DROP TABLE #EntityCustomerTemp
	END

	DECLARE @ProgramCount BIGINT
		,@CustsomerCount BIGINT
		,@ISCustAdmin BIT = 0
		,@IsProgAdmin BIT = 0

	CREATE TABLE #EntityProgramIdTemp (EntityId BIGINT)

	CREATE TABLE #EntityCustomerTemp (EntityId BIGINT)

	INSERT INTO #EntityProgramIdTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId
		,@roleId
		,@orgId
		,@entity

	INSERT INTO #EntityCustomerTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId
		,@roleId
		,@orgId
		,'Customer', 0, 1

	SELECT @ProgramCount = Count(ISNULL(EntityId, 0))
	FROM #EntityProgramIdTemp
	WHERE ISNULL(EntityId, 0) = -1

	SELECT @CustsomerCount = Count(ISNULL(EntityId, 0))
	FROM #EntityCustomerTemp
	WHERE ISNULL(EntityId, 0) = -1

	IF (@ProgramCount = 1)
	BEGIN
		SET @IsProgAdmin = 1
	END

	IF (@CustsomerCount = 1)
	BEGIN
		SET @ISCustAdmin = 1
	END

	CREATE TABLE #PRGRM000Master (
		[Id] [bigint]
		,[PrgOrgID] [bigint]
		,[PrgCustID] [bigint]
		,[PrgItemNumber] [nvarchar](20)
		,[PrgProgramCode] [nvarchar](20)
		,[PrgProjectCode] [nvarchar](20)
		,[PrgPhaseCode] [nvarchar](20)
		,[PrgProgramTitle] [nvarchar](50)
		,[PrgAccountCode] [nvarchar](50)
		,[DelEarliest] [decimal](18, 2)
		,[DelLatest] [decimal](18, 2)
		,[DelDay] [bit]
		,[PckEarliest] [decimal](18, 2)
		,[PckLatest] [decimal](18, 2)
		,[PckDay] [bit]
		,[PrgDateStart] [datetime2](7)
		,[PrgDateEnd] [datetime2](7)
		,[PrgDeliveryTimeDefault] [datetime2](7)
		,[PrgPickUpTimeDefault] [datetime2](7)
		,[PrgDescription] [varbinary](max)
		,[PrgNotes] [varbinary](max)
		,[PrgHierarchyID] [hierarchyid]
		,[PrgHierarchyLevel] [int]
		)

	CREATE TABLE #CUST000Master (
		[Id] [bigint]
		,[CustERPID] [nvarchar](10)
		,[CustOrgId] [bigint]
		,[CustItemNumber] [int]
		,[CustCode] [nvarchar](20)
		,[CustTitle] [nvarchar](50)
		,[CustDescription] [varbinary](max)
		,[CustWorkAddressId] [bigint]
		,[CustBusinessAddressId] [bigint]
		,[CustCorporateAddressId] [bigint]
		,[CustContacts] [int]
		,[CustNotes] [varbinary](max)
		,[CustTypeId] [int]
		,[StatusId] [int]
		)

	IF (ISNULL(@IsProgAdmin, 0) = 0)
	BEGIN
		INSERT INTO #PRGRM000Master (
			Id
			,PrgOrgID
			,PrgCustID
			,PrgItemNumber
			,PrgProgramCode
			,PrgProjectCode
			,PrgPhaseCode
			,PrgProgramTitle
			,PrgAccountCode
			,DelEarliest
			,DelLatest
			,DelDay
			,PckEarliest
			,PckLatest
			,PckDay
			,PrgDateStart
			,PrgDateEnd
			,PrgDeliveryTimeDefault
			,PrgPickUpTimeDefault
			,PrgDescription
			,PrgNotes
			,PrgHierarchyID
			,PrgHierarchyLevel
			)
		SELECT Id
			,PrgOrgID
			,PrgCustID
			,PrgItemNumber
			,PrgProgramCode
			,PrgProjectCode
			,PrgPhaseCode
			,PrgProgramTitle
			,PrgAccountCode
			,DelEarliest
			,DelLatest
			,DelDay
			,PckEarliest
			,PckLatest
			,PckDay
			,PrgDateStart
			,PrgDateEnd
			,PrgDeliveryTimeDefault
			,PrgPickUpTimeDefault
			,PrgDescription
			,PrgNotes
			,PrgHierarchyID
			,PrgHierarchyLevel
		FROM [PRGRM000Master] pgm
		INNER JOIN #EntityProgramIdTemp tmp ON tmp.EntityId = pgm.Id
		WHERE pgm.StatusId = 1
	END
	ELSE
	BEGIN
		INSERT INTO #PRGRM000Master (
			Id
			,PrgOrgID
			,PrgCustID
			,PrgItemNumber
			,PrgProgramCode
			,PrgProjectCode
			,PrgPhaseCode
			,PrgProgramTitle
			,PrgAccountCode
			,DelEarliest
			,DelLatest
			,DelDay
			,PckEarliest
			,PckLatest
			,PckDay
			,PrgDateStart
			,PrgDateEnd
			,PrgDeliveryTimeDefault
			,PrgPickUpTimeDefault
			,PrgDescription
			,PrgNotes
			,PrgHierarchyID
			,PrgHierarchyLevel
			)
		SELECT Id
			,PrgOrgID
			,PrgCustID
			,PrgItemNumber
			,PrgProgramCode
			,PrgProjectCode
			,PrgPhaseCode
			,PrgProgramTitle
			,PrgAccountCode
			,DelEarliest
			,DelLatest
			,DelDay
			,PckEarliest
			,PckLatest
			,PckDay
			,PrgDateStart
			,PrgDateEnd
			,PrgDeliveryTimeDefault
			,PrgPickUpTimeDefault
			,PrgDescription
			,PrgNotes
			,PrgHierarchyID
			,PrgHierarchyLevel
		FROM [PRGRM000Master] pgm
		WHERE pgm.StatusId = 1
	END

	IF (ISNULL(@ISCustAdmin, 0) = 0)
	BEGIN
		INSERT INTO #CUST000Master (
			Id
			,CustERPID
			,CustOrgId
			,CustItemNumber
			,CustCode
			,CustTitle
			,CustDescription
			,CustWorkAddressId
			,CustBusinessAddressId
			,CustCorporateAddressId
			,CustContacts
			,CustNotes
			,CustTypeId
			,StatusId
			)
		SELECT CUST.Id
			,CustERPID
			,CustOrgId
			,CustItemNumber
			,CustCode
			,CustTitle
			,CustDescription
			,CustWorkAddressId
			,CustBusinessAddressId
			,CustCorporateAddressId
			,CustContacts
			,CustNotes
			,CustTypeId
			,StatusId
		FROM dbo.CUST000Master CUST
		INNER JOIN #EntityCustomerTemp CUST1 ON CUST1.EntityId = CUST.Id
		UNION 
		SELECT CUST.Id
			,CUST.CustERPID
			,CUST.CustOrgId
			,CUST.CustItemNumber
			,CUST.CustCode
			,CUST.CustTitle
			,CUST.CustDescription
			,CUST.CustWorkAddressId
			,CUST.CustBusinessAddressId
			,CUST.CustCorporateAddressId
			,CUST.CustContacts
			,CUST.CustNotes
			,CUST.CustTypeId
			,CUST.StatusId
		FROM dbo.CUST000Master CUST
		INNER JOIN #PRGRM000Master CUST1 ON CUST1.PrgCustId = CUST.Id
	END
	ELSE
	BEGIN
		INSERT INTO #CUST000Master (
			Id
			,CustERPID
			,CustOrgId
			,CustItemNumber
			,CustCode
			,CustTitle
			,CustDescription
			,CustWorkAddressId
			,CustBusinessAddressId
			,CustCorporateAddressId
			,CustContacts
			,CustNotes
			,CustTypeId
			,StatusId
			)
		SELECT Id
			,CustERPID
			,CustOrgId
			,CustItemNumber
			,CustCode
			,CustTitle
			,CustDescription
			,CustWorkAddressId
			,CustBusinessAddressId
			,CustCorporateAddressId
			,CustContacts
			,CustNotes
			,CustTypeId
			,StatusId
		FROM dbo.CUST000Master CUST
	END

	IF @parentId IS NULL
	BEGIN
		SELECT c.Id AS Id
			,NULL AS ParentId
			,CAST(0 AS VARCHAR) + '_' + CAST(c.Id AS VARCHAR) AS [Name]
			,c.CustCode AS [Text]
			,c.CustTitle AS ToolTip
			,'mail_contact_16x16' AS IconCss
			,CASE WHEN (SELECT COUNT(pgm.Id) FROM #PRGRM000Master pgm WHERE  pgm.PrgCustID = c.Id  AND pgm.PrgHierarchyLevel=1) =  0 THEN CAST(1 AS BIT)
	       ELSE  CAST(0 AS BIT) END As IsLeaf
		FROM #CUST000Master c
		WHERE c.CustOrgID = @orgId
			AND c.StatusId = 1;
	END
	ELSE IF @parentId IS NOT NULL
		AND @isCustNode = 1
	BEGIN
		SELECT prg.Id AS Id
			,cst.Id AS ParentId
			,CAST(cst.Id AS VARCHAR) + '_' + CAST(prg.Id AS VARCHAR) AS Name
			,prg.[PrgProgramCode] AS [Text]
			,prg.[PrgProgramTitle] AS ToolTip
			,'functionlibrary_morefunctions_16x16' AS IconCss
			,CASE 
				WHEN (
						SELECT COUNT(Id)
						FROM #PRGRM000Master pgm
						WHERE pgm.PrgHierarchyLevel = (prg.PrgHierarchyLevel + 1)
							AND pgm.PrgHierarchyID.ToString() LIKE prg.PrgHierarchyID.ToString() + '%'
						) = 0
					THEN CAST(1 AS BIT)
				ELSE CAST(0 AS BIT)
				END AS IsLeaf
		FROM #PRGRM000Master(NOLOCK) prg
		INNER JOIN #CUST000Master cst ON prg.PrgCustID = cst.Id
		WHERE prg.[PrgHierarchyLevel] = 1
			AND PrgCustID = @parentId;
	END
	ELSE
	BEGIN
		DECLARE @HierarchyID NVARCHAR(100)
			,@HierarchyLevel INT

		SELECT @HierarchyID = PrgHierarchyID.ToString()
			,@HierarchyLevel = PrgHierarchyLevel
		FROM #PRGRM000Master
		WHERE Id = @parentId;

		SELECT prg.Id AS Id
			,@parentId AS ParentId
			--,CAST(cst.Id AS VARCHAR)+ '_' + CAST(prg.Id AS VARCHAR) AS Name  
			,CAST(@parentId AS VARCHAR) + '_' + CAST(prg.Id AS VARCHAR) AS Name
			,CASE 
				WHEN @HierarchyLevel = 1
					THEN prg.[PrgProjectCode]
				WHEN @HierarchyLevel = 2
					THEN prg.[PrgPhaseCode]
				END AS [Text]
			--,prg.[PrgProgramCode]  AS [Text]    
			,prg.[PrgProgramTitle] AS ToolTip
			,CASE 
				WHEN @HierarchyLevel = 1
					THEN 'functionlibrary_statistical_16x16'
				WHEN @HierarchyLevel = 2
					THEN 'functionlibrary_recentlyuse_16x16'
				END AS IconCss
			,CASE 
				WHEN (
						SELECT COUNT(Id)
						FROM #PRGRM000Master pgm
						WHERE pgm.PrgHierarchyLevel = (prg.PrgHierarchyLevel + 1)
							AND pgm.PrgHierarchyID.ToString() LIKE prg.PrgHierarchyID.ToString() + '%'
						) = 0
					THEN CAST(1 AS BIT)
				ELSE CAST(0 AS BIT)
				END AS IsLeaf
		FROM #PRGRM000Master(NOLOCK) prg
		INNER JOIN #CUST000Master cst ON prg.PrgCustID = cst.Id
		WHERE prg.PrgHierarchyID.ToString() LIKE @HierarchyID + '%'
			AND prg.PrgHierarchyLevel = (@HierarchyLevel + 1);
	END

	DROP TABLE #EntityCustomerTemp

	DROP TABLE #EntityProgramIdTemp

	DROP TABLE #PRGRM000Master

	DROP TABLE #CUST000Master
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
