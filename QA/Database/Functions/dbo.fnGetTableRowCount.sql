SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara
-- Create date:               05/09/2018      
-- Description:               Get Row Count based on table
-- Execution:                 SELECT FROM  [dbo].[fnGetTableRowCount]
-- Modified on:  
-- Modified Desc:  
-- ============================================= 

CREATE  FUNCTION [dbo].[fnGetTableRowCount]
(
 @entity varchar(50)
,@fieldName varchar(100)
,@value varchar(100)
,@where NVARCHAR(MAX)
)
returns int
as
begin

 DECLARE @sqlCommand NVARCHAR(MAX),@attachmentCount INT = 0
 DECLARE  @tableName NVARCHAR(100) 
 select @tableName =TblTableName FROM [dbo].[SYSTM000Ref_Table] WHERE SysRefName =  @entity
 SET @sqlCommand = 'SELECT @attachmentCount = Count(*)  FROM ' + @tableName + ' WHERE ' + @fieldName + ' =  ''' + @value + '''  AND ISNULL(StatusId,0) = 1';

 IF LEN(ISNULL(@where,'')) > 0
 BEGIN
   SET @sqlCommand   =  @sqlCommand + ' ' + @where;

 END
  EXEC sp_executesql @sqlCommand, N' @attachmentCount int output',@attachmentCount output 
 
  
  return ISNULL(@attachmentCount,0);

end
GO
