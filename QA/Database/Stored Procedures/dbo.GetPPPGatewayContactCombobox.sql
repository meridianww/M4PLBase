SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               05/29/2018      
-- Description:               Get selected records by table  
-- Execution:                 [dbo].[GetPPPGatewayContactCombobox]  'EN',1,'Contact','Contact.id,Contact.ConFullName',1,10,NULL,NULL,NULL,1,'Id',2,NULL
-- Modified By:               Nikhil(07/04/2019)    
-- Modified Desc:             Updated it for @entityFor = 'PPPRoleCodeContact' to display only relevent Customer Contact,CustomerDClocation,CustomerDCLocationContact,Mapped Vendor Contact,its DC location and DC location Contact based on Customer.
-- Modified By:               Nikhil(07/08/2019)    
-- Modified Desc:             Updated to filter Contacts based on contact responsible and  analyst.
-- Modified By:               Nikhil(07/15/2019)    
-- Modified Desc:             Updated to Remove contacts from DropDown when a Contact is mapped.
-- Modified By:               Nikhil(07/16/2019)    
-- Modified Desc:             Updated to Filter Contacts based on Role US #44832.
-- =============================================   
CREATE PROCEDURE [dbo].[GetPPPGatewayContactCombobox] @langCode NVARCHAR(10)
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@fields NVARCHAR(2000)
	,@pageNo INT
	,@pageSize INT
	,@orderBy NVARCHAR(500)
	,@like NVARCHAR(500) = NULL
	,@where NVARCHAR(500) = NULL
	,@primaryKeyValue NVARCHAR(100) = NULL
	,@primaryKeyName NVARCHAR(50) = NULL
	,@parentId BIGINT = NULL
	,@entityFor NVARCHAR(50) = NULL
AS
BEGIN TRY
	IF OBJECT_ID('tempdb.dbo.#contactComboTable') IS NOT NULL
		DROP TABLE #contactComboTable

	CREATE TABLE #contactComboTable (
		Id BIGINT
		,ConFullName NVARCHAR(100)
		,ConJobTitle NVARCHAR(100)
		,ConFileAs NVARCHAR(100)
		)

	IF @entityFor = 'PPPRoleCodeContact'
	BEGIN
		DECLARE @CustomerId INT
			,@CustomerContactTypeID INT
			,@VendorContactTypeID INT
		DECLARE @RoleTypeName NVARCHAR(50)

		SELECT @CustomerContactTypeID = ID
		FROM SYSTM000Ref_Options
		WHERE sysOptionName = 'Customer'
			AND SysLookupCode = 'ContactType'

		SELECT @VendorContactTypeID = ID
		FROM SYSTM000Ref_Options
		WHERE sysOptionName = 'vendor'
			AND SysLookupCode = 'ContactType'

		SELECT @RoleTypeName = SysOptionName
		FROM SYSTM000Ref_Options
		WHERE id = (
				SELECT TOP 1 RoleTypeId
				FROM ORGAN010Ref_Roles OrgRefRole
				WHERE 1 = 1
					AND OrgRefRole.RoleTypeId = convert(INT, REPLACE(@where, ' AND OrgRefRole.RoleTypeId = ', ''))
				)

		SELECT @CustomerId = PrgCustID
		FROM PRGRM000Master
		WHERE id = @parentid

		IF (@RoleTypeName = 'Customer') --Customer	
		BEGIN
			DECLARE @CompanyID INT

			SELECT @CompanyID = id
			FROM COMP000Master
			WHERE CompTableName = 'Customer'
				AND CompPrimaryRecordId = (
					SELECT TOP 1 PrgCustID
					FROM PRGRM000Master
					WHERE ID = @parentId
						AND StatusId IN (
							1
							,2
							)
					)

			INSERT INTO #contactComboTable (
				Id
				,ConFullName
				,ConJobTitle
				,ConFileAs
				) (
				SELECT CM.Id
				,CM.ConFullName
				,CM.ConJobTitle
				,CM.ConFileAs FROM CONTC000Master CM WHERE CM.ConCompanyId = @CompanyID
				AND CM.ConOrgId = 1
				AND CM.StatusId IN (
					1
					,2
					)
				)
		END
		ELSE IF (
				@RoleTypeName = 'Vendor'
				OR @RoleTypeName = 'Driver'
				) --Vendor
		BEGIN
			INSERT INTO #contactComboTable (
				Id
				,ConFullName
				,ConJobTitle
				,ConFileAs
				) (
				SELECT CM.Id
				,CM.ConFullName
				,CM.ConJobTitle
				,CM.ConFileAs FROM CONTC000Master CM WHERE CM.ConOrgId = 1
				AND CM.ConCompanyId IN (
					SELECT ID
					FROM COMP000Master
					WHERE CompTableName = 'VENDOR'
						AND CompPrimaryRecordId IN (
							SELECT DISTINCT PVLVENDORID
							FROM PRGRM051VendorLocations
							WHERE PVLPROGRAMID = @parentid
								AND STATUSID IN (
									1
									,2
									)
							)
					)
				AND CM.StatusId IN (
					1
					,2
					)
				AND CM.ID NOT IN (
					SELECT ISNULL(PrgRoleContactID, 0)
					FROM PRGRM020Program_Role
					WHERE ProgramID = @parentid
						AND StatusId IN (
							1
							,2
							)
					)
				)
		END
		ELSE
		BEGIN --Organization
			INSERT INTO #contactComboTable (
				Id
				,ConFullName
				,ConJobTitle
				,ConFileAs
				) (
				--GET EMPLOYEE CONTACT OF ORGANIZATION PASSED AS @ORGID. 
				SELECT contact.Id
				,contact.ConFullName
				,contact.ConJobTitle
				,contact.ConFileAs FROM [dbo].CONTC000Master contact INNER JOIN COMP000Master CM ON contact.ConCompanyId = CM.ID WHERE contact.ConOrgId = @orgId
				AND CM.CompCode = 'MWWTG'
				AND ISNULL(contact.StatusId, 1) <> 3
				AND contact.Id NOT IN (
					SELECT ISNULL(PrgRoleContactID, 0)
					FROM PRGRM020Program_Role
					WHERE ProgramID = @parentId
						AND StatusId IN (
							1
							,2
							)
					)
				)
		END

		SET @where = ''
	END
	ELSE IF @entityFor = 'PPPRespGateway'
	BEGIN
		-- Gateway Responsible
		INSERT INTO #contactComboTable (
			Id
			,ConFullName
			,ConJobTitle
			,ConFileAs
			) (
			SELECT contact.Id
			,contact.ConFullName
			,contact.ConJobTitle
			,contact.ConFileAs FROM CONTC000Master contact 
			INNER JOIN [dbo].[PRGRM020Program_Role] pgContact ON pgContact.[PrgRoleContactID] = contact.Id AND pgContact.StatusId IN (1,2)
			INNER JOIN PRGRM000Master pgm ON pgm.Id = pgContact.ProgramID WHERE pgContact.ProgramID = 20099
			AND contact.StatusId IN (
				1
				,2
				)
			AND contact.ConOrgId = 1
			)
	END
	ELSE IF @entityFor = 'PPPAnalystGateway'
	BEGIN
		-- Gateway Analyst
		INSERT INTO #contactComboTable (
			Id
			,ConFullName
			,ConJobTitle
			,ConFileAs
			) (
			SELECT contact.Id
			,contact.ConFullName
			,contact.ConJobTitle
			,contact.ConFileAs FROM CONTC000Master contact 
			INNER JOIN [dbo].[PRGRM020Program_Role] pgContact ON pgContact.[PrgRoleContactID] = contact.Id AND pgContact.StatusId IN (1,2)
			INNER JOIN PRGRM000Master pgm ON pgm.Id = pgContact.ProgramID WHERE pgContact.ProgramID = @parentId
			AND contact.StatusId IN (
				1
				,2
				)
			AND contact.ConOrgId = @orgId
			--AND pgContact.PrxJobGWDefaultAnalyst = 1
			)
	END
	ELSE IF @entityFor = 'PPPJobRespContact'
	BEGIN
		INSERT INTO #contactComboTable (
			Id
			,ConFullName
			,ConJobTitle
			,ConFileAs
			)
		EXEC [dbo].[GetJobResponsibleComboboxContacts] @orgId
			,@parentId
	END
	ELSE IF @entityFor = 'PPPJobAnalystContact'
	BEGIN
		INSERT INTO #contactComboTable (
			Id
			,ConFullName
			,ConJobTitle
			,ConFileAs
			)
		EXEC [dbo].[GetJobAnalystComboboxContacts] @orgId
			,@parentId
	END

	--find new page no
	IF (ISNULL(@primaryKeyValue, '') <> '')
	BEGIN
		IF NOT EXISTS (
				SELECT Id
				FROM #contactComboTable
				WHERE Id = @primaryKeyValue
				)
		BEGIN
			INSERT INTO #contactComboTable (
				Id
				,ConFullName
				,ConJobTitle
				,ConFileAs
				)
			SELECT contact.Id
				,contact.ConFullName
				,contact.ConJobTitle
				,contact.ConFileAs
			FROM [dbo].CONTC000Master contact
			WHERE contact.Id = @primaryKeyValue
				AND contact.ConOrgId = @orgId;
		END

		DECLARE @newPgNo INT

		SELECT @newPgNo = Item
		FROM (
			SELECT ROW_NUMBER() OVER (
					ORDER BY Contact.Id
					) AS Item
				,Contact.Id
			FROM #contactComboTable Contact
			) t
		WHERE t.Id = @primaryKeyValue

		IF @newPgNo IS NOT NULL
		BEGIN
			SET @newPgNo = @newPgNo / @pageSize + 1;
			SET @pageSize = @newPgNo * @pageSize;
		END
	END

	DECLARE @sqlCommand NVARCHAR(MAX) = 'SELECT  * FROM  #contactComboTable ' + @entity + ' WHERE 1=1 '

	--Apply Like Statement
	IF (ISNULL(@like, '') != '')
	BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ('

		DECLARE @likeStmt NVARCHAR(MAX)

		SELECT @likeStmt = COALESCE(@likeStmt + ' OR ', '') + Item + ' LIKE ''%' + @like + '%' + ''''
		FROM [dbo].[fnSplitString](@fields, ',')

		SET @sqlCommand = @sqlCommand + @likeStmt + ') '
	END

	-- Apply Where condition
	IF (ISNULL(@where, '') != '')
	BEGIN
		SET @sqlCommand = @sqlCommand + @where
	END

	--Apply Ordering AND paged Data
	SET @sqlCommand = @sqlCommand + ' ORDER BY ' + @fields + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'

	EXEC sp_executesql @sqlCommand
		,N'@pageNo INT, @pageSize INT, @where NVARCHAR(100)'
		,@pageNo = @pageNo
		,@pageSize = @pageSize
		,@where = @where
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
