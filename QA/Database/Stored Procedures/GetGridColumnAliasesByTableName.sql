/****** Object:  StoredProcedure [dbo].[GetColumnAliasesByTableName]    Script Date: 11/21/2019 5:04:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get all ColumnAliases By Table Name
-- Execution:                 EXEC [dbo].[GetColumnAliasesByTableName]   
-- Modified on:				  26th Apr 2019 (Parthiban M)
-- Modified Desc:			  Changes done for related to contact bridge implementation
-- Modified on:				  14th May 2019 (Nikhil)
-- Modified Desc:			  Updated parameter to function fnGetRefOptionsFK Line No- 205
-- =============================================     
CREATE PROCEDURE [dbo].[GetGridColumnAliasesByTableName] 
	@langCode NVARCHAR(10)
	,@tableName NVARCHAR(100)
	,@isGridSetting BIT = 0
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @columnAliasTable TABLE (
		[Id] [bigint]
		,[LangCode] [nvarchar](10)
		,[ColTableName] [nvarchar](100)
		,[ColColumnName] [nvarchar](50)
		,[ColAliasName] [nvarchar](50)
		,[ColCaption] [nvarchar](50)
		,[ColLookupId] INT
		,[ColLookupCode] [nvarchar](100)
		,[ColDescription] [nvarchar](255)
		,[ColSortOrder] [int]
		,[ColIsReadOnly] [bit]
		,[ColIsVisible] [bit]
		,[ColIsDefault] [bit]
		,[ColIsFreezed] [bit]
		,[ColIsGroupBy] [bit]
		,[DataType] [nvarchar](50)
		,[MaxLength] [int]
		,[IsRequired] [bit]
		,[RequiredMessage] [nvarchar](255)
		,[IsUnique] [bit]
		,[UniqueMessage] [nvarchar](255)
		,[HasValidation] [bit]
		,[GridLayout] [nvarchar](max)
		,[RelationalEntity] [nvarchar](100)
		,[DefaultLookup] INT
		,[DefaultLookupName] NVARCHAR(100)
		,[ColDisplayFormat] NVARCHAR(200)
		,[GlobalIsVisible] BIT
		,[ColAllowNegativeValue] BIT
		,
		--Added by Sanyogita
		[ColMask] [nvarchar](50)
		)

	SET @TableName = CASE 
			WHEN @TableName = 'Account'
				THEN 'SystemAccount'
			ELSE @TableName
			END

	DECLARE @associatedTableName NVARCHAR(100) = @tableName;

	IF EXISTS (
			SELECT 1
			FROM CONTC010Bridge
			WHERE ConTableName = @tableName
				AND ConTableName <> 'SystemAccount'
			)
	BEGIN
		SET @associatedTableName = 'ContactBridge';-- To get relation entity and type of it as NAME
	END

	INSERT INTO @columnAliasTable
	SELECT cal.[Id]
		,cal.[LangCode]
		,cal.ColTableName
		,CASE 
			WHEN ISNULL(c.name, '') = ''
				THEN cal.ColColumnName
			ELSE c.name
			END AS ColColumnName
		,CASE 
			WHEN ISNULL(cal.[ColAliasName], '') = ''
				THEN c.name
			ELSE cal.[ColAliasName]
			END AS ColAliasName
		,CASE 
			WHEN ISNULL(cal.[ColCaption], '') = ''
				THEN c.name
			ELSE cal.[ColCaption]
			END AS ColCaption
		,cal.[ColLookupId]
		,cal.[ColLookupCode]
		,CASE 
			WHEN ISNULL(cal.[ColDescription], '') = ''
				THEN c.name
			ELSE cal.[ColDescription]
			END AS ColDescription
		,cal.[ColSortOrder]
		,cal.[ColIsReadOnly]
		,cal.[ColIsVisible]
		,cal.[ColIsDefault]
		,0
		,cal.[ColIsGroupBy]
		,CASE 
			WHEN cal.ColColumnName IN (
					SELECT ColumnName
					FROM dbo.fnGetRefOptionsFK((
								CASE 
									WHEN cal.ColAssociatedTableName IS NOT NULL
										THEN cal.ColAssociatedTableName
									ELSE @associatedTableName
									END
								))
					)
				THEN 'dropdown'
			WHEN (
					cal.ColColumnName IN (
						(
							SELECT ColumnName
							FROM dbo.fnGetModuleFK(@associatedTableName)
							)
						)
					OR (
						@associatedTableName = 'ContactBridge'
						AND (
							cal.ColColumnName = 'ConPrimaryRecordId'
							OR cal.ColColumnName = 'ConCompanyId'
							OR cal.ColColumnName = 'VdcContactMSTRID'
							OR cal.ColColumnName = 'CdcContactMSTRID'
							)
						)
					)
				THEN 'name'
			ELSE CASE 
					WHEN ISNULL(t.Name, '') = ''
						THEN 'nvarchar'
					ELSE t.Name
					END
			END AS 'DataType'
		,CASE 
			WHEN c.max_length < 2
				THEN c.system_type_id
			WHEN (c.system_type_id = 231)
				THEN (c.max_length) / 2
			ELSE CASE 
					WHEN (t.name = 'ntext')
						THEN (c.max_length * 2729)
					ELSE CASE 
							WHEN ISNULL(c.max_length, '') = ''
								THEN '1000'
							ELSE (c.max_length)
							END
					END
			END AS MaxLength
		,0
		,''
		,0
		,''
		,0
		,'' AS GridLayout
		,CASE 
			WHEN @associatedTableName = 'ContactBridge'
				AND (
					cal.ColColumnName = 'ConPrimaryRecordId'
					OR cal.ColColumnName = 'ConCompanyId'
					OR cal.ColColumnName = 'VdcContactMSTRID'
					OR cal.ColColumnName = 'CdcContactMSTRID'
					)
				THEN (
						SELECT SRO.SysOptionName
						FROM SYSTM000Ref_Table SRT WITH (NOLOCK)
						INNER JOIN SYSTM000Ref_Options SRO WITH (NOLOCK) ON SRT.TblMainModuleId = SRO.Id
						WHERE SRT.SysRefName = @tableName
						)
			ELSE fgmk.RelationalEntity
			END
		,ref.Id AS DefaultLookup
		,ref.SysOptionName AS DefaultLookupName
		,cal.[ColDisplayFormat]
		,cal.[ColIsVisible] AS GlobalIsVisible
		,cal.[ColAllowNegativeValue] AS ColAllowNegativeValue
		--Added by Sanyogita
		,cal.[ColMask] AS ColMask
	FROM [dbo].[SYSTM000ColumnsAlias](NOLOCK) cal
	INNER JOIN [dbo].[SYSTM000Ref_Table](NOLOCK) tbl ON tbl.SysRefName = cal.ColTableName
	LEFT JOIN sys.columns c ON c.name = cal.ColColumnName
		AND c.object_id = OBJECT_ID(tbl.TblTableName)
	LEFT JOIN sys.types t ON c.user_type_id = t.user_type_id
	LEFT JOIN dbo.fnGetModuleFK(@associatedTableName) fgmk ON cal.ColColumnName = fgmk.ColumnName
	LEFT JOIN [dbo].[SYSTM000Ref_Options](NOLOCK) ref ON ref.SysLookupId = cal.[ColLookupId]
		AND ref.SysDefault = 1
		AND ref.StatusId < 3
	WHERE cal.[LangCode] = @langCode
		AND cal.ColTableName = @tableName
		AND ISNULL(cal.StatusId, 1) = 1
		AND (ISNULL(fgmk.RelationalEntity, '') <> 'OrgRolesResp')
		AND cal.IsGridColumn = @isGridSetting
	ORDER BY cal.ColSortOrder;

	UPDATE cal
	SET IsRequired = ISNULL(val.[ValRequired], 0)
		,RequiredMessage = ISNULL(val.[ValRequiredMessage], '')
		,IsUnique = ISNULL(val.[ValUnique], 0)
		,UniqueMessage = ISNULL(val.[ValUniqueMessage], '')
		,HasValidation = 1
	FROM @columnAliasTable cal
	INNER JOIN [dbo].[SYSTM000Validation](NOLOCK) val ON val.[ValFieldName] = cal.[ColColumnName]
		AND cal.ColTableName = val.ValTableName
	WHERE ISNULL(val.[StatusId], 1) = 1

	--update DisplayFormat from SysSettings  
	UPDATE cal
	SET [ColDisplayFormat] = (
			SELECT value
			FROM [dbo].[fnGetUserSettings](0, 0, 'System', 'SysDateFormat')
			)
	FROM @columnAliasTable cal
	WHERE cal.DataType = 'datetime2'
		AND cal.[ColDisplayFormat] IS NULL

	SELECT *
	FROM @columnAliasTable
	ORDER BY ColSortOrder
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