
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               12/10/2020      
-- Description:               Get all PPP list 
-- Execution:                 Exec dbo.GetCustomerPPPTree @orgId=1,@userId=20084,@roleId=20033
-- Modified on:  
-- Modified Desc:  
CREATE PROCEDURE GetCustomerPPPTree 
	 @orgId BIGINT = 0
	,@userId BIGINT
	,@roleId BIGINT
AS
BEGIN
    DECLARE @ProgramCount BIGINT
		,@IsProgAdmin BIT = 0
		,@CustomerCount BIGINT =0
		,@IsCustomerAdmin BIT = 0
   	IF OBJECT_ID('tempdb..#EntityProgramIdTemp') IS NOT NULL
	BEGIN
		DROP TABLE #EntityProgramIdTemp
	END
	IF OBJECT_ID('tempdb..#EntityProgramIdTemp') IS NOT NULL
	BEGIN
		DROP TABLE #EntityCustomerIdTemp
	END

	CREATE TABLE #EntityProgramIdTemp (EntityId BIGINT PRIMARY KEY)
	CREATE TABLE #EntityCustomerIdTemp (CustomerId BIGINT PRIMARY KEY)
	INSERT INTO #EntityProgramIdTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId
		,@roleId
		,@orgId
		,'Program'

    INSERT INTO #EntityCustomerIdTemp(CustomerId)
	(SELECT DISTINCT CUST.ID FROM CUST000Master CUST
	INNER JOIN PRGRM000Master PRG ON PRG.PrgCustID = CUST.Id
	INNER JOIN #EntityProgramIdTemp TMP ON TMP.EntityId = PRG.ID)

	SELECT @ProgramCount = Count(ISNULL(EntityId, 0))
	FROM #EntityProgramIdTemp
	WHERE ISNULL(EntityId, 0) = - 1

	IF (@ProgramCount = 1)
	BEGIN
		SET @IsProgAdmin = 1
	END
	IF (ISNULL(@IsProgAdmin, 0) = 0)
	BEGIN
		SELECT PRG.Id,PrgCustID CustomerId,
		CASE WHEN ISNULL(PrgProgramCode,'') <> '' AND ISNULL(PrgProjectCode,'') = '' AND ISNULL(PrgPhaseCode,'') = '' THEN PrgProgramCode
			 WHEN ISNULL(PrgProgramCode,'') <> '' AND ISNULL(PrgProjectCode,'') <> '' AND ISNULL(PrgPhaseCode,'') = '' THEN PrgProjectCode
			 WHEN ISNULL(PrgProgramCode,'') <> '' AND ISNULL(PrgProjectCode,'') <> '' AND ISNULL(PrgPhaseCode,'') <> '' THEN PrgPhaseCode END [Text],
		CASE WHEN ISNULL(PrgProgramTitle,'') <> '' THEN PrgProgramTitle
		     WHEN ISNULL(PrgProgramTitle,'') = '' AND ISNULL(PrgProgramCode,'') <> '' AND ISNULL(PrgProjectCode,'') = '' AND ISNULL(PrgPhaseCode,'') = '' THEN PrgProgramCode
			 WHEN ISNULL(PrgProgramTitle,'') = '' AND ISNULL(PrgProgramCode,'') <> '' AND ISNULL(PrgProjectCode,'') <> '' AND ISNULL(PrgPhaseCode,'') = '' THEN PrgProjectCode
			 WHEN ISNULL(PrgProgramTitle,'') = '' AND ISNULL(PrgProgramCode,'') <> '' AND ISNULL(PrgProjectCode,'') <> '' AND ISNULL(PrgPhaseCode,'') <> '' THEN PrgPhaseCode END ToolTip,			 
			 PrgHierarchyLevel HierarchyLevel,
			 PrgHierarchyID.ToString() HierarchyText,
		CASE WHEN PrgHierarchyLevel = 1	THEN 'functionlibrary_morefunctions_16x16'
		     WHEN PrgHierarchyLevel = 2 THEN 'functionlibrary_statistical_16x16'
			 ELSE 'functionlibrary_recentlyuse_16x16' END [IconCss]
		FROM PRGRM000Master PRG
		INNER JOIN #EntityProgramIdTemp TEMP ON TEMP.EntityId = PRG.Id
		WHERE PRG.StatusId=1 AND PrgOrgID =1
		UNION
		SELECT Id, Id CustomerId,CustCode [Text], CustTitle ToolTip,0 AS HierarchyLevel,'' AS HierarchyLevel,
		'mail_contact_16x16' AS [IconCss] FROM CUST000Master CUST
		INNER JOIN #EntityCustomerIdTemp TMP ON TMP.CustomerId = CUST.Id
		WHERE StatusId = 1 AND CustOrgId=1
		ORDER BY CustomerId,HierarchyText,HierarchyLevel ASC
	END
	ELSE
	BEGIN
	   SELECT PRG.Id,PrgCustID CustomerId,
		CASE WHEN ISNULL(PrgProgramCode,'') <> '' AND ISNULL(PrgProjectCode,'') = '' AND ISNULL(PrgPhaseCode,'') = '' THEN PrgProgramCode
			 WHEN ISNULL(PrgProgramCode,'') <> '' AND ISNULL(PrgProjectCode,'') <> '' AND ISNULL(PrgPhaseCode,'') = '' THEN PrgProjectCode
			 WHEN ISNULL(PrgProgramCode,'') <> '' AND ISNULL(PrgProjectCode,'') <> '' AND ISNULL(PrgPhaseCode,'') <> '' THEN PrgPhaseCode END [Text],
		CASE WHEN ISNULL(PrgProgramTitle,'') <> '' THEN PrgProgramTitle
		     WHEN ISNULL(PrgProgramTitle,'') = '' AND ISNULL(PrgProgramCode,'') <> '' AND ISNULL(PrgProjectCode,'') = '' AND ISNULL(PrgPhaseCode,'') = '' THEN PrgProgramCode
			 WHEN ISNULL(PrgProgramTitle,'') = '' AND ISNULL(PrgProgramCode,'') <> '' AND ISNULL(PrgProjectCode,'') <> '' AND ISNULL(PrgPhaseCode,'') = '' THEN PrgProjectCode
			 WHEN ISNULL(PrgProgramTitle,'') = '' AND ISNULL(PrgProgramCode,'') <> '' AND ISNULL(PrgProjectCode,'') <> '' AND ISNULL(PrgPhaseCode,'') <> '' THEN PrgPhaseCode END ToolTip,			 
			 PrgHierarchyLevel HierarchyLevel,
			 PrgHierarchyID.ToString() HierarchyText,
		CASE WHEN PrgHierarchyLevel = 1	THEN 'functionlibrary_morefunctions_16x16'
		     WHEN PrgHierarchyLevel = 2 THEN 'functionlibrary_statistical_16x16'
			 ELSE 'functionlibrary_recentlyuse_16x16' END [IconCss]
		FROM PRGRM000Master PRG
		WHERE PRG.StatusId=1 AND PrgOrgID =1
		UNION
		SELECT Id, Id CustomerId,CustCode [Text], CustTitle ToolTip,0 AS HierarchyLevel,'' AS HierarchyLevel,
		'mail_contact_16x16' AS [IconCss] FROM CUST000Master WHERE StatusId = 1 AND CustOrgId=1
		ORDER BY CustomerId,HierarchyText,HierarchyLevel ASC
	END
END