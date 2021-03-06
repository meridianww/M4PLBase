SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- =============================================      
-- Author       : Nikhil       
-- Create date  : 28 Jan 2018    
-- Description  : To get user setting by entity and setting name   
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- ============================================= 
CREATE FUNCTION [dbo].[fnGetUserSettings]
(
	@globalSetting BIT =0,
	@userId BIGINT = NULL,
	@entityName NVARCHAR(100)=NULL,
	@settingName NVARCHAR(100)=NULL
)

RETURNS @OUTPUT TABLE (
	Entity  NVARCHAR(100),
	EntityName NVARCHAR(100),
	Name NVARCHAR(100),
	Value NVARCHAR(MAX),
	ValueType NVARCHAR(100),
	IsOverWritable NVARCHAR(50),
	IsSysAdmin NVARCHAR(50),
	ColumnName NVARCHAR(100)
)
AS
BEGIN
	  DECLARE @json NVARCHAR(MAX)
	  SELECT TOP 1 @json =  SysJsonSetting FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE 1=1
	  AND (usys.GlobalSetting = CASE WHEN (ISNULL(@userId,0) = 0) THEN 1 ELSE @globalSetting END OR usys.UserId = @userId)
	  
IF(ISNULL(@json,'')<>'')
BEGIN
	    Declare @tableName nvarchar(100) 
		SELECT @tableName = sysRef.TblTableName		
		FROM SYSTM000Ref_Table sysRef WHERE SysRefName = @entityName


		DECLARE @TempTable TABLE (
   
			Entity  NVARCHAR(100),
			EntityName NVARCHAR(100),
			Name NVARCHAR(100),
			Value NVARCHAR(MAX),
			ValueType NVARCHAR(100),
			IsOverWritable NVARCHAR(50),
			IsSysAdmin NVARCHAR(50)
		)
	  INSERT INTO @TempTable SELECT    
	
		MAX(CASE WHEN Name='Entity' THEN CONVERT( NVARCHAR(100),STRINGVALUE) ELSE '' END) AS Entity,  
		MAX(CASE WHEN Name='EntityName' THEN CONVERT(NVARCHAR(100),STRINGVALUE) ELSE '' END) AS EntityName,  
		MAX(CASE WHEN Name='Name' THEN CONVERT(NVARCHAR(100),STRINGVALUE) ELSE '' END) AS Name,  
		MAX(CASE WHEN Name='Value' THEN CONVERT(NVARCHAR(MAX),STRINGVALUE) ELSE '' END) AS Value,  
		MAX(CASE WHEN Name='ValueType' THEN CONVERT(NVARCHAR(MAX),STRINGVALUE) ELSE '' END) AS ValueType,  
		MAX(CASE WHEN Name='IsOverWritable' THEN CONVERT(NVARCHAR(50),STRINGVALUE) ELSE '' END) AS IsOverWritable,  
		MAX(CASE WHEN Name='IsSysAdmin' THEN CONVERT(NVARCHAR(50),STRINGVALUE) ELSE '' END) AS IsSysAdmin
 		FROM fnParseJSON (@json) WHERE VALUETYPE IN( 'INT','STRING','BOOLEAN' ) 
		GROUP BY PARENT_ID  

	INSERT INTO @OUTPUT 
	SELECT tt.Entity ,
		tt.EntityName
		,tt.Name 
		,tt.Value
		,tt.ValueType 
		,tt.IsOverWritable
		,tt.IsSysAdmin 
		,(@entityName+'.'+ col.name) as ColumnName     
	FROM @TempTable tt
	LEFT JOIN sys.columns col ON  tt.Value LIKE '%' +@entityName+'.'+ col.name+'%' AND col.object_id  = (CASE WHEN ISNULL(@tableName,'')<>'' THEN OBJECT_ID(@tableName) ELSE col.object_id END)
	WHERE tt.Name = CASE WHEN (ISNULL(@settingName,'') = '') THEN tt.Name ELSE @settingName END
	AND tt.EntityName = CASE WHEN (ISNULL(@entityName,'') = '') THEN tt.EntityName ELSE @entityName END 
END
RETURN
END
GO
