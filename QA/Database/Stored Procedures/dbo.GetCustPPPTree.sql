SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/19/2018      
-- Description:               Get all PPP list for Customers
-- Execution:                 EXEC [dbo].[GetCustPPPTree]
-- Modified on:  
-- Modified Desc:  
-- =============================================                           
CREATE PROCEDURE [dbo].[GetCustPPPTree] @orgId BIGINT = 0
	,@custId BIGINT = NULL
	,@parentId BIGINT = NULL
	,@userId BIGINT
	,@roleId BIGINT
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @ProgramCount BIGINT
		,@IsProgAdmin BIT = 0
		,@CustomerCount BIGINT
		,@IsCustomerAdmin BIT = 0

	IF OBJECT_ID('tempdb..#EntityProgramIdTemp') IS NOT NULL
	BEGIN
		DROP TABLE #EntityProgramIdTemp
	END

	IF OBJECT_ID('tempdb..#EntityCustomerTemp') IS NOT NULL
	BEGIN
		DROP TABLE #EntityCustomerTemp
	END

	CREATE TABLE #EntityProgramIdTemp (EntityId BIGINT)
	CREATE TABLE #EntityCustomerTemp (EntityId BIGINT)
	CREATE NONCLUSTERED INDEX IX_EntityProgramIdTemp_EntityId on #EntityProgramIdTemp (EntityId) 
	CREATE NONCLUSTERED INDEX IX_EntityCustomerTemp_EntityId on #EntityCustomerTemp (EntityId) 
	INSERT INTO #EntityProgramIdTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId
		,@roleId
		,@orgId
		,'Program'

	INSERT INTO #EntityCustomerTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId
		,@roleId
		,@orgId
		,'Customer', 0, 1

	SELECT @ProgramCount = Count(ISNULL(EntityId, 0))
	FROM #EntityProgramIdTemp
	WHERE ISNULL(EntityId, 0) = - 1

	IF (@ProgramCount = 1)
	BEGIN
		SET @IsProgAdmin = 1
	END

	SELECT @CustomerCount = Count(ISNULL(EntityId, 0))
	FROM #EntityCustomerTemp
	WHERE ISNULL(EntityId, 0) = - 1

	IF (@CustomerCount = 1)
	BEGIN
		SET @IsCustomerAdmin = 1
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

	IF (ISNULL(@IsCustomerAdmin, 0) = 0)
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

	DECLARE @treeList TABLE (
		[Id] [bigint]
		,[CustomerId] [bigint]
		,[ParentId] [bigint]
		,[Text] NVARCHAR(50)
		,[ToolTip] NVARCHAR(1000)
		,[Enabled] BIT
		,[HierarchyLevel] INT
		,[HierarchyText] NVARCHAR(50)
		,[IconCss] NVARCHAR(50)
		)

	INSERT INTO @treeList
	SELECT cust.Id
		,cust.Id
		,NULL
		,cust.CustCode AS [Text]
		,cust.CustTitle AS [ToolTip]
		,0 AS [Enabled]
		,0
		,''
		,'mail_contact_16x16'
	FROM #CUST000Master(NOLOCK) cust
	WHERE cust.CustOrgId = @orgId
		AND cust.StatusId = 1

	IF (@parentId IS NOT NULL)
	BEGIN
		DECLARE @hierarchyLevel INT
		DECLARE @hierarchyIdText NVARCHAR(100)

		SELECT @hierarchyLevel = PrgHierarchyLevel
			,@hierarchyIdText = [PrgHierarchyID].ToString()
		FROM #PRGRM000Master
		WHERE Id = @parentId
			AND PrgOrgID = @orgId;

		INSERT INTO @treeList
		SELECT prg.Id
			,prg.PrgCustID
			,prg.Id
			,CASE 
				WHEN @hierarchyLevel = 1
					THEN prg.PrgProjectCode
				ELSE prg.PrgPhaseCode
				END AS [Text]
			,prg.PrgProgramTitle AS [ToolTip]
			,0 AS [Enabled]
			,prg.PrgHierarchyLevel
			,Prg.[PrgHierarchyID].ToString()
			,CASE 
				WHEN @hierarchyLevel = 1
					THEN 'functionlibrary_statistical_16x16'
				ELSE 'functionlibrary_recentlyuse_16x16'
				END AS [IconCss]
		FROM @treeList prgTree
		INNER JOIN #PRGRM000Master prg ON Prg.PrgCustId = prgTree.Id -- directly take program under customer that why parent id = customer id        
		WHERE prg.PrgOrgID = @orgId
			AND prg.PrgHierarchyLevel = @hierarchyLevel + 1
			AND Prg.[PrgHierarchyID].ToString() LIKE @hierarchyIdText + '%'
			AND prg.PrgCustID = (
				CASE 
					WHEN @custId IS NULL
						THEN prg.PrgCustID
					ELSE @custId
					END
				);

		SELECT *
		FROM @treeList
		WHERE ParentId IS NOT NULL --= (CASE WHEN @parentId IS NULL THEN ParentId ELSE @parentId END)        
	END
	ELSE IF (
			@parentId IS NULL
			AND @custId IS NOT NULL
			)
	BEGIN
		INSERT INTO @treeList
		SELECT prg.Id
			,prg.PrgCustID
			,prg.Id
			,prg.PrgProgramCode AS [Text]
			,prg.PrgProgramTitle AS [ToolTip]
			,0 AS [Enabled]
			,prg.PrgHierarchyLevel
			,Prg.[PrgHierarchyID].ToString()
			,'functionlibrary_morefunctions_16x16' AS [IconCss]
		FROM @treeList prgTree
		INNER JOIN #PRGRM000Master prg ON Prg.PrgCustId = prgTree.Id -- directly take program under customer that why parent id = customer id        
		WHERE prg.PrgOrgID = @orgId
			AND prg.PrgHierarchyLevel = 1
			AND prg.PrgCustID = (
				CASE 
					WHEN @custId IS NULL
						THEN prg.PrgCustID
					ELSE @custId
					END
				);

		SELECT *
		FROM @treeList
		WHERE ParentId = (
				CASE 
					WHEN @parentId IS NULL
						THEN ParentId
					ELSE @parentId
					END
				)
	END
	ELSE
	BEGIN
		UPDATE @treeList
		SET [Enabled] = 1
		FROM @treeList prgTree
		INNER JOIN #PRGRM000Master prg ON prg.PrgCustId = prgTree.Id
		WHERE prg.PrgOrgID = @orgId
			AND prg.PrgHierarchyLevel = 1

		SELECT *
		FROM @treeList
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
