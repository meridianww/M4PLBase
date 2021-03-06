SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil        
-- Create date:               12/20/2018      
-- Description:               Get tables 
-- Execution:                 EXEC [dbo].[GetTables]   
-- Modified on:  
-- Modified Desc:  
-- =============================================                          
CREATE PROCEDURE [dbo].[GetTables]     
AS                  
BEGIN TRY                  
 SET NOCOUNT ON;     
 SELECT  refTab.SysRefName  
  ,refTab.LangCode  
  ,refTab.TblLangName
  ,refTab.TblTableName  
  ,refTab.TblMainModuleId  
  ,refOp.[SysOptionName] as MainModuleName 
  ,refTab.TblIcon 
  ,refTab.TblTypeId
  ,refOpType.[SysOptionName] as TblTypeIdName 
 FROM [dbo].[SYSTM000Ref_Table] refTab (NOLOCK)    
 LEFT JOIN [dbo].[SYSTM000Ref_Options] refOp (NOLOCK) ON  refTab.TblMainModuleId= refOp.Id  
 LEFT JOIN [dbo].[SYSTM000Ref_Options] refOpType (NOLOCK) ON  refTab.TblTypeId= refOpType.Id  
 ORDER BY refOp.Id ASC  
END TRY                  
BEGIN CATCH                  
DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
  ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
  ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
  
EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
