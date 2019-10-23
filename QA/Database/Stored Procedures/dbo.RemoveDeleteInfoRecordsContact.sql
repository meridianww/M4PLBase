 

/* Copyright (2018) Meridian Worldwide Transportation Group    
   All Rights Reserved Worldwide */
-- =============================================            
-- Author:                    Janardana Behara             
-- Create date:               07/04/2018          
-- Description:               update records to archieve on delete info
-- Execution:                 EXEC [dbo].[RemoveDeleteInfoRecords]    
-- Modified on:      
-- Modified Desc:      
-- =============================================     
CREATE PROCEDURE [dbo].[RemoveDeleteInfoRecordsContact] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@parentEntity NVARCHAR(100)
	,@contains NVARCHAR(100)
	,@parentFieldName NVARCHAR(100) = NULL
	,@itemNumberField NVARCHAR(100) = NULL
AS
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @tableName NVARCHAR(100)

	SELECT @tableName = TblTableName
	FROM [dbo].[SYSTM000Ref_Table]
	WHERE SysRefName = @entity

	DECLARE @query NVARCHAR(MAX)
	DECLARE @whereQuery NVARCHAR(MAX)
	Select CAST(Item AS BIGINT) ContactId INTO #ContactId  From [dbo].[fnSplitString](@contains, ',')
	UPDATE dbo.CONTC010Bridge SET StatusId = 3, ContactMSTRID= NULL WHERE [ConTableName] = @entity AND ContactMSTRID IN (Select ContactId From #ContactId)

	IF (ISNULL(@entity, '') = 'CustDcLocation')
	BEGIN
		UPDATE [dbo].[CUST040DCLocations]
		SET CdcContactMSTRID = NULL
		WHERE CdcContactMSTRID IN (Select ContactId From #ContactId)
	END
	ELSE IF (ISNULL(@entity, '') = 'Customer')
	BEGIN
		UPDATE dbo.[CUST000Master]
		SET CustBusinessAddressId = NULL
		WHERE CustBusinessAddressId IN (Select ContactId From #ContactId)

		UPDATE dbo.[CUST000Master]
		SET CustCorporateAddressId = NULL
		WHERE CustCorporateAddressId IN (Select ContactId From #ContactId)

		UPDATE dbo.[CUST000Master]
		SET CustWorkAddressId = NULL
		WHERE CustWorkAddressId IN (Select ContactId From #ContactId)
	END
	ELSE IF (ISNULL(@entity, '') = 'Vendor')
	BEGIN
		UPDATE dbo.VEND000Master
		SET VendBusinessAddressId = NULL
		WHERE VendBusinessAddressId IN (Select ContactId From #ContactId)

		UPDATE dbo.VEND000Master
		SET VendCorporateAddressId = NULL
		WHERE VendCorporateAddressId IN (Select ContactId From #ContactId)

		UPDATE dbo.VEND000Master
		SET VendWorkAddressId = NULL
		WHERE VendWorkAddressId IN (Select ContactId From #ContactId)
	END
	ELSE IF (ISNULL(@entity, '') = 'VendDCLocation')
	BEGIN
		UPDATE [dbo].[VEND040DCLocations]
		SET VdcContactMSTRID = NULL
		WHERE VdcContactMSTRID IN (Select ContactId From #ContactId)
	END
	ELSE IF (ISNULL(@entity, '') = 'Organization')
	BEGIN
		UPDATE dbo.ORGAN000Master
		SET OrgBusinessAddressId = NULL
		WHERE OrgBusinessAddressId IN (Select ContactId From #ContactId)

		UPDATE dbo.ORGAN000Master
		SET OrgCorporateAddressId = NULL
		WHERE OrgCorporateAddressId IN (Select ContactId From #ContactId)

		UPDATE dbo.ORGAN000Master
		SET OrgWorkAddressId = NULL
		WHERE OrgWorkAddressId IN (Select ContactId From #ContactId)
	END
	ELSE IF (ISNULL(@entity, '') = 'OrgRefRole')
	BEGIN
		UPDATE [ORGAN010Ref_Roles]
		SET OrgRoleContactID = NULL
		WHERE OrgRoleContactID IN (Select ContactId From #ContactId)
	END
	ELSE IF (ISNULL(@entity, '') = 'PrgRole')
	BEGIN
		UPDATE [dbo].[PRGRM020Program_Role]
		SET PrgRoleContactID = NULL
		WHERE PrgRoleContactID IN (Select ContactId From #ContactId)
	END
	ELSE IF (ISNULL(@entity, '') = 'PrgVendLocation')
	BEGIN
		UPDATE [PRGRM051VendorLocations]
		SET PvlContactMSTRID = NULL
		WHERE PvlContactMSTRID IN (Select ContactId From #ContactId)
	END
	ELSE IF (ISNULL(@entity, '') = 'PrgRefGatewayDefault')
	BEGIN
		UPDATE [dbo].[PRGRM010Ref_GatewayDefaults]
		SET [PgdGatewayResponsible] = NULL
		WHERE [PgdGatewayResponsible] IN (Select ContactId From #ContactId)

		UPDATE [dbo].[PRGRM010Ref_GatewayDefaults]
		SET [PgdGatewayAnalyst] = NULL
		WHERE [PgdGatewayAnalyst] IN (Select ContactId From #ContactId)
	END
	ELSE IF (ISNULL(@entity, '') = 'Job')
	BEGIN
		UPDATE JOBDL000Master
		SET [JobDeliveryResponsibleContactID] = NULL
		WHERE [JobDeliveryResponsibleContactID] IN (Select ContactId From #ContactId)

		UPDATE JOBDL000Master
		SET [JobDeliveryAnalystContactID] = NULL
		WHERE [JobDeliveryAnalystContactID] IN (Select ContactId From #ContactId)

		UPDATE JOBDL000Master
		SET [JobDriverId] = NULL
		WHERE [JobDriverId] IN (Select ContactId From #ContactId)
	END
	ELSE IF (ISNULL(@entity, '') = 'JobGateway')
	BEGIN
		UPDATE [JOBDL020Gateways]
		SET GwyGatewayResponsible = NULL
		WHERE GwyGatewayResponsible IN (Select ContactId From #ContactId)

		UPDATE [JOBDL020Gateways]
		SET GwyGatewayAnalyst = NULL
		WHERE GwyGatewayAnalyst IN (Select ContactId From #ContactId)
	END
	ELSE IF (ISNULL(@entity, '') = 'Account')
	BEGIN
	UPDATE [dbo].[SYSTM000OpnSezMe]
		SET SysUserContactID = NULL
		WHERE SysUserContactID IN (Select ContactId From #ContactId)

		UPDATE dbo.CONTC010Bridge SET StatusId = 3, ContactMSTRID= NULL WHERE [ConTableName] = 'SystemAccount' AND ContactMSTRID IN (Select ContactId From #ContactId)
	END

	IF LEN(ISNULL(@itemNumberField, '')) > 0
	BEGIN
		CREATE TABLE #T1 (
			PrimaryId INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED
			,ParentId BIGINT
			);

		SET @whereQuery = ' INSERT INTO  #T1 (ParentId) select DISTINCT ' + @parentFieldName + ' from  ' + @tableName + ' WHERE ' + @whereQuery

		SELECT @whereQuery

		EXEC sp_executesql @whereQuery

		DECLARE @leastIdRowNo INT = 1
		DECLARE @InsideWhere NVARCHAR(MAX)

		WHILE EXISTS (
				SELECT *
				FROM #T1
				WHERE PrimaryId = @leastIdRowNo
				)
		BEGIN
			DECLARE @parId BIGINT;

			SELECT @parId = ParentId
			FROM #T1
			WHERE PrimaryId = @leastIdRowNo

			SET @InsideWhere = ' AND ' + @parentFieldName + ' = ' + CAST(@parId AS VARCHAR);

			EXEC UpdateItemNumberAfterDelete @entity
				,@contains
				,@itemNumberField
				,@InsideWhere

			SET @leastIdRowNo = @leastIdRowNo + 1;
		END

		DROP TABLE #T1
	END
	DROP TABLE #ContactId
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
