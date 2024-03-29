SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDeleteInfoModules] 
	@userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	,@recordId BIGINT
AS
BEGIN TRY
	SET NOCOUNT ON;

	IF(ISNULL(@entity,'') <> 'Contact')
	BEGIN
	  exec [dbo].[GetDeleteMoreModules] @userId,@roleId,@orgId,@entity,@recordId
	END
	ELSE
	BEGIN
	DECLARE @ReferenceTable TABLE (
		PrimaryId INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED
		,ReferenceEntity NVARCHAR(50)
		,ParentEntity NVARCHAR(50)
		,ReferenceTableName NVARCHAR(100)
		,ReferenceColumnName NVARCHAR(100)
		);

	INSERT INTO @ReferenceTable (
		referenceEntity
		,parentEntity
		,referenceTableName
		,ReferenceColumnName
		)
	SELECT (
			SELECT TOP 1 SysRefName
			FROM [dbo].[SYSTM000Ref_Table]
			WHERE TblTableName = SO.name AND SysRefName <> 'ContactBridge'
			) AS [Entity]
		,SO.name AS TableName
		,@entity AS ParentTableName
		,(
			SELECT COLUMN_NAME
			FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
			WHERE CONSTRAINT_NAME = FK.name
			) AS ColumnName
	FROM sys.foreign_keys FK
	INNER JOIN sys.sysobjects SO ON FK.parent_object_id = SO.id
	INNER JOIN [dbo].[SYSTM000Ref_Table] refTable ON OBJECT_ID(refTable.TblTableName) = referenced_object_id
	WHERE refTable.SysRefName = @entity
  

	SELECT DISTINCT CASE WHEN ReferenceEntity='CustContact' THEN 'Customer Contact'
			     WHEN ReferenceEntity ='CustDcLocation' THEN 'Customer DC Location' 
				 WHEN ReferenceEntity='JobGateway' THEN 'Job Gateway'
			     WHEN ReferenceEntity ='OrgRefRole' THEN 'Organization Reference Role' 
				 WHEN ReferenceEntity='PrgRefGatewayDefault' THEN 'Program Reference Gateway'
			     WHEN ReferenceEntity ='PrgRole' THEN 'Program Role' 
				 WHEN ReferenceEntity='PrgVendLocation' THEN 'Program Vendor Location'
			     WHEN ReferenceEntity ='VendDcLocation' THEN 'Vendor DC Location' 
				 WHEN ReferenceEntity ='CustDcLocationContact' THEN 'Customer DC Location Contact' 
				 WHEN ReferenceEntity='OrgPocContact' THEN 'Organization POC Contact'
			     WHEN ReferenceEntity ='VendContact' THEN 'Vendor Contact' 
				 WHEN ReferenceEntity='VendDcLocationContact' THEN 'Vendor DC Location Contact' 
				 ELSE ReferenceEntity END SysRefDisplayName, ReferenceEntity SysRefName  FROM @ReferenceTable
	UNION ALL 
	SELECT  CASE WHEN SysRefName='CustContact' THEN 'Customer Contact'
			     WHEN SysRefName ='CustDcLocation' THEN 'Customer DC Location' 
				 WHEN SysRefName='JobGateway' THEN 'Job Gateway'
			     WHEN SysRefName ='OrgRefRole' THEN 'Organization Reference Role' 
				 WHEN SysRefName='PrgRefGatewayDefault' THEN 'Program Reference Gateway'
			     WHEN SysRefName ='PrgRole' THEN 'Program Role' 
				 WHEN SysRefName='PrgVendLocation' THEN 'Program Vendor Location'
			     WHEN SysRefName ='VendDcLocation' THEN 'Vendor DC Location' 
				 WHEN SysRefName ='CustDcLocationContact' THEN 'Customer DC Location Contact' 
				 WHEN SysRefName='OrgPocContact' THEN 'Organization POC Contact'
			     WHEN SysRefName ='VendContact' THEN 'Vendor Contact' 
				 WHEN SysRefName='VendDcLocationContact' THEN 'Vendor DC Location Contact' 
				 ELSE SysRefName END SysRefDisplayName, SysRefName FROM [dbo].[SYSTM000Ref_Table]  
	WHERE SysRefName NOT IN ('ContactBridge','CustContact') AND TblTableName = 'CONTC010Bridge' 	
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
