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
-- Execution:                 EXEC [dbo].[GetDeleteMoreModules]
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

		SELECT DISTINCT CASE WHEN ReferenceEntity='PrgCostRate' THEN 'Program Cost Rate'
				 WHEN ReferenceEntity='PrgBillableLocation' THEN 'Program Billable Location'
				 WHEN ReferenceEntity='PrgCostLocation' THEN 'Program Cost Location'
			     WHEN ReferenceEntity ='CustDcLocation' THEN 'Customer DC Location' 
				 WHEN ReferenceEntity='JobGateway' THEN 'Job Gateway'
			     WHEN ReferenceEntity ='OrgRefRole' THEN 'Organization Reference Role' 
				 WHEN ReferenceEntity='PrgRefGatewayDefault' THEN 'Program Reference Gateway'
			     WHEN ReferenceEntity ='PrgRole' THEN 'Program Role' 
				 WHEN ReferenceEntity='PrgVendLocation' THEN 'Program Vendor Location'
			     WHEN ReferenceEntity ='VendDcLocation' THEN 'Vendor DC Location'  
				 ELSE ReferenceEntity END SysRefDisplayName, ReferenceEntity SysRefName  FROM @ReferenceTable
				 WHERE ReferenceEntity NOT IN ('CustBusinessTerm','CustDocReference','CustFinancialCalendar',
				 'VendBusinessTerm','VendDocReference','VendFinancialCalendar','Vendor','Customer')
	UNION ALL 
	SELECT  CASE WHEN SysRefName= 'PrgCostRate' THEN 'Program Cost Rate'
				 WHEN SysRefName='PrgBillableLocation' THEN 'Program Billable Location'
				 WHEN SysRefName='PrgCostLocation' THEN 'Program Cost Location'
			     WHEN SysRefName ='CustDcLocation' THEN 'Customer DC Location' 
				 WHEN SysRefName='JobGateway' THEN 'Job Gateway'
			     WHEN SysRefName ='OrgRefRole' THEN 'Organization Reference Role' 
				 WHEN SysRefName='PrgRefGatewayDefault' THEN 'Program Reference Gateway'
			     WHEN SysRefName ='PrgRole' THEN 'Program Role' 
				 WHEN SysRefName='PrgVendLocation' THEN 'Program Vendor Location'
			     WHEN SysRefName ='VendDcLocation' THEN 'Vendor DC Location'  
				 ELSE SysRefName END SysRefDisplayName, SysRefName FROM [dbo].[SYSTM000Ref_Table] 
				 WHERE TblTableName=@TblTableName 
				 AND SysRefName NOT IN ('CustBusinessTerm','CustDocReference','CustFinancialCalendar',
				 'VendBusinessTerm','VendDocReference','VendFinancialCalendar','Vendor','Customer')

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
