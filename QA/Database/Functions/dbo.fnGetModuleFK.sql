SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- =============================================      
-- Author       : Akhil       
-- Create date  : 05 Dec 2017    
-- Description  : To get Module ref FK list    
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- =============================================     
    
CREATE FUNCTION [dbo].[fnGetModuleFK]    
(        
      @tableName NVARCHAR(100)    
)    
RETURNS @Output TABLE (    
      ColumnName NVARCHAR(100),    
   RelationalEntity NVARCHAR(100)    
)   
AS    
BEGIN    
  DECLARE @HkWithoutSpace NVARCHAR(500) ='CONTC000Master,COMP000Master,ORGAN000Master,VEND000Master,CUST000Master,PRGRM000Master,MVOC000Program,JOBDL000Master,JOBDL010Cargo,SYSTM000Ref_States,ORGAN010Ref_Roles,PRGRM020_Roles,SYSTM000ColumnsAlias,CONTC010Bridge,JOBDL023GatewayInstallStatusMaster,JOBDL022GatewayExceptionReason,Event';    
  INSERT INTO @Output    
   SELECT COL_NAME(fc.parent_object_id,fc.parent_column_id) ColName, ref_tbl.SysRefName RelationalEntity    
  FROM sys.foreign_keys AS f    
  INNER JOIN     
   sys.foreign_key_columns AS fc     
    ON f.OBJECT_ID = fc.constraint_object_id    
  INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl ON tbl.TblTableName = OBJECT_NAME(f.parent_object_id)    
  INNER JOIN dbo.fnSplitString(@HkWithoutSpace, ',') hfk ON hfk.Item = OBJECT_NAME (f.referenced_object_id)     
  INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) ref_tbl ON OBJECT_NAME (f.referenced_object_id) = ref_tbl.[TblTableName]    
  WHERE tbl.SysRefName = @tableName    
 RETURN    
END

GO
