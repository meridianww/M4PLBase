SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[audit_Changes] (
@Datefrom VARCHAR(10) = '2020-08-08'
,@DateTo VARCHAR(10) = '2020-08-14'
,@Database VARCHAR(255) = 'M4PL_Production'
,@table VARCHAR(255) = 'JobDL000Master'
)
AS
BEGIN

DECLARE @CaseStatement NVARCHAR(Max)
DECLARE @ColumnList NVARCHAR(Max)
DECLARE @SQL NVARCHAR(Max)
DECLARE @ParamDefinition AS NVARCHAR(Max)

SET @CaseStatement = ''
SET @ColumnList = ''

SELECT @CaseStatement = @CaseStatement + 'CASE WHEN (sys.fn_cdc_is_bit_set (sys.fn_cdc_get_column_ordinal (''dbo_' + @Table + ''',''' + Column_Name + '''),__$update_mask) = 1) THEN CAST(' + Column_name + ' as sql_variant) ELSE NULL END AS ' + Column_name + ','
FROM information_schema.columns
WHERE Table_Name = @table
AND Data_Type <> 'VarBinary' AND ISNULL(CHARACTER_MAXIMUM_LENGTH,0) >= 0

SET @CaseStatement = LEFT(@CaseStatement, LEN(@CaseStatement) -1)

SELECT @ColumnList = @columnList + Column_Name + ','
FROM information_schema.columns
WHERE Table_Name = @table
AND Data_Type <> 'VarBinary' AND ISNULL(CHARACTER_MAXIMUM_LENGTH,0) >= 0
SET @ColumnList = LEFT(@ColumnList, LEN(@ColumnList) -1)

SET @SQL = 'SELECT sys.fn_cdc_map_lsn_to_time(up_b.__$start_lsn) AS commit_time

,up_b.Column_name
,up_b.old_value
,up_a.new_value
FROM (
SELECT *
FROM (
SELECT __$start_lsn
,' + @CaseStatement + '
FROM cdc.dbo_' + @table + '_CT
WHERE __$operation = 3 and sys.fn_cdc_map_lsn_to_time(__$start_lsn) Between ''' + @DateFrom + ''' and ''' + @DateTo + '''
) AS t1
UNPIVOT(old_value FOR column_name IN (' + @ColumnList + ')) AS unp
) AS up_b
INNER JOIN (
SELECT __$start_lsn

,column_name
,new_value
FROM (
SELECT __$start_lsn
,' + @CaseStatement + '
FROM cdc.dbo_' + @table + '_CT
WHERE __$operation = 4 and sys.fn_cdc_map_lsn_to_time(__$start_lsn) Between ''' + @DateFrom + ''' and ''' + @DateTo + '''
) AS t2
UNPIVOT(new_value FOR column_name IN (' + @ColumnList + ')) AS unp
) AS up_a
ON up_b.__$start_lsn = up_a.__$start_lsn
AND up_b.column_name = up_a.column_name'
SET @ParamDefinition = '@Datefrom DATETIME ,@DateTo DATETIME, @Database VARCHAR(255),@table Varchar(255)'

EXEC Sp_executesql @SQL
,@ParamDefinition
,@Datefrom
,@DateTo
,@database
,@table
SELECT (@SQL)
END
GO
