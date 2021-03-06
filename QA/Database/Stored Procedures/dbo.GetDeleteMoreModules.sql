SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara         
-- Create date:               05/25/2018      
-- Description:               Get all referenced modules  by id
-- Execution:                [dbo].[GetDeleteInfoModules] 1,14,1,'job',0
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE [dbo].[GetDeleteMoreModules] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@recordId BIGINT
AS
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @TblTableName VARCHAR(50)
	SELECT @TblTableName=TblTableName  FROM [SYSTM000Ref_Table] WHERE SysRefName=@entity
 
	DECLARE @ReferenceTable TABLE (
		PrimaryId INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED
		,ReferenceEntity NVARCHAR(50)
		,ParentEntity NVARCHAR(50)
		,ReferenceTableName NVARCHAR(100)
		,RefernceColumnName NVARCHAR(100)
		);

	INSERT INTO @ReferenceTable (
		referenceEntity
		,parentEntity
		,referenceTableName
		,refernceColumnName
		)
	SELECT (
			SELECT TOP 1 SysRefName
			FROM [dbo].[SYSTM000Ref_Table]
			WHERE TblTableName = sys.sysobjects.name
			) AS [Entity]
		,sys.sysobjects.name AS TableName
		,@entity AS ParentTableName
		,(
			SELECT COLUMN_NAME
			FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
			WHERE CONSTRAINT_NAME = sys.foreign_keys.name
			) AS ColumnName
	FROM sys.foreign_keys
	INNER JOIN sys.sysobjects ON sys.foreign_keys.parent_object_id = sys.sysobjects.id
	INNER JOIN [dbo].[SYSTM000Ref_Table] refTable ON OBJECT_ID(refTable.TblTableName) = referenced_object_id
	--INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS FK  ON FK.CONSTRAINT_NAME = sys.sysobjects.name
	WHERE refTable.SysRefName = @entity 

		SELECT DISTINCT CASE WHEN ReferenceEntity='PrgBillableRate' THEN 'Program Billable Rate' 
				 WHEN ReferenceEntity='PrgCostRate' THEN 'Program Cost Rate'
				 WHEN ReferenceEntity='PrgBillableLocation' THEN 'Program Billable Location'
				 WHEN ReferenceEntity='PrgCostLocation' THEN 'Program Cost Location'
			     WHEN ReferenceEntity ='CustDcLocation' THEN 'Customer DC Location' 
				 WHEN ReferenceEntity='JobGateway' THEN 'Job Gateway'
			     WHEN ReferenceEntity ='OrgRefRole' THEN 'Organization Reference Role' 
				 WHEN ReferenceEntity='PrgRefGatewayDefault' THEN 'Program Reference Gateway'
			     WHEN ReferenceEntity ='PrgRole' THEN 'Program Role' 
				 WHEN ReferenceEntity='PrgVendLocation' THEN 'Program Vendor Location'
			     WHEN ReferenceEntity ='VendDcLocation' THEN 'Vendor DC Location'  
				 WHEN ReferenceEntity='CustBusinessTerm' THEN 'Customer Business Term'
				 WHEN ReferenceEntity ='VendBusinessTerm' THEN 'Vendor Business Term'  
				 WHEN ReferenceEntity='CustDocReference' THEN 'Customer Document Reference'
				 WHEN ReferenceEntity='VendDocReference' THEN 'Vendor Document Reference'
				 WHEN ReferenceEntity='CustFinancialCalendar' THEN 'Customer Financial Calendar'
				 WHEN ReferenceEntity='VendFinancialCalendar' THEN 'Vendor Financial Calendar'
				 WHEN ReferenceEntity='JobCostSheet' THEN 'Job Cost Sheet'
				 WHEN ReferenceEntity ='JobBillableSheet' THEN 'Job Billable Sheet'
				 WHEN ReferenceEntity = 'SecurityByRole' THEN 'Security By Role'
				 WHEN ReferenceEntity = 'JobAttribute' THEN 'Job Attribute'
				 WHEN ReferenceEntity = 'JobCargo' THEN 'Job Cargo'
				 WHEN ReferenceEntity = 'JobDocReference' THEN 'Job Document Reference'
				 ELSE ReferenceEntity END SysRefDisplayName, ReferenceEntity SysRefName  FROM @ReferenceTable
				 WHERE ReferenceEntity NOT IN (@entity,'ContactBridge','StatusLog','JobAdvanceReport',
				 'JobRefCostSheet','JobRefStatus','JobCard','JobHistory','JobXcblInfo')
	UNION ALL 
	SELECT  CASE WHEN SysRefName='PrgBillableRate' THEN 'Program Billable Rate' 
				 WHEN SysRefName= 'PrgCostRate' THEN 'Program Cost Rate'
				 WHEN SysRefName='PrgBillableLocation' THEN 'Program Billable Location'
				 WHEN SysRefName='PrgCostLocation' THEN 'Program Cost Location'
			     WHEN SysRefName ='CustDcLocation' THEN 'Customer DC Location' 
				 WHEN SysRefName='JobGateway' THEN 'Job Gateway'
			     WHEN SysRefName ='OrgRefRole' THEN 'Organization Reference Role' 
				 WHEN SysRefName='PrgRefGatewayDefault' THEN 'Program Reference Gateway'
			     WHEN SysRefName ='PrgRole' THEN 'Program Role' 
				 WHEN SysRefName='PrgVendLocation' THEN 'Program Vendor Location'
			     WHEN SysRefName ='VendDcLocation' THEN 'Vendor DC Location'  
				 WHEN SysRefName='CustBusinessTerm' THEN 'Customer Business Term'
				 WHEN SysRefName ='VendBusinessTerm' THEN 'Vendor Business Term'  
				 WHEN SysRefName='CustDocReference' THEN 'Customer Document Reference'
				 WHEN SysRefName='VendDocReference' THEN 'Vendor Document Reference'
				 WHEN SysRefName='CustFinancialCalendar' THEN 'Customer Financial Calendar'
				 WHEN SysRefName='VendFinancialCalendar' THEN 'Vendor Financial Calendar'
				 WHEN SysRefName='JobCostSheet' THEN 'Job Cost Sheet'
				 WHEN SysRefName='JobBillableSheet' THEN 'Job Billable Sheet'
				 WHEN SysRefName = 'SecurityByRole' THEN 'Security By Role'
				 WHEN SysRefName= 'JobAttribute' THEN 'Job Attribute'
				 WHEN SysRefName= 'JobCargo' THEN 'Job Cargo'
				 WHEN SysRefName= 'JobDocReference' THEN 'Job Document Reference'
				 ELSE SysRefName END SysRefDisplayName, SysRefName FROM [dbo].[SYSTM000Ref_Table] 
				 WHERE TblTableName=@TblTableName 
				 AND SysRefName NOT IN (@entity,'ContactBridge','OrgRolesResp','StatusLog','JobAdvanceReport','JobRefCostSheet',
				 'JobRefStatus','JobCard','JobHistory','JobXcblInfo')

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
