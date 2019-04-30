
update SYSTM000Ref_UserSettings set SysJsonSetting = '[{"Entity":73,"EntityName":"JobGateway","Name":"ItemNumber","Value":"AND JobGateway.GatewayTypeId=","ValueType":"int","IsOverWritable":false,"IsSysAdmin":false},{"Entity":73,"EntityName":"JobGateway","Name":"ItemNumber","Value":"AND JobGateway.GwyOrderType=","ValueType":"int","IsOverWritable":false,"IsSysAdmin":false},{"Entity":73,"EntityName":"JobGateway","Name":"ItemNumber","Value":"AND JobGateway.GwyShipmentType=","ValueType":"int","IsOverWritable":false,"IsSysAdmin":false},{"Entity":55,"EntityName":"PrgRefGatewayDefault","Name":"ItemNumber","Value":"AND PrgRefGatewayDefault.GatewayTypeId=","ValueType":"int","IsOverWritable":false,"IsSysAdmin":false},{"Entity":55,"EntityName":"PrgRefGatewayDefault","Name":"ItemNumber","Value":"AND PrgRefGatewayDefault.PgdOrderType=","ValueType":"int","IsOverWritable":false,"IsSysAdmin":false},{"Entity":55,"EntityName":"PrgRefGatewayDefault","Name":"ItemNumber","Value":"AND PrgRefGatewayDefault.PgdShipmentType=","ValueType":"int","IsOverWritable":false,"IsSysAdmin":false},{"Entity":72,"EntityName":"JobDocReference","Name":"ItemNumber","Value":"AND JobDocReference.DocTypeId =","ValueType":"int","IsOverWritable":false,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysMainModuleId","Value":"10","ValueType":"String","IsOverWritable":false,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysDefaultAction","Value":"Dashboard","ValueType":"String","IsOverWritable":false,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysStatusesIn","Value":"1,2","ValueType":"String","IsOverWritable":false,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysGridViewPageSizes","Value":"30,50,100","ValueType":"String","IsOverWritable":false,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysPageSize","Value":"30","ValueType":"String","IsOverWritable":false,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysComboBoxPageSize","Value":"10","ValueType":"String","IsOverWritable":false,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysThresholdPercentage","Value":"10","ValueType":"String","IsOverWritable":false,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"Theme","Value":"Office2010Black","ValueType":"String","IsOverWritable":false,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysSessionTimeOut","Value":"60","ValueType":"String","IsOverWritable":false,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysWarningTime","Value":"2","ValueType":"String","IsOverWritable":false,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysDateFormat","Value":"MM/dd/yyyy","ValueType":"String","IsOverWritable":false,"IsSysAdmin":false}]'
GO
PRINT N'Dropping [dbo].[FK_SYSTM000Ref_UserSettings_SYSTM000MenuDriver]...';


GO
ALTER TABLE [dbo].[SYSTM000Ref_UserSettings] DROP CONSTRAINT [FK_SYSTM000Ref_UserSettings_SYSTM000MenuDriver];




GO
PRINT N'Altering [dbo].[SYSTM000Ref_UserSettings]...';


GO
ALTER TABLE [dbo].[SYSTM000Ref_UserSettings] DROP COLUMN [SysComboBoxPageSize], COLUMN [SysDefaultAction], COLUMN [SysGridViewPageSizes], COLUMN [SysMainModuleId], COLUMN [SysPageSize], COLUMN [SysStatusesIn], COLUMN [SysThresholdPercentage], COLUMN [Theme];


GO
ALTER TABLE [dbo].[SYSTM000Ref_UserSettings]
    ADD [GlobalSetting]  BIT            CONSTRAINT [DF_SYSTM000Ref_UserSettings_GlobalSetting] DEFAULT ((0)) NOT NULL,
        [SysJsonSetting] NVARCHAR (MAX) NULL;


GO
PRINT N'Creating [dbo].[ResetJobsItemNumberSQL]...';


GO
CREATE FUNCTION [dbo].[ResetJobsItemNumberSQL] (@Id BIGINT,@tableName NVARCHAR(100),@pKFieldName NVARCHAR(100),@itemFieldName NVARCHAR(100),@parentKeyName NVARCHAR(100),@entity NVARCHAR(100),@userId BIGINT,@Where NVARCHAR(MAX),@joins NVARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS BEGIN
  DECLARE @sqlCommand NVARCHAR(MAX)

 
  SET @sqlCommand = ';WITH CTE AS
				(
				SELECT '+  @entity + '.'+ @pKFieldName +',
				ROW_NUMBER() OVER (ORDER BY '+ @entity + '.'+ @itemFieldName +' ASC) AS RN
				FROM '+ @tableName + ' '+ @entity 
				if(@entity <>'JobGateway')
				BEGIN
				SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
				 END
			    SET @sqlCommand+=  ' '+ @joins + ' WHERE 1=1 ' + @where + ' AND ' + @entity + '.'+ @pKFieldName + ' <> CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT))
				UPDATE '+ @entity + '
				SET ' + @entity + '.' + @itemFieldName +' = ct.RN 
				FROM '+ @tableName + ' '+ @entity 
			    IF(@entity <>'JobGateway')
				BEGIN
				SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
				 END
				 SET @sqlCommand+= ' INNER JOIN CTE ct ON ' + @entity + '.'+ @pKFieldName + ' = ct.'+ @pKFieldName +  ' ' + @joins + '
				WHERE 1=1 '+ @Where

    RETURN @sqlCommand
END
GO
PRINT N'Creating [dbo].[fnParseJSON]...';


GO
  
-- =============================================      
-- Author       : Nikhil       
-- Create date  : 25 Jan 2018    
-- Description  : To parse JSON   
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- =============================================     
CREATE FUNCTION [dbo].[fnParseJSON]( @JSON NVARCHAR(MAX))
	RETURNS @hierarchy TABLE
	  (
	   element_id INT IDENTITY(1, 1) NOT NULL, /* internal surrogate primary key gives the order of parsing and the list order */
	   sequenceNo [int] NULL, /* the place in the sequence for the element */
	   parent_ID INT,/* if the element has a parent then it is in this column. The document is the ultimate parent, so you can get the structure from recursing from the document */
	   Object_ID INT,/* each list or object has an object id. This ties all elements to a parent. Lists are treated as objects here */
	   NAME NVARCHAR(2000),/* the name of the object */
	   StringValue NVARCHAR(MAX) NOT NULL,/*the string representation of the value of the element. */
	   ValueType VARCHAR(10) NOT null /* the declared type of the value represented as a string in StringValue*/
	  )
	AS
	BEGIN
	  DECLARE
	    @FirstObject INT, --the index of the first open bracket found in the JSON string
	    @OpenDelimiter INT,--the index of the next open bracket found in the JSON string
	    @NextOpenDelimiter INT,--the index of subsequent open bracket found in the JSON string
	    @NextCloseDelimiter INT,--the index of subsequent close bracket found in the JSON string
	    @Type NVARCHAR(10),--whether it denotes an object or an array
	    @NextCloseDelimiterChar CHAR(1),--either a '}' or a ']'
	    @Contents NVARCHAR(MAX), --the unparsed contents of the bracketed expression
	    @Start INT, --index of the start of the token that you are parsing
	    @end INT,--index of the end of the token that you are parsing
	    @param INT,--the parameter at the end of the next Object/Array token
	    @EndOfName INT,--the index of the start of the parameter at end of Object/Array token
	    @token NVARCHAR(200),--either a string or object
	    @value NVARCHAR(MAX), -- the value as a string
	    @SequenceNo int, -- the sequence number within a list
	    @name NVARCHAR(200), --the name as a string
	    @parent_ID INT,--the next parent ID to allocate
	    @lenJSON INT,--the current length of the JSON String
	    @characters NCHAR(36),--used to convert hex to decimal
	    @result BIGINT,--the value of the hex symbol being parsed
	    @index SMALLINT,--used for parsing the hex value
	    @Escape INT --the index of the next escape character
	    
	  DECLARE @Strings TABLE /* in this temporary table we keep all strings, even the names of the elements, since they are 'escaped' in a different way, and may contain, unescaped, brackets denoting objects or lists. These are replaced in the JSON string by tokens representing the string */
	    (
	     String_ID INT IDENTITY(1, 1),
	     StringValue NVARCHAR(MAX)
	    )
	  SELECT--initialise the characters to convert hex to ascii
	    @characters='0123456789abcdefghijklmnopqrstuvwxyz',
	    @SequenceNo=0, --set the sequence no. to something sensible.
	  /* firstly we process all strings. This is done because [{} and ] aren't escaped in strings, which complicates an iterative parse. */
	    @parent_ID=0;
	  WHILE 1=1 --forever until there is nothing more to do
	    BEGIN
	      SELECT
	        @start=PATINDEX('%[^a-zA-Z]["]%', @json collate SQL_Latin1_General_CP850_Bin);--next delimited string
	      IF @start=0 BREAK --no more so drop through the WHILE loop
	      IF SUBSTRING(@json, @start+1, 1)='"' 
	        BEGIN --Delimited Name
	          SET @start=@Start+1;
	          SET @end=PATINDEX('%[^\]["]%', RIGHT(@json, LEN(@json+'|')-@start) collate SQL_Latin1_General_CP850_Bin);
	        END
	      IF @end=0 --no end delimiter to last string
	        BREAK --no more
	      SELECT @token=SUBSTRING(@json, @start+1, @end-1)
	      --now put in the escaped control characters
	      SELECT @token=REPLACE(@token, FROMString, TOString)
	      FROM
	        (SELECT
	          '\"' AS FromString, '"' AS ToString
	         UNION ALL SELECT '\\', '\'
	         UNION ALL SELECT '\/', '/'
	         UNION ALL SELECT '\b', CHAR(08)
	         UNION ALL SELECT '\f', CHAR(12)
	         UNION ALL SELECT '\n', CHAR(10)
	         UNION ALL SELECT '\r', CHAR(13)
	         UNION ALL SELECT '\t', CHAR(09)
	        ) substitutions
	      SELECT @result=0, @escape=1
	  --Begin to take out any hex escape codes
	      WHILE @escape>0
	        BEGIN
	          SELECT @index=0,
	          --find the next hex escape sequence
	          @escape=PATINDEX('%\x[0-9a-f][0-9a-f][0-9a-f][0-9a-f]%', @token collate SQL_Latin1_General_CP850_Bin)
	          IF @escape>0 --if there is one
	            BEGIN
	              WHILE @index<4 --there are always four digits to a \x sequence   
	                BEGIN
	                  SELECT --determine its value
	                    @result=@result+POWER(16, @index)
	                    *(CHARINDEX(SUBSTRING(@token, @escape+2+3-@index, 1),
	                                @characters)-1), @index=@index+1 ;
	         
	                END
	                -- and replace the hex sequence by its unicode value
	              SELECT @token=STUFF(@token, @escape, 6, NCHAR(@result))
	            END
	        END
	      --now store the string away 
	      INSERT INTO @Strings (StringValue) SELECT @token
	      -- and replace the string with a token
	      SELECT @JSON=STUFF(@json, @start, @end+1,
	                    '@string'+CONVERT(NVARCHAR(5), @@identity))
	    END
	  -- all strings are now removed. Now we find the first leaf.  
	  WHILE 1=1  --forever until there is nothing more to do
	  BEGIN
	 
	  SELECT @parent_ID=@parent_ID+1
	  --find the first object or list by looking for the open bracket
	  SELECT @FirstObject=PATINDEX('%[{[[]%', @json collate SQL_Latin1_General_CP850_Bin)--object or array
	  IF @FirstObject = 0 BREAK
	  IF (SUBSTRING(@json, @FirstObject, 1)='{') 
	    SELECT @NextCloseDelimiterChar='}', @type='object'
	  ELSE 
	    SELECT @NextCloseDelimiterChar=']', @type='array'
	  SELECT @OpenDelimiter=@firstObject
	  WHILE 1=1 --find the innermost object or list...
	    BEGIN
	      SELECT
	        @lenJSON=LEN(@JSON+'|')-1
	  --find the matching close-delimiter proceeding after the open-delimiter
	      SELECT
	        @NextCloseDelimiter=CHARINDEX(@NextCloseDelimiterChar, @json,
	                                      @OpenDelimiter+1)
	  --is there an intervening open-delimiter of either type
	      SELECT @NextOpenDelimiter=PATINDEX('%[{[[]%',
	             RIGHT(@json, @lenJSON-@OpenDelimiter)collate SQL_Latin1_General_CP850_Bin)--object
	      IF @NextOpenDelimiter=0 
	        BREAK
	      SELECT @NextOpenDelimiter=@NextOpenDelimiter+@OpenDelimiter
	      IF @NextCloseDelimiter<@NextOpenDelimiter 
	        BREAK
	      IF SUBSTRING(@json, @NextOpenDelimiter, 1)='{' 
	        SELECT @NextCloseDelimiterChar='}', @type='object'
	      ELSE 
	        SELECT @NextCloseDelimiterChar=']', @type='array'
	      SELECT @OpenDelimiter=@NextOpenDelimiter
	    END
	  ---and parse out the list or name/value pairs
	  SELECT
	    @contents=SUBSTRING(@json, @OpenDelimiter+1,
	                        @NextCloseDelimiter-@OpenDelimiter-1)
	  SELECT
	    @JSON=STUFF(@json, @OpenDelimiter,
	                @NextCloseDelimiter-@OpenDelimiter+1,
	                '@'+@type+CONVERT(NVARCHAR(5), @parent_ID))
	  WHILE (PATINDEX('%[A-Za-z0-9@+.e]%', @contents collate SQL_Latin1_General_CP850_Bin))<>0 
	    BEGIN
	      IF @Type='Object' --it will be a 0-n list containing a string followed by a string, number,boolean, or null
	        BEGIN
	          SELECT
	            @SequenceNo=0,@end=CHARINDEX(':', ' '+@contents)--if there is anything, it will be a string-based name.
	          SELECT  @start=PATINDEX('%[^A-Za-z@][@]%', ' '+@contents collate SQL_Latin1_General_CP850_Bin)--AAAAAAAA
	          SELECT @token=SUBSTRING(' '+@contents, @start+1, @End-@Start-1),
	            @endofname=PATINDEX('%[0-9]%', @token collate SQL_Latin1_General_CP850_Bin),
	            @param=RIGHT(@token, LEN(@token)-@endofname+1)
	          SELECT
	            @token=LEFT(@token, @endofname-1),
	            @Contents=RIGHT(' '+@contents, LEN(' '+@contents+'|')-@end-1)
	          SELECT  @name=stringvalue FROM @strings
	            WHERE string_id=@param --fetch the name
	        END
	      ELSE 
	        SELECT @Name=null,@SequenceNo=@SequenceNo+1 
	      SELECT
	        @end=CHARINDEX(',', @contents)-- a string-token, object-token, list-token, number,boolean, or null
                IF @end=0
	        --HR Engineering notation bugfix start
	          IF ISNUMERIC(@contents) = 1
		    SELECT @end = LEN(@contents)
	          Else
	        --HR Engineering notation bugfix end 
		  SELECT  @end=PATINDEX('%[A-Za-z0-9@+.e][^A-Za-z0-9@+.e]%', @contents+' ' collate SQL_Latin1_General_CP850_Bin) + 1
	       SELECT
	        @start=PATINDEX('%[^A-Za-z0-9@+.e][A-Za-z0-9@+.e]%', ' '+@contents collate SQL_Latin1_General_CP850_Bin)
	      --select @start,@end, LEN(@contents+'|'), @contents  
	      SELECT
	        @Value=RTRIM(SUBSTRING(@contents, @start, @End-@Start)),
	        @Contents=RIGHT(@contents+' ', LEN(@contents+'|')-@end)
	      IF SUBSTRING(@value, 1, 7)='@object' 
	        INSERT INTO @hierarchy
	          (NAME, SequenceNo, parent_ID, StringValue, Object_ID, ValueType)
	          SELECT @name, @SequenceNo, @parent_ID, SUBSTRING(@value, 8, 5),
	            SUBSTRING(@value, 8, 5), 'object' 
	      ELSE 
	        IF SUBSTRING(@value, 1, 6)='@array' 
	          INSERT INTO @hierarchy
	            (NAME, SequenceNo, parent_ID, StringValue, Object_ID, ValueType)
	            SELECT @name, @SequenceNo, @parent_ID, SUBSTRING(@value, 7, 5),
	              SUBSTRING(@value, 7, 5), 'array' 
	        ELSE 
	          IF SUBSTRING(@value, 1, 7)='@string' 
	            INSERT INTO @hierarchy
	              (NAME, SequenceNo, parent_ID, StringValue, ValueType)
	              SELECT @name, @SequenceNo, @parent_ID, stringvalue, 'string'
	              FROM @strings
	              WHERE string_id=SUBSTRING(@value, 8, 5)
	          ELSE 
	            IF @value IN ('true', 'false') 
	              INSERT INTO @hierarchy
	                (NAME, SequenceNo, parent_ID, StringValue, ValueType)
	                SELECT @name, @SequenceNo, @parent_ID, @value, 'boolean'
	            ELSE
	              IF @value='null' 
	                INSERT INTO @hierarchy
	                  (NAME, SequenceNo, parent_ID, StringValue, ValueType)
	                  SELECT @name, @SequenceNo, @parent_ID, @value, 'null'
	              ELSE
	                IF PATINDEX('%[^0-9]%', @value collate SQL_Latin1_General_CP850_Bin)>0 
	                  INSERT INTO @hierarchy
	                    (NAME, SequenceNo, parent_ID, StringValue, ValueType)
	                    SELECT @name, @SequenceNo, @parent_ID, @value, 'real'
	                ELSE
	                  INSERT INTO @hierarchy
	                    (NAME, SequenceNo, parent_ID, StringValue, ValueType)
	                    SELECT @name, @SequenceNo, @parent_ID, @value, 'int'
	      if @Contents=' ' Select @SequenceNo=0
	    END
	  END
	INSERT INTO @hierarchy (NAME, SequenceNo, parent_ID, StringValue, Object_ID, ValueType)
	  SELECT '-',1, NULL, '', @parent_id-1, @type
	--
	   RETURN
	END
GO
PRINT N'Creating [dbo].[fnGetUserSettings]...';


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
PRINT N'Creating [dbo].[fnGetEntitySettingWhereClause]...';


GO


  
-- =============================================      
-- Author       : Nikhil       
-- Create date  : 29 Jan 2018    
-- Description  : To get entity's setting where condition   
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- ============================================= 
CREATE FUNCTION [dbo].[fnGetEntitySettingWhereClause]
(
	@userId BIGINT,
	@entity NVARCHAR(100),
	@settingName NVARCHAR(100),
	@joins NVARCHAR(MAX),
	@recordId BIGINT=NULL
)

RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @sqlCommand NVARCHAR(MAX), @whereClause NVARCHAR(MAX), @tableName NVARCHAR(100), @pKFieldName NVARCHAR(100), @itemFieldName NVARCHAR(100),@parentKeyName NVARCHAR(100), @columnNames NVARCHAR(MAX);
	SELECT @tableName = sysRef.TblTableName,
			@pKFieldName = sysRef.TblPrimaryKeyName,
			@itemFieldName = sysRef.TblItemNumberFieldName,
			@parentKeyName = sysRef.TblParentIdFieldName
	FROM SYSTM000Ref_Table sysRef WHERE SysRefName = @entity
  
	SELECT @columnNames = COALESCE(@columnNames + ' + ','') + ''' '+ usys.Value + ' ''' + 
	(CASE usys.ValueType WHEN 'String' THEN  ''''' + CAST('+ usys.ColumnName +' AS NVARCHAR(MAX)) +'''''''''
	ELSE ' + CAST('+ usys.ColumnName +' AS NVARCHAR(MAX))' END)
	FROM [dbo].[fnGetUserSettings] (0, @userId , @entity, @settingName) usys

	IF(ISNULL(@joins, '') = '')
		BEGIN 
		SET @joins = '';
		END

	--SET @sqlCommand = 'SELECT @whereClause = '+  @columnNames +' FROM '+ @tableName + ' ' + @entity
	--+ @joins + ' WHERE ' + @entity + '.' +@pKFieldName  +' = CAST('+ CAST( @recordId AS  NVARCHAR(MAX) ) +' AS BIGINT)'--' = CAST(' + @recordId + 'AS NVARCHAR(MAX)) '

	--EXEC sp_executesql @sqlCommand, N'@whereClause NVARCHAR(MAX) OUTPUT',@whereClause =  @whereClause OUTPUT

	RETURN   @columnNames
END
GO
PRINT N'Altering [dbo].[fnGetUserStatuses]...';


GO

-- =============================================      
-- Author       : Akhil       
-- Create date  : 05 Dec 2017    
-- Description  : To get User Statuses   
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- ============================================= 

ALTER FUNCTION [dbo].[fnGetUserStatuses]
(
	@userId BIGINT
)
RETURNS @Output TABLE (
      StatusId NVARCHAR(50)
)
AS
BEGIN

DECLARE @userStatuses NVARCHAR(50)

IF EXISTS( SELECT TOP 1 1 FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE usys.UserId=@userId)
	BEGIN
	     
		SELECT @userStatuses = VALUE  FROM [dbo].[fnGetUserSettings] (0, @userId , 'System', 'SysStatusesIn') ;
	END
ELSE
	BEGIN
		SELECT @userStatuses = VALUE  FROM [dbo].[fnGetUserSettings] (0,0 , 'System', 'SysStatusesIn');
	END

	INSERT INTO @Output SELECT * FROM [dbo].[fnSplitString](@userStatuses, ',') 

RETURN 
END
GO
PRINT N'Altering [dbo].[GetUserSysSetting]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group      
   All Rights Reserved Worldwide */      
-- =============================================              
-- Author:                    Akhil Chauhan               
-- Create date:               12/09/2018            
-- Description:               Get User System Setting        
-- Execution:                 EXEC [dbo].[GetUserSysSetting]        
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)          
-- Modified Desc:        
-- =============================================              
ALTER PROCEDURE  [dbo].[GetUserSysSetting]  
 @userId BIGINT,      
 @roleId BIGINT,      
 @orgId BIGINT,      
 @contactId BIGINT            
AS            
BEGIN TRY                            
 SET NOCOUNT ON;         
          
IF EXISTS( SELECT TOP 1 1 FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE usys.UserId=@userId AND usys.OrganizationId=@orgId AND usys.GlobalSetting=0)            
 BEGIN          
   
    SELECT  usys.[Id]
			,usys.[OrganizationId]
			,usys.[UserId]
			,usys.[LangCode]
			,usys.[SysJsonSetting]
			  
    	 ,(Select ConImage FROM CONTC000Master where Id=@contactId) as UserIcon   
	    FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE usys.UserId=@userId AND usys.OrganizationId=@orgId AND usys.GlobalSetting=0             
  END            
ELSE            
 BEGIN  
   IF EXISTS(SELECT TOP 1 1 FROM CONTC000Master where Id=@contactId ) 
   BEGIN        
   SELECT  usys.[Id]
			,usys.[OrganizationId]
			,usys.[UserId]
			,usys.[LangCode]
			,usys.[SysJsonSetting]
			  
    	 ,(Select ConImage FROM CONTC000Master where Id=@contactId) as UserIcon   
	    FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE  usys.GlobalSetting=1     
	END	  
 END        
            
END TRY                            
BEGIN CATCH                            
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                            
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                            
  ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                            
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                            
END CATCH
GO
PRINT N'Altering [dbo].[UpdUserSystemSettings]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan 
-- Create date:               06/08/2018      
-- Description:               Update user system settings
-- Execution:                 EXEC [dbo].[UpdUserSystemSettings]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[UpdUserSystemSettings]
	@orgId BIGINT,
	@userId BIGINT,
	@langCode NVARCHAR(20),
	@sysJsonSetting NVARCHAR(MAX)
AS
BEGIN TRY                
 SET NOCOUNT ON; 
   IF (ISNULL(@orgId,0)<>0 AND ISNULL(@userId,0)<>0  AND ISNULL(@langCode,'')<>'')
    BEGIN   
	DECLARE  @SysJsonSetting_local NVARCHAR(MAX) = NULL
	SELECT @SysJsonSetting_local = usys.[SysJsonSetting] 
	FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys where usys.GlobalSetting =1 ; 
	 IF EXISTS( SELECT TOP 1 1 FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE usys.UserId=@userId AND usys.OrganizationId=@orgId AND usys.LangCode = @langCode AND usys.GlobalSetting<>1)            
	 BEGIN 	  
	     IF NOT EXISTS (  SELECT TOP 1 1 FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE usys.UserId=@userId AND usys.GlobalSetting<>1 AND usys.OrganizationId=@orgId AND usys.LangCode = @langCode AND  usys.SysJsonSetting  = @sysJsonSetting)
		 UPDATE [dbo].[SYSTM000Ref_UserSettings] 
		 SET [SysJsonSetting] = ISNULL(@sysJsonSetting, @SysJsonSetting_local)
		 WHERE UserId=@userId AND OrganizationId=@orgId AND LangCode = @langCode AND GlobalSetting<>1;  
	 END
   ELSE
	   BEGIN
	    SELECT @SysJsonSetting_local = usys.[SysJsonSetting] 		
		FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys where usys.GlobalSetting =1 ; 
		INSERT INTO [dbo].[SYSTM000Ref_UserSettings](OrganizationId, UserId, LangCode, SysJsonSetting) 
		VALUES(@orgId, @userId, @langCode,@SysJsonSetting_local);
    	END
	END
	END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[GetColumnAliasesByTableName]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get all ColumnAliases By Table Name
-- Execution:                 EXEC [dbo].[GetColumnAliasesByTableName]   
-- Modified on:  
-- Modified Desc:  
-- =============================================     
ALTER PROCEDURE [dbo].[GetColumnAliasesByTableName] 
	@langCode NVARCHAR(10),    
	@tableName NVARCHAR(100)    
AS                    
BEGIN TRY                    
 SET NOCOUNT ON;  

     
  DECLARE @columnAliasTable TABLE(    
    [Id] [bigint],    
 [LangCode] [nvarchar](10),    
 [ColTableName] [nvarchar](100),    
 [ColColumnName] [nvarchar](50),    
 [ColAliasName] [nvarchar](50),    
 [ColCaption] [nvarchar](50),    
 [ColLookupId] int,    
 [ColLookupCode] [nvarchar](100),    
 [ColDescription] [nvarchar](255),    
 [ColSortOrder] [int],    
 [ColIsReadOnly] [bit],    
 [ColIsVisible] [bit],    
 [ColIsDefault] [bit],    
 [ColIsFreezed] [bit],    
 [ColIsGroupBy] [bit],    
 [DataType] [nvarchar](50),    
 [MaxLength] [int],    
 [IsRequired] [bit],    
 [RequiredMessage] [nvarchar](255),    
 [IsUnique] [bit],    
 [UniqueMessage] [nvarchar](255),    
 [HasValidation] [bit],    
 [GridLayout] [nvarchar](max),    
 [RelationalEntity] [nvarchar](100),   
 [DefaultLookup] int,  
 [DefaultLookupName] NVARCHAR(100),  
 [ColDisplayFormat] NVARCHAR(200) ,  
 [GlobalIsVisible]    BIT, 
 [ColAllowNegativeValue] BIT,
 --Added by Sanyogita
 [ColMask] [nvarchar](50)
  )    
      
 INSERT INTO @columnAliasTable SELECT cal.[Id]    
    ,cal.[LangCode]    
    ,cal.ColTableName     
    ,CASE WHEN ISNULL(c.name, '') = ''  THEN  cal.ColColumnName ELSE c.name END as ColColumnName    
    ,CASE WHEN ISNULL(cal.[ColAliasName], '') = ''  THEN  c.name ELSE cal.[ColAliasName] END as ColAliasName    
    ,CASE WHEN ISNULL(cal.[ColCaption], '') = ''  THEN  c.name ELSE cal.[ColCaption] END as ColCaption    
    ,cal.[ColLookupId]    
    ,cal.[ColLookupCode]    
    ,CASE WHEN ISNULL(cal.[ColDescription], '') = ''  THEN  c.name ELSE cal.[ColDescription] END as ColDescription    
    ,cal.[ColSortOrder]    
    ,cal.[ColIsReadOnly]    
    ,cal.[ColIsVisible]    
    ,cal.[ColIsDefault]    
    ,0    
    ,cal.[ColIsGroupBy]    
    ,CASE WHEN c.name IN (SELECT ColumnName FROM dbo.fnGetRefOptionsFK(@tableName)) THEN 'dropdown' WHEN c.name IN (SELECT ColumnName FROM dbo.fnGetModuleFK(@tableName)) THEN 'name' ELSE CASE WHEN ISNULL(t.Name, '') = '' THEN 'nvarchar' ELSE t.Name END END  as 'DataType'    
    ,CASE  WHEN  c.max_length < 2  THEN c.system_type_id  WHEN (c.system_type_id=231) THEN (c.max_length)/2   ELSE CASE WHEN (t.name = 'ntext') THEN (c.max_length * 2729) ELSE CASE WHEN ISNULL(c.max_length, '') = '' THEN '1000' ELSE (c.max_length) END END END as MaxLength  
    ,0    
    ,''    
    ,0    
    ,''    
    ,0    
    ,'' as GridLayout    
    ,fgmk.RelationalEntity  
 ,ref.Id as DefaultLookup  
 ,ref.SysOptionName as DefaultLookupName  
 ,cal.[ColDisplayFormat]  
 ,cal.[ColIsVisible]  as GlobalIsVisible  
 ,cal.[ColAllowNegativeValue]  as ColAllowNegativeValue 
 --Added by Sanyogita
 ,cal.[ColMask] as ColMask  
  FROM [dbo].[SYSTM000ColumnsAlias] (NOLOCK) cal    
  INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl ON tbl.SysRefName = cal.ColTableName    
  LEFT JOIN  sys.columns c ON  c.name = cal.ColColumnName AND c.object_id = OBJECT_ID(tbl.TblTableName)  
  LEFT JOIN  sys.types t ON c.user_type_id = t.user_type_id    
  LEFT JOIN dbo.fnGetModuleFK(@tableName) fgmk ON cal.ColColumnName = fgmk.ColumnName  
  LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) ref ON ref.SysLookupId =  cal.[ColLookupId] AND ref.SysDefault = 1  AND ref.StatusId < 3  
  WHERE cal.[LangCode]= @langCode AND    
  cal.ColTableName = @tableName
  AND ISNULL(cal.StatusId,1) = 1
  ORDER BY cal.ColSortOrder; 
  
 UPDATE cal        
 SET IsRequired = ISNULL(val.[ValRequired],0),    
 RequiredMessage = ISNULL(val.[ValRequiredMessage],'') ,    
 IsUnique = ISNULL(val.[ValUnique], 0),    
 UniqueMessage = ISNULL(val.[ValUniqueMessage],''),    
 HasValidation = 1    
 FROM  @columnAliasTable cal    
 INNER JOIN [dbo].[SYSTM000Validation] (NOLOCK) val ON val.[ValFieldName] = cal.[ColColumnName] AND cal.ColTableName = val.ValTableName    
 WHERE  ISNULL(val.[StatusId],1) =1  
 --update DisplayFormat from SysSettings  
  
 UPDATE cal  
 SET [ColDisplayFormat] = (select value FROM [dbo].[fnGetUserSettings] (0, 0 , 'System', 'SysDateFormat'))  
 FROM  @columnAliasTable cal  WHERE cal.DataType='datetime2' AND cal.[ColDisplayFormat] IS NULL  
  
    
 SELECT * FROM @columnAliasTable    ORDER BY ColSortOrder    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
     
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
PRINT N'Altering [dbo].[GetSystemSettings]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara      
-- Create date:               01/23/2018      
-- Description:               Get system settings
-- Execution:                 EXEC [dbo].[GetSystemSettings]
-- Modified on:  
-- Modified Desc:  
-- =============================================     
ALTER PROCEDURE [dbo].[GetSystemSettings]
 @langCode NVARCHAR(24)   
AS    
BEGIN TRY      
 SET NOCOUNT ON;     
 SELECT settings.[Id]
      ,settings.[OrganizationId]
      ,settings.[UserId]
      ,settings.[LangCode]
      ,settings.[SysJsonSetting]
   FROM [dbo].[SYSTM000Ref_UserSettings](NOLOCK) settings WHERE   settings.LangCode= @langCode AND settings.GlobalSetting=1
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
     
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
PRINT N'Creating [dbo].[GetEntitySettingWhereClause]...';


GO
-- =============================================
-- Author:		Nikhil
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetEntitySettingWhereClause]
@entity NVARCHAR(100),
@id BIGINT,
@joins NVARCHAR(100) ='',
@userId BIGINT,
@entityfield NVARCHAR(100),
@deletedKeys NVARCHAR(250)= NULL,
@where NVARCHAR(MAX) OUTPUT
AS
BEGIN
        IF(ISNULL(@id,0)=0 AND ISNULL(@deletedKeys,'')<>'' )
		BEGIN
		SET @id=LEFT(@deletedKeys, CHARINDEX(',', @deletedKeys+',')-1)
		END
		Declare @sqlCommand  NVARCHAR(MAX), @columnNames NVARCHAR(MAX), @whereClause NVARCHAR(MAX) ,@tableName NVARCHAR(100), @pKFieldName NVARCHAR(100)
		SELECT @tableName = sysRef.TblTableName,
		@pKFieldName = sysRef.TblPrimaryKeyName
		FROM SYSTM000Ref_Table sysRef WHERE SysRefName = @entity
		select @columnNames =  [dbo].[fnGetEntitySettingWhereClause] (@userId,@entity, @entityfield, @joins , @id) 
		IF(ISNULL(@columnNames,'')<>'')
		BEGIN
		SET @sqlCommand = 'SELECT @whereClause = '+  @columnNames +' FROM '+ @tableName + ' ' + @entity
		+ @joins + ' WHERE 1=1 AND ' + @entity + '.' +@pKFieldName  +' = CAST('+ CAST( @id AS  NVARCHAR(MAX) ) +' AS BIGINT)'
		EXEC sp_executesql @sqlCommand, N'@whereClause NVARCHAR(MAX) OUTPUT',@whereClause =  @whereClause OUTPUT
		SET @where =@whereClause;
		END
END
GO
PRINT N'Altering [dbo].[ResetItemNumber]...';


GO
                                  
ALTER PROCEDURE [dbo].[ResetItemNumber]                                        
( 
	@userId BIGINT,
	@id BIGINT,  
	@parentId BIGINT,
	@entity NVARCHAR(100), 
	@itemNumber INT,
	@statusId INT,  
	@joins NVARCHAR(MAX),                             
	@where NVARCHAR(MAX),                   
	@newItemNumber INT = NULL OUTPUT,
	@deletedKeys VARCHAR(200)=NULL
                                  
)                                       
AS        
BEGIN TRY                        
	SET NOCOUNT ON;  

	DECLARE @sqlCommand NVARCHAR(MAX), @tableName NVARCHAR(100), @pKFieldName NVARCHAR(100), @itemFieldName NVARCHAR(100),@parentKeyName NVARCHAR(100) ,@settingsWhere NVARCHAR(MAX) ;
	       
	SELECT @tableName = sysRef.TblTableName,
	@pKFieldName = sysRef.TblPrimaryKeyName,
	@itemFieldName = sysRef.TblItemNumberFieldName,
	@parentKeyName = sysRef.TblParentIdFieldName
	FROM [dbo].[SYSTM000Ref_Table] (NOLOCK) sysRef WHERE sysRef. SysRefName = @entity;
	IF(ISNULL(@statusId, 1) = 1)
		BEGIN 
		SET @statusId = 1;
		END
	IF(ISNULL(@where, '') = '')
		BEGIN 
		SET @where = '';
		END
	IF(ISNULL(@joins, '') = '')
			BEGIN 
			SET @joins = '';
			END
   IF(ISNULL(@parentId, 0) > 0 )
		BEGIN
		SET @where = @where + ' AND ' +  @entity + '.'+ @parentKeyName + ' = CAST('+ CAST( @parentId AS  VARCHAR ) +' AS BIGINT)';
		END

    IF ((ISNULL(@id,0)<>0) AND (@entity  ='JobGateway' OR @entity  ='PrgRefGatewayDefault' OR @entity  ='JobDocReference')) 
		BEGIN
		IF(ISNULL(@statusId, 1) = 1 OR @entity  ='JobGateway' )
		BEGIN 
		SET @statusId = 194;
		END
			EXEC GetEntitySettingWhereClause @entity,@id,@joins,@userid,'ItemNumber',@deletedKeys, @settingsWhere OUTPUT  
			IF(CHARINDEX(@settingsWhere,@where) = 0)
			BEGIN
			IF(ISNULL(@parentId, 0) > 0 )
				BEGIN
					SET @settingsWhere +=  ' AND ' +  @entity + '.'+ @parentKeyName + ' = CAST('+ CAST( @parentId AS  VARCHAR ) +' AS BIGINT)';
	
				END
		
				Declare @jobDocReferenceCommand NVARCHAR(MAX) 
					select @jobDocReferenceCommand =  dbo.ResetJobsItemNumberSQL(@id,@tableName,@pKFieldName,@itemFieldName ,@parentKeyName ,@entity,@userId,@settingsWhere,@joins);
					EXEC sp_executesql @jobDocReferenceCommand
					SET @id = 0;
				
				

			 END
		END
	
	IF(@statusId =1 OR @statusId =2 OR @statusId =194 OR @statusId =195 )   -- 194 and 195  are for Job gateways  and 1,2 are active and Inactive 
	BEGIN
																																																																																																																													BEGIN
		DECLARE @maxItemNumber INT = 0;
		DECLARE @newItemId INT = 0 ;
		DECLARE @existingItemNumber INT = 0 ;
		DECLARE @existingItemId INT = 0 ;
		Declare @maxItemNumId  INT =0;
		SET @sqlCommand = ';WITH CTE AS
		(
		SELECT '+  @entity + '.'+ @pKFieldName +' AS CURRENT_ID,
		ROW_NUMBER() OVER (ORDER BY '+ @entity + '.'+ @itemFieldName +' ASC) AS RN
		FROM '+ @tableName + ' '+ @entity  
		IF(@entity <>'JobGateway')
		BEGIN
		SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
		END
		
		SET @sqlCommand+= ' '+ @joins + ' WHERE 1=1 ' + @where + ') SELECT @maxItemNumber = COUNT(CURRENT_ID) FROM CTE'
		EXEC sp_executesql @sqlCommand, N'@maxItemNumber INT OUTPUT',@maxItemNumber =  @maxItemNumber OUTPUT --first get maxItemNumber present in db
			IF(ISNULL(@maxItemNumber,0)=0)
				BEGIN
					SET @newItemNumber=1;					
				END
			ELSE IF(ISNULL(@itemNumber,0)=0 )
				BEGIN
					If(ISNULL(@id,0)>0)
					BEGIN
						SET @sqlCommand = 'SELECT @existingItemNumber = '  + @entity + '.' + @itemFieldName + ' FROM '+ @tableName + ' '+ @entity + ' WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT)'
						EXEC sp_executesql @sqlCommand, N' @existingItemNumber int output', @existingItemNumber output
						SET @newItemNumber = @existingItemNumber;					
					END
					ELSE
					BEGIN
					   SET @newItemNumber = ISNULL(@maxItemNumber,0)+1;
					END
				END
			ELSE
				BEGIN
					--Finding If this Item Number already exists
					SET @sqlCommand = 'SELECT @newItemId = '+ @entity + '.'+ @pKFieldName +
					' FROM '+ @tableName + ' '+ @entity 
					if(@entity <>'JobGateway')
					BEGIN
					SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
					END
					
						SET @sqlCommand+= ' '+ @joins + ' WHERE '  +  @entity + '.'+ @pKFieldName + ' <>  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT) AND '
					+  @entity + '.'+ @itemFieldName + ' = CAST('+ CAST( @itemNumber AS  VARCHAR ) +' AS INT)'
					+  @where
					EXEC sp_executesql @sqlCommand, N' @newItemId int output', @newItemId output
						IF(ISNULL(@newItemId,0)=0  AND @itemNumber < @maxItemNumber ) --same item number does not exists and less is than maximum
						BEGIN
						 SET @newItemNumber = @itemNumber;
						END
						ELSE IF(ISNULL(@newItemId,0)=0  AND @itemNumber >= @maxItemNumber )--SAME ITEM NUMBER DOES NOT EXISTS AND USER TRYING TO ADD ITEM NUMBER LARGER OR EQUAL TO MAXIMUM
						BEGIN
								IF(ISNULL(@id,0)>0) --User Is Updating .
								BEGIN  --Begin swaping with maximum number 
								--GET item Number of Current Record Id
									SET @sqlCommand = 'SELECT @existingItemNumber = '  + @entity + '.' + @itemFieldName + ' FROM '+ @tableName + ' '+ @entity + ' WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT)'
									EXEC sp_executesql @sqlCommand, N' @existingItemNumber int output', @existingItemNumber output

									SET @sqlCommand = 'SELECT @maxiItemNumId = '+ @entity + '.'+ @pKFieldName +
									' FROM '+ @tableName + ' '+ @entity 
									if(@entity <>'JobGateway')
									BEGIN
									SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
									END
								
									SET @sqlCommand+= ' '+ @joins + ' WHERE '  +  @entity + '.'+ @itemFieldName + ' = CAST('+ CAST( @maxItemNumber AS  VARCHAR ) +' AS INT)'+  @where
									EXEC sp_executesql @sqlCommand, N' @maxiItemNumId int output', @maxItemNumId output
										If(ISNULL(@maxItemNumId,0)<>0)
											BEGIN
												SET @sqlCommand = 'UPDATE '+ @entity + '
												SET ' + @entity + '.' + @itemFieldName + ' = CAST('+ CAST( @existingItemNumber AS  VARCHAR ) +' AS INT)
												FROM '+ @tableName + ' '+ @entity + '
												WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @maxItemNumId AS  VARCHAR ) +' AS BIGINT)'
												EXEC sp_executesql @sqlCommand
												SET @sqlCommand = 'UPDATE '+ @entity + '
												SET ' + @entity + '.' + @itemFieldName + ' = CAST('+ CAST( @maxItemNumber AS  VARCHAR ) +' AS INT)
												FROM '+ @tableName + ' '+ @entity + '
												WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT)'
												EXEC sp_executesql @sqlCommand
												SET @newItemNumber = @maxItemNumber;
											END
											If(ISNULL(@maxItemNumId,0)<>0) AND (@existingItemNumber=@itemNumber)
											BEGIN
											SET @newItemNumber=@existingItemNumber
											END 
									END
								ELSE-----USER  IS INSERTING JUST INSERT  MAXIMUM +1
								SET @newItemNumber = @maxItemNumber+1
						END
						ELSE ------ SAME ITEM NUMBER EXISTS FOR OTHER RECORD
						BEGIN
						IF(ISNULL(@id,0) = 0) --USER IS INSERTING --INSERT AND SHIFT
								BEGIN
								SET @sqlCommand = ';WITH CTE AS
								(
								SELECT '+  @entity + '.'+ @pKFieldName +',
								ROW_NUMBER() OVER (ORDER BY '+ @entity + '.'+ @itemFieldName +' ASC) AS RN
								FROM '+ @tableName + ' '+ @entity 
								if(@entity <>'JobGateway')
								BEGIN
								SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
								END
								
								SET @sqlCommand+= ' '+ @joins + ' WHERE 1=1 ' + @where + ' AND ' + @entity + '.' + @itemFieldName +' > (CAST('+ CAST( @itemNumber AS  VARCHAR ) +' AS INT)) - 1)
								UPDATE '+ @entity + '
								SET ' + @entity + '.' + @itemFieldName +' = (ct.RN + (CAST('+ CAST( @itemNumber AS  VARCHAR ) +' AS INT)))
								FROM '+ @tableName + ' '+ @entity 

								if(@entity <>'JobGateway')
								BEGIN
								SET @sqlCommand +=	' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId'
								END
								

								SET @sqlCommand+= ' INNER JOIN cte ct ON ' + @entity + '.'+ @pKFieldName + ' = ct.'+ @pKFieldName +  ' ' + @joins + '
								WHERE 1=1 ' + @where
								EXEC sp_executesql @sqlCommand
								SET @newItemNumber = @itemNumber;
							END 
						ELSE --- DO SWAPPING
								BEGIN
								SET @sqlCommand = 'SELECT @existingItemNumber = '  + @entity + '.' + @itemFieldName + ' FROM '+ @tableName + ' '+ @entity + ' WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT)'
								EXEC sp_executesql @sqlCommand, N' @existingItemNumber int output', @existingItemNumber output
									BEGIN
									SET @sqlCommand = 'UPDATE '+ @entity + '
									SET ' + @entity + '.' + @itemFieldName + ' = CAST('+ CAST( @existingItemNumber AS  VARCHAR ) +' AS INT)
									FROM '+ @tableName + ' '+ @entity + '
									WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @newItemId AS  VARCHAR ) +' AS BIGINT)'
									EXEC sp_executesql @sqlCommand
									SET @sqlCommand = 'UPDATE '+ @entity + '
									SET ' + @entity + '.' + @itemFieldName + ' = CAST('+ CAST( @itemNumber AS  VARCHAR ) +' AS INT)
									FROM '+ @tableName + ' '+ @entity + '
									WHERE '  +  @entity + '.'+ @pKFieldName + ' =  CAST('+ CAST( @id AS  VARCHAR ) +' AS BIGINT)'
									EXEC sp_executesql @sqlCommand
									SET @newItemNumber = @itemNumber;
									END
								END
						END
               END
		END		   			
	END
ELSE --Reordering from begining since we are making record inactive 
BEGIN
      IF ((ISNULL(@id,0)=0) AND (@entity  ='JobGateway' OR @entity  ='PrgRefGatewayDefault' OR @entity  ='JobDocReference') ) 
	  BEGIN
	  EXEC GetEntitySettingWhereClause @entity,@id,@joins,@userid,'ItemNumber', @deletedKeys, @settingsWhere OUTPUT  
	  SET @where += @settingsWhere
	  END
    SET @sqlCommand = dbo.ResetJobsItemNumberSQL(@id,@tableName,@pKFieldName,@itemFieldName ,@parentKeyName ,@entity,@userId,@where,@joins);
  
	EXEC sp_executesql @sqlCommand
	SET @newItemNumber = @@ROWCOUNT
END
	
END TRY                        
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH
GO
PRINT N'Altering [dbo].[UpdJobDocReference]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Job Doc Reference
-- Execution:                 EXEC [dbo].[UpdJobDocReference]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE  [dbo].[UpdJobDocReference]  
	(@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@id bigint  
	,@jobId bigint = NULL 
	,@jdrItemNumber int = NULL  
	,@jdrCode nvarchar(20) = NULL  
	,@jdrTitle nvarchar(50) = NULL  
	,@docTypeId INT = NULL  
	,@jdrAttachment int = NULL  
	,@jdrDateStart datetime2(7) = NULL  
	,@jdrDateEnd datetime2(7) = NULL  
	,@jdrRenewal bit = NULL  
	,@statusId int = NULL  
	,@changedBy nvarchar(50) = NULL  
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0
	,@where nvarchar(200)=NULL )   
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @updatedItemNumber INT        

 DECLARE  @olddocTypeId INT 
 DECLARE  @primaryId INT 
 SET @primaryId =@id;
 --SELECT @olddocTypeId = DocTypeId from JOBDL040DocumentReference WHERE id= @id;
 --IF @olddocTypeId <> @docTypeId
 --BEGIN
 --   SET @primaryId = 0
 --END
-- DECLARE @where NVARCHAR(MAX) =  ' AND DocTypeId ='  +  CAST(@docTypeId AS VARCHAR)   
  EXEC [dbo].[ResetItemNumber] @userId, @primaryId, @jobId, @entity, @jdrItemNumber, @statusId, NULL, @where,  @updatedItemNumber OUTPUT 
 UPDATE [dbo].[JOBDL040DocumentReference]  
  SET  [JobID]              = CASE WHEN (@isFormView = 1) THEN @jobId WHEN ((@isFormView = 0) AND (@jobId=-100)) THEN NULL ELSE ISNULL(@jobId, JobID) END  
      ,[JdrItemNumber]      = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, JdrItemNumber)  END
   ,[JdrCode]               = CASE WHEN (@isFormView = 1) THEN @JdrCode WHEN ((@isFormView = 0) AND (@JdrCode='#M4PL#')) THEN NULL ELSE ISNULL(@JdrCode, JdrCode)  END
   ,[JdrTitle]              = CASE WHEN (@isFormView = 1) THEN @JdrTitle WHEN ((@isFormView = 0) AND (@JdrTitle='#M4PL#')) THEN NULL ELSE ISNULL(@JdrTitle, JdrTitle)  END
   ,[DocTypeId]             = CASE WHEN (@isFormView = 1) THEN @docTypeId WHEN ((@isFormView = 0) AND (@docTypeId=-100)) THEN NULL ELSE ISNULL(@docTypeId, DocTypeId)  END
   ,[StatusId]				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId )  END
   --,[JdrAttachment]         = CASE WHEN (@isFormView = 1) THEN @JdrAttachment WHEN ((@isFormView = 0) AND (@JdrAttachment=-100)) THEN NULL ELSE ISNULL(@JdrAttachment, JdrAttachment) END 
   ,[JdrDateStart]          = CASE WHEN (@isFormView = 1) THEN @JdrDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @JdrDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@JdrDateStart, JdrDateStart)  END
   ,[JdrDateEnd]            = CASE WHEN (@isFormView = 1) THEN @JdrDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @JdrDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@JdrDateEnd , JdrDateEnd)  END
   ,[JdrRenewal]            = ISNULL(@JdrRenewal, JdrRenewal)  
   ,[ChangedBy]             = @changedBy  
   ,[DateChanged]           = @dateChanged  
  WHERE   [Id] = @id  
 SELECT job.[Id]  
  ,job.[JobID]  
  ,job.[JdrItemNumber]  
  ,job.[JdrCode]  
  ,job.[JdrTitle]  
  ,job.[DocTypeId]  
  ,job.[StatusId]  
  ,job.[JdrAttachment]  
  ,job.[JdrDateStart]  
  ,job.[JdrDateEnd]  
  ,job.[JdrRenewal]  
  ,job.[EnteredBy]  
  ,job.[DateEntered]  
  ,job.[ChangedBy]  
  ,job.[DateChanged]  
  FROM   [dbo].[JOBDL040DocumentReference] job  
 WHERE   [Id] = @id  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
PRINT N'Update complete.';


GO
