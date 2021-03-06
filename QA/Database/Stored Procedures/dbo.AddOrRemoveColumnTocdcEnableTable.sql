SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================                
-- Author:                    Prashant Aggarwal                
-- Create date:               07/17/2020              
-- Description:               AddOrRemoveColumnTocdcEnableTable            
-- Execution:                 EXEC [dbo].[AddOrRemoveColumnTocdcEnableTable] 'dbo','JobDL010Cargo','Test','DROP'             
-- =============================================   
CREATE PROCEDURE [dbo].[AddOrRemoveColumnTocdcEnableTable] @pSchemaName VARCHAR(50)
	,@pTableName VARCHAR(100)
	,@pColumnName VARCHAR(100)
	,@pAction VARCHAR(10)
AS
BEGIN
	DECLARE @vSQLTempTable NVARCHAR(MAX)
	DECLARE @vSQLAlterTable NVARCHAR(MAX)
	DECLARE @vDisableCDC NVARCHAR(MAX)
	DECLARE @vGetAlreadyExistingColumns NVARCHAR(MAX)
	DECLARE @vEnableCDC NVARCHAR(MAX)
	DECLARE @vLoadCDCTable NVARCHAR(MAX)
	DECLARE @vDropCreateTemp NVARCHAR(MAX)
	DECLARE @vDataType VARCHAR(50)
	DECLARE @vColumnList NVARCHAR(2000)
	DECLARE @vColumnExists INT
	DECLARE @vColumnExistsCDC INT
	DECLARE @vTempTableName VARCHAR(100)
	DECLARE @vDropColumnList NVARCHAR(2000)
	DECLARE @vDropColumnListExcSys NVARCHAR(2000)

	SET @vTempTableName = '##' + @pSchemaName + '_' + @pTableName

	BEGIN TRY
		IF (
				@pAction = 'ADD'
				OR @pAction = 'Drop'
				)
		BEGIN
			--Check if Column exists for SourceTable table
			SET @vColumnExists = (
					SELECT Count(*)
					FROM INFORMATION_SCHEMA.COLUMNS
					WHERE TABLE_SCHEMA = @pSchemaName
						AND TABLE_NAME = @pTableName
						AND COLUMN_NAME = @pColumnName
					)

			IF (
					@vColumnExists = 0
					AND @pAction = 'ADD'
					)
			BEGIN
				PRINT ' COLUMN ::' + @pColumnName + ' does not exists for Source Table ::' + @pTableName + ' Please add column to Source Table to include in CDC Table.'
			END
			ELSE
			BEGIN
				PRINT ' COLUMN ::' + @pColumnName + ' exists for Source Table ::' + @pTableName + '-->Proceeding to Next Step.'
			END

			--Check if Column exists for CDC table
			IF (
					@vColumnExists != 0
					AND @pAction = 'ADD'
					)
				SET @vColumnExistsCDC = (
						SELECT Count(*)
						FROM INFORMATION_SCHEMA.COLUMNS
						WHERE TABLE_SCHEMA = 'cdc'
							AND TABLE_NAME = @pSchemaName + '_' + @pTableName + '_CT'
							AND COLUMN_NAME = @pColumnName
						)

			IF (
					@vColumnExistsCDC != 0
					AND @pAction = 'ADD'
					)
			BEGIN
				PRINT ' COLUMN ::' + @pColumnName + ' is already part of CDC Tble ::cdc.' + @pSchemaName + '_' + @pTableName + 'CT'
			END

			IF (
					@vColumnExistsCDC = 0
					AND @pAction = 'ADD'
					)
			BEGIN
				PRINT ' COLUMN ::' + @pColumnName + ' is not part of CDC Tble ::cdc.' + @pSchemaName + '_' + @pTableName + 'CT -->Proceeding to ADD this column'
			END

			--COPY EXISTING CDC TABLE TO TEMP TABLE
			--Drop Temp table before Creating/Loading IT
			SET @vDropCreateTemp = ' IF Object_id(N''tempdb..' + @vTempTableName + ''') IS NOT NULL
                    BEGIN
                        DROP TABLE ##' + @pSchemaName + '_' + @pTableName + ' END'

			PRINT @vDropCreateTemp

			EXEC (@vDropCreateTemp)

			SET @vSQLTempTable = 'SELECT * INTO ' + @vTempTableName + ' From cdc.' + @pSchemaName + '_' + @pTableName + '_CT'

			PRINT @vSQLTempTable

			EXEC (@vSQLTempTable)

			IF (
					@vColumnExistsCDC = 0
					AND @pAction = 'ADD'
					)
			BEGIN
				--ADD COLUMN TO TEMP TABLE
				SET @vDataType = (
						SELECT CASE 
								WHEN DATA_TYPE IN ('CHAR', 'varchar', 'nvarchar')
									THEN DATA_TYPE + '(' + Cast(CHARACTER_MAXIMUM_LENGTH AS VARCHAR(50)) + ')'
								WHEN Data_Type IN ('int', 'bigint', 'smallint', 'tinyint', 'money', 'bit', 'date', 'datetime')
									THEN Data_Type
								WHEN data_type IN ('numeric', 'decimal')
									THEN DATA_TYPE + '(' + Cast(Numeric_Precision_Radix AS VARCHAR(50)) + ',' + Cast(Numeric_scale AS VARCHAR(50)) + ')'
								END AS DataType
						FROM INFORMATION_SCHEMA.COLUMNS
						WHERE TABLE_NAME = @pTableName
							AND COLUMN_NAME = @pColumnName
						)
				SET @vSQLAlterTable = 'ALTER TABLE ' + @vTempTableName + ' ADD ' + @pColumnName + ' ' + @vDataType

				PRINT @vSQLAlterTable

				EXEC (@vSQLAlterTable)

				-- ENABLE CDC ON TABLE ( INCLUDING NEW COLUMN)
				IF Object_id(N'tempdb..##ColumnList') IS NOT NULL
				BEGIN
					DROP TABLE ##ColumnList
				END

				CREATE TABLE ##ColumnList (ColumnList NVARCHAR(2000))

				SET @vGetAlreadyExistingColumns = N' DECLARE @vCDCAlreadyEnabledColumns NVARCHAR(2000)
                          SELECT @vCDCAlreadyEnabledColumns = COALESCE(@vCDCAlreadyEnabledColumns+ '','', '''')
                          + QUOTENAME(COLUMN_NAME) FROM  INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=''' + @pSchemaName + '_' + @pTableName + '_' + 'CT'' AND COLUMN_NAME NOT
                                                   IN (''__$start_lsn'',
                                                   ''__$end_lsn'',
                                                   ''__$seqval'',
                                                   ''__$operation'',
                                                   ''__$update_mask'')
                                                   PRINT @vCDCAlreadyEnabledColumns
                                                   Insert into ##ColumnList values (@vCDCAlreadyEnabledColumns)'

				PRINT @vGetAlreadyExistingColumns

				EXEC (@vGetAlreadyExistingColumns)

				SELECT @vColumnList = ColumnList + ',[' + @pColumnName + ']'
				FROM ##ColumnList

				PRINT @vColumnList

				-- DISABLE CDC ON SOURCE TABLE
				SET @vDisableCDC = 'EXEC sys.sp_cdc_disable_table @source_schema=''' + @pSchemaName + ''',
         @source_name=''' + @pTableName + ''',@capture_instance=''' + @pSchemaName + '_' + @pTableName + ''''

				PRINT @vDisableCDC

				EXEC (@vDisableCDC)

				--Enable CDC
				SET @vEnableCDC = 'EXEC sys.sp_cdc_enable_table
         @source_schema=''' + @pSchemaName + ''',@source_name=''' + @pTableName + ''', @role_name=NULL, @captured_column_list= ''' + @vColumnList + ''''

				PRINT @vEnableCDC

				EXEC (@vEnableCDC)

				-- INSERT RECORD FROM Temp to CDC Table
				SET @vLoadCDCTable = ' INSERT INTO cdc.' + @pSchemaName + '_' + @pTableName + '_CT
                                      SELECT * FROM ' + @vTempTableName + ''

				--  Drop Table '+@vTempTableName+''
				PRINT @vLoadCDCTable

				EXEC (@vLoadCDCTable)
			END

			/***-------------------------------------DROP COLUMN LOGIC STARTS-----------------------------************/
			--Build Column List excluding Drop column
			IF EXISTS (
					SELECT 1
					FROM INFORMATION_SCHEMA.COLUMNS
					WHERE TABLE_SCHEMA = 'cdc'
						AND TABLE_NAME = @pSchemaName + '_' + @pTableName + '_CT'
						AND COLUMN_NAME = @pColumnName
					)
				AND @pAction = 'Drop'
			BEGIN
				SELECT @vDropColumnList = Stuff(o.COLUMNNAME, 1, 1, '')
				FROM INFORMATION_SCHEMA.COLUMNS t
				CROSS APPLY (
					SELECT ',' + Column_Name + CHAR(10) AS [text()]
					FROM INFORMATION_SCHEMA.COLUMNS c
					WHERE c.Table_Name = t.Table_Name
						AND c.COLUMN_NAME <> @pColumnName
					FOR XML PATH('')
					) o(COLUMNNAME)
				WHERE t.Table_Name = 'dbo_' + @pTableName + '_CT'

				--Get Columns without Sytem Columns 
				SELECT @vDropColumnListExcSys = Stuff(o.COLUMNNAME, 1, 1, '')
				FROM INFORMATION_SCHEMA.COLUMNS t
				CROSS APPLY (
					SELECT ',' + Column_Name + CHAR(10) AS [text()]
					FROM INFORMATION_SCHEMA.COLUMNS c
					WHERE c.Table_Name = t.Table_Name
						AND c.COLUMN_NAME <> @pColumnName
						AND C.COLUMN_NAME NOT IN ('__$start_lsn', '__$end_lsn', '__$seqval', '__$operation', '__$update_mask')
					FOR XML PATH('')
					) o(COLUMNNAME)
				WHERE t.Table_Name = 'dbo_' + @pTableName + '_CT'

				-- DISABLE CDC for Drop Column
				SET @vDisableCDC = 'EXEC sys.sp_cdc_disable_table @source_schema=''' + @pSchemaName + ''',
         @source_name=''' + @pTableName + ''',@capture_instance=''' + @pSchemaName + '_' + @pTableName + ''''

				EXEC (@vDisableCDC)

				-- ENABLE TABLE EXCLUDING GIVEN COLUMN
				SET @vEnableCDC = 'EXEC sys.sp_cdc_enable_table
         @source_schema=''' + @pSchemaName + ''',@source_name=''' + @pTableName + ''', @role_name=NULL, @captured_column_list= ''' + @vDropColumnListExcSys + ''''

				EXEC (@vEnableCDC)

				--COPY DATA FROM TEMP DATA TO CDC TABLE
				SET @vLoadCDCTable = ' INSERT INTO cdc.' + @pSchemaName + '_' + @pTableName + '_CT(' + @vDropColumnList + ')
                                      SELECT ' + @vDropColumnList + ' FROM ' + @vTempTableName + ''

				--Drop Table '+@vTempTableName+''
				EXEC (@vLoadCDCTable)
			END
		END
		ELSE
			PRINT ' ADD OR Drop are the correct actions available for this Procedure.Please provide ADD or Drop for SP Signature'
	END TRY

	BEGIN CATCH
		ROLLBACK

		PRINT ' ERROR Occured and All Transactions are rolledback.'
	END CATCH
END
GO
