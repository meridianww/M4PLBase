

ALTER TABLE CONTC000Master
ADD CONSTRAINT FK_CONTC000Master_ConOrgId_ORGAN000Master FOREIGN KEY (ConOrgId)
REFERENCES ORGAN000Master(id)
GO


UPDATE SYSTM000ColumnsAlias
   SET 
      [ColColumnName] = 'ConOrgId',
	  ColAliasName = 'Company',
	  ColCaption = 'Company'      
 WHERE ColTableName = 'contact' and ColColumnName ='ConCompany'
GO


update SYSTM000Ref_UserSettings
  set SysJsonSetting = '[{"Entity":73,"EntityName":"JobGateway","Name":"ItemNumber","Value":"AND JobGateway.GatewayTypeId=","ValueType":"int","IsOverWritable":true,"IsSysAdmin":false},{"Entity":73,"EntityName":"JobGateway","Name":"ItemNumber","Value":"AND JobGateway.GwyOrderType=","ValueType":"String","IsOverWritable":true,"IsSysAdmin":false},{"Entity":73,"EntityName":"JobGateway","Name":"ItemNumber","Value":"AND JobGateway.GwyShipmentType=","ValueType":"String","IsOverWritable":true,"IsSysAdmin":false},{"Entity":55,"EntityName":"PrgRefGatewayDefault","Name":"ItemNumber","Value":"AND PrgRefGatewayDefault.GatewayTypeId=","ValueType":"int","IsOverWritable":true,"IsSysAdmin":false},{"Entity":55,"EntityName":"PrgRefGatewayDefault","Name":"ItemNumber","Value":"AND PrgRefGatewayDefault.PgdOrderType=","ValueType":"String","IsOverWritable":true,"IsSysAdmin":false},{"Entity":55,"EntityName":"PrgRefGatewayDefault","Name":"ItemNumber","Value":"AND PrgRefGatewayDefault.PgdShipmentType=","ValueType":"String","IsOverWritable":true,"IsSysAdmin":false},{"Entity":72,"EntityName":"JobDocReference","Name":"ItemNumber","Value":"AND JobDocReference.DocTypeId =","ValueType":"int","IsOverWritable":true,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysMainModuleId","Value":"10","ValueType":"Int","IsOverWritable":true,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysDefaultAction","Value":"Dashboard","ValueType":"String","IsOverWritable":true,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysStatusesIn","Value":"1,2","ValueType":"String","IsOverWritable":true,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysGridViewPageSizes","Value":"30,50,100","ValueType":"String","IsOverWritable":true,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysPageSize","Value":"30","ValueType":"Int","IsOverWritable":true,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysComboBoxPageSize","Value":"10","ValueType":"Int","IsOverWritable":true,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysThresholdPercentage","Value":"10","ValueType":"Int","IsOverWritable":true,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"Theme","Value":"Office2010Black","ValueType":"String","IsOverWritable":true,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysSessionTimeOut","Value":"60","ValueType":"Int","IsOverWritable":true,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysWarningTime","Value":"2","ValueType":"Int","IsOverWritable":true,"IsSysAdmin":false},{"Entity":134,"EntityName":"System","Name":"SysDateFormat","Value":"MM/dd/yyyy","ValueType":"String","IsOverWritable":true,"IsSysAdmin":false},{"Entity":112,"EntityName":"DeliveryStatus","Name":"ReadOnlyRelationalEntity","Value":"OrganizationId","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":100,"EntityName":"SystemAccount","Name":"ReadOnlyRelationalEntity","Value":"SysOrgId","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":45,"EntityName":"VendDocReference","Name":"ReadOnlyRelationalEntity","Value":"VdrOrgID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":45,"EntityName":"VendDocReference","Name":"ReadOnlyRelationalEntity","Value":"VdrVendorID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":46,"EntityName":"VendFinancialCalendar","Name":"ReadOnlyRelationalEntity","Value":"OrgID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":40,"EntityName":"VendBusinessTerm","Name":"ReadOnlyRelationalEntity","Value":"VbtOrgID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":40,"EntityName":"VendBusinessTerm","Name":"ReadOnlyRelationalEntity","Value":"VbtVendorID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":41,"EntityName":"VendContact","Name":"ReadOnlyRelationalEntity","Value":"VendVendorID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":36,"EntityName":"CustDocReference","Name":"ReadOnlyRelationalEntity","Value":"CdrOrgID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":36,"EntityName":"CustDocReference","Name":"ReadOnlyRelationalEntity","Value":"CdrCustomerID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":37,"EntityName":"CustFinancialCalendar","Name":"ReadOnlyRelationalEntity","Value":"OrgID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":37,"EntityName":"CustFinancialCalendar","Name":"ReadOnlyRelationalEntity","Value":"CustID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":31,"EntityName":"CustBusinessTerm","Name":"ReadOnlyRelationalEntity","Value":"CbtOrgID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":31,"EntityName":"CustBusinessTerm","Name":"ReadOnlyRelationalEntity","Value":"CbtCustomerId","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":53,"EntityName":"PrgMvocRefQuestion","Name":"ReadOnlyRelationalEntity","Value":"MVOCID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":34,"EntityName":"CustDcLocation","Name":"ReadOnlyRelationalEntity","Value":"CdcCustomerID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":32,"EntityName":"CustContact","Name":"ReadOnlyRelationalEntity","Value":"CustCustomerID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":39,"EntityName":"Vendor","Name":"ReadOnlyRelationalEntity","Value":"VendOrgID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":30,"EntityName":"Customer","Name":"ReadOnlyRelationalEntity","Value":"CustOrgId","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":10,"EntityName":"OrgPocContact","Name":"ReadOnlyRelationalEntity","Value":"OrgID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":22,"EntityName":"OrgCredential","Name":"ReadOnlyRelationalEntity","Value":"OrgID","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":98,"EntityName":"SecurityByRole","Name":"ReadOnlyRelationalEntity","Value":"OrgId","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":20,"EntityName":"OrgActSecurityByRole","Name":"ReadOnlyRelationalEntity","Value":"OrgId","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true},{"Entity":2,"EntityName":"Organization","Name":"ReadOnlyRelationalEntity","Value":"ConOrgId","ValueType":"Bool","IsOverWritable":false,"IsSysAdmin":true}]'



/****** Object:  StoredProcedure [dbo].[GetContactView]    Script Date: 3/8/2019 4:49:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all contact view
-- Execution:                 EXEC [dbo].[GetContactView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetContactView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
 @parentId BIGINT,
 @isNext BIT,
 @isEnd BIT,
 @recordId BIGINT,
 @TotalCount INT OUTPUT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 DECLARE @sqlCommand NVARCHAR(MAX);
 DECLARE @TCountQuery NVARCHAR(MAX);

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery +' WHERE 1=1 ' + ISNULL(@where, '') + ' AND '+ @entity +'.ConOrgId ='+  CAST(@orgId AS nvarchar(100))

EXEC sp_executesql @TCountQuery, N'@userId BIGINT, @TotalCount INT OUTPUT', @userId , @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.OrgTitle AS ConOrgIdName, sts1.[StateAbbr] AS ConBusinessStateIdName, sts2.[StateAbbr] AS ConHomeStateIdName '
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.Id') + '), 0) AS Id '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.Id') + '), 0) AS Id ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.Id '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity

--Below to get State reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts1 ON ' + @entity + '.[ConBusinessStateId]=sts1.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts2 ON ' + @entity + '.[ConHomeStateId]=sts2.[Id] '
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[ConOrgId]=org.[Id] '

--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

--Below to update order by clause if related to Ref_Options
	IF(ISNULL(@orderBy, '') <> '')
	BEGIN
		DECLARE @orderByJoinClause NVARCHAR(500);
		SELECT @orderBy = OrderClause, @orderByJoinClause=JoinClause FROM [dbo].[fnUpdateOrderByClause](@entity, @orderBy);
		IF(ISNULL(@orderByJoinClause, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + @orderByJoinClause
		END
	END

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '+ ISNULL(@where, '')+ ' AND '+ @entity +'.ConOrgId ='+  CAST(@orgId AS nvarchar(100))

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
	    BEGIN  
	 	IF(ISNULL(@orderBy, '') <> '')
	 	 BEGIN
	 		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 	 END
	 	ELSE
	 	 BEGIN
	 		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id <= '+ CAST(@recordId AS NVARCHAR(50))  
	 	 END
	    END  
	   ELSE IF((@isNext = 1) AND (@isEnd = 0))  
	    BEGIN  
	     IF(ISNULL(@orderBy, '') <> '')
	 	 BEGIN
	 		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 	 END
	 	ELSE
	 	 BEGIN
	 		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))  
	 	 END
	    END  
	END

SET @sqlCommand = @sqlCommand + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.Id')

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
	END
ELSE
	BEGIN
		IF(@orderBy IS NULL)
			BEGIN
				IF(((@isNext = 1) AND (@isEnd = 1)) OR ((@isNext = 0) AND (@isEnd = 0)))
					BEGIN
						SET @sqlCommand = @sqlCommand + ' DESC' 
					END
			END
		ELSE
			BEGIN
				IF(((@isNext = 1) AND (@isEnd = 1)) OR ((@isNext = 0) AND (@isEnd = 0)))
					BEGIN
						SET @sqlCommand = @sqlCommand + ' DESC' 
					END
			END
	END
	print @sqlCommand
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH





