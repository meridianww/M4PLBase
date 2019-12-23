SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal Adhikary
-- Create date:               23/12/2019     
-- Description:               Get Max,min Record by Entity
-- Execution:                 EXEC GetMaxMinRecordByEntity 'DeliveryStatus',60286,1,513127
-- Modified on:  
-- Modified Desc:  
-- =============================================
/****** Object:  StoredProcedure [dbo].[GetMaxMinRecordByEntity]    Script Date: 12/22/2019 3:10:05 PM ******/
ALTER PROCEDURE [dbo].[GetMaxMinRecordByEntity] @entity NVARCHAR(100)
	,@recordID NVARCHAR(30)
	,@OrgId NVARCHAR(30)
	,@ID NVARCHAR(30)
AS
BEGIN
	DECLARE @TableName NVARCHAR(MAX)
	DECLARE @sqlCommand NVARCHAR(MAX)
	DECLARE @OrgByEntity NVARCHAR(30)
	DECLARE @ParentParam NVARCHAR(30)
	DECLARE @OptionalQry NVARCHAR(MAX)

	SET @OptionalQry = '';
	SET @OrgByEntity = '';
	
	SELECT @TableName = TblTableName
	FROM SYSTM000Ref_Table
	WHERE SysRefName = @entity

	IF (@entity = 'OrgRefRole')
	BEGIN
		SET @OrgByEntity = 'OrgID'
	END

	IF (@entity = 'contact')
	BEGIN
		SET @OrgByEntity = 'ConorgID'
	END
	ELSE IF (@entity = 'vendor')
	BEGIN
		SET @OrgByEntity = 'VendorgID'
	END
	ELSE IF (@entity = 'customer')
	BEGIN
		SET @OrgByEntity = 'CustorgID'
	END
	ELSE IF (
			@entity = 'vendcontact'
			OR @entity = 'custcontact'
			)
	BEGIN
		SET @OrgByEntity = 'ConorgID'
	END
	ELSE IF (@entity = 'VendDcLocation')
	BEGIN
		SET @ParentParam = 'VdcVendorID'
	END
	ELSE IF (@entity = 'CustDcLocation')
	BEGIN
		SET @ParentParam = 'CdcCustomerID'
	END
	ELSE IF (@entity = 'VendDcLocationContact')
	BEGIN
		SET @OrgByEntity = 'CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'CustDcLocationContact')
	BEGIN
		SET @OrgByEntity = 'CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'VendFinancialCalendar')
	BEGIN
		SET @ParentParam = 'VendID'
		SET @OptionalQry = ' AND OrgId = CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'CustFinancialCalendar')
	BEGIN
		SET @ParentParam = 'CustID'
		SET @OptionalQry = ' AND OrgId = CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'VendBusinessTerm')
	BEGIN
		SET @ParentParam = 'VbtVendorID'
		SET @OptionalQry = ' AND VbtOrgID = CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'CustBusinessTerm')
	BEGIN
		SET @ParentParam = 'CbtCustomerId'
		SET @OptionalQry = ' AND CbtOrgID = CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'VendDocReference')
	BEGIN
		SET @ParentParam = 'VdrVendorID'
		SET @OptionalQry = ' AND VdrOrgID = CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'CustDocReference')
	BEGIN
		SET @ParentParam = 'CdrCustomerId'
		SET @OptionalQry = ' AND CdrOrgID = CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'PrgRefGatewayDefault')
	BEGIN
		SET @ParentParam = 'PgdProgramID'
	END
	ELSE IF (@entity = 'PrgRole')
	BEGIN
		SET @ParentParam = 'ProgramID'
		SET @OptionalQry = ' AND OrgID  = CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'PrgBillableRate')
	BEGIN
		SET @OrgByEntity = 'CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'PrgCostRate')
	BEGIN
		SET @OrgByEntity = 'CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'PrgShipStatusReasonCode')
	BEGIN
		SET @ParentParam = 'PscProgramID'
		SET @OptionalQry = ' AND PscOrgID = CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'PrgShipApptmtReasonCode')
	BEGIN
		SET @ParentParam = 'PacProgramID'
		SET @OptionalQry = ' AND PacOrgID = CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'PrgRefAttributeDefault')
	BEGIN
		SET @ParentParam = 'ProgramID'
	END
	ELSE IF (@entity = 'ScrCatalogList')
	BEGIN
		SET @ParentParam = 'CatalogProgramID'
	END
	ELSE IF (@entity = 'PrgMvoc')
	BEGIN
		SET @ParentParam = 'VocProgramID'
		SET @OptionalQry = ' AND VocOrgID = CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'PrgMvocRefQuestion')
	BEGIN
		SET @ParentParam = 'MVOCID'
	END
	ELSE IF (@entity = 'PrgVendLocation')
	BEGIN
		SET @ParentParam = 'PvlProgramID'
	END
	ELSE IF (@entity = 'Job')
	BEGIN
		SET @ParentParam = 'ProgramID'
	END
	ELSE IF (
			@entity = 'JobBillableSheet'
			OR @entity = 'JobCostSheet'
			)
	BEGIN
		SET @ParentParam = 'JobID'
	END
	ELSE IF (@entity = 'JobDocReference')
	BEGIN
		SET @ParentParam = 'JobID'
		SET @OptionalQry = ' AND DocTypeId = (SELECT DocTypeId FROM ' + @TableName + ' WHERE ID = CAST(' + @ID + ' AS BIGINT)) '
	END
	ELSE IF (@entity = 'JobCargo')
	BEGIN
		SET @ParentParam = 'JobID' 
	END
	ELSE IF (@entity = 'JobGateway')
	BEGIN
		SET @ParentParam = 'JobID'
		SET @OptionalQry = ' AND GatewayTypeId = (SELECT GatewayTypeId FROM ' + @TableName + ' WHERE ID = CAST(' + @ID + ' AS BIGINT)) ' 
	END
	ELSE IF (@entity = 'MenuDriver' OR @entity = 'SystemMessage' OR @entity = 'MessageType')
	BEGIN
		SET @OrgByEntity = 'CAST(' + @OrgId + ' AS BIGINT)'
	END 
	ELSE IF (@entity = 'SystemReference' OR @entity = 'SystemPageTabName')
	BEGIN
		SET @OrgByEntity = 'CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'SystemAccount')
	BEGIN
		SET @OptionalQry = ' AND SysOrgID = CAST(' + @OrgId + ' AS BIGINT)'
	END 
	ELSE IF (@entity = 'Validation')
	BEGIN 
		SET @OrgByEntity = 'CAST(' + @OrgId + ' AS BIGINT)'
	END
	ELSE IF (@entity = 'DeliveryStatus')
	BEGIN
		SET @OrgByEntity = 'OrganizationId' 
	END

		IF (
			@entity = 'vendcontact'
			OR @entity = 'custcontact'
			)
	BEGIN
		SET @sqlCommand = 'SELECT MAX(Id) maxID,MIN(Id) minID FROM ' + @TableName + ' WHERE ConPrimaryRecordId = CAST(' + @recordID + ' AS BIGINT) AND ' + @OrgByEntity + ' =1 AND StatusID = 1 AND ConTableName = ''' + @entity + ''''
		 	END
	ELSE IF (
			@entity = 'VendDcLocation'
			OR @entity = 'CustDcLocation'
			OR @entity = 'CustFinancialCalendar'
			OR @entity = 'VendFinancialCalendar'
			OR @entity = 'VendBusinessTerm'
			OR @entity = 'CustBusinessTerm'
			OR @entity = 'VendDocReference'
			OR @entity = 'CustDocReference'
			OR @entity = 'PrgRefGatewayDefault'
			OR @entity = 'PrgRole'
			OR @entity = 'PrgShipStatusReasonCode'
			OR @entity = 'PrgShipApptmtReasonCode'
			OR @entity = 'PrgRefAttributeDefault'
			OR @entity = 'ScrCatalogList'
			OR @entity = 'PrgMvoc'
			OR @entity = 'PrgMvocRefQuestion'
			OR @entity = 'PrgVendLocation'
			OR @entity = 'Job'
			OR @entity = 'JobBillableSheet'
			OR @entity = 'JobCostSheet'
			OR @entity = 'JobDocReference'
			OR @entity = 'JobCargo'
			OR @entity = 'JobGateway'
			)
	BEGIN
		SET @sqlCommand = 'SELECT MAX(Id) maxID,MIN(Id) minID FROM ' + @TableName + ' WHERE ' + @ParentParam + ' = CAST(' + @recordID + ' AS BIGINT) AND StatusID IN(1,194)' + @OptionalQry
	END
	ELSE IF (@entity = 'OrgRefRole' OR @entity = 'DeliveryStatus')
	BEGIN
		SET @sqlCommand = 'SELECT MAX(Id) maxID,MIN(Id) minID FROM ' + @TableName + ' WHERE ' + @OrgByEntity + ' = 1'
	END
	ELSE IF (@entity = 'MessageType')
	BEGIN
		SET @sqlCommand = 'SELECT MAX(SysMsg.Id) maxID,MIN(SysMsg.Id) minID FROM ' + @TableName + ' SysMsg INNER JOIN SYSTM000Ref_Options (NOLOCK) ref ON SysMsg.SysRefId = ref.Id WHERE  ref.SysLookupId=27 AND SysMsg.StatusID = 1' 
	END
	ELSE IF (@entity = 'SystemAccount')
	BEGIN
		SET @sqlCommand = 'SELECT MAX(Id) maxID,MIN(Id) minID FROM ' + @TableName + ' WHERE StatusId =1  ' + @OptionalQry
	END
	ELSE
	BEGIN
		SET @sqlCommand = 'SELECT MAX(Id) maxID,MIN(Id) minID FROM ' + @TableName + ' WHERE ' + @OrgByEntity + ' = 1 AND StatusID = 1'
	END 
	PRINT @sqlCommand
	EXECUTE sp_executesql @sqlCommand
END