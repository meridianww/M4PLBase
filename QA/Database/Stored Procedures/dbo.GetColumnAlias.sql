SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Sys Column alias
-- Execution:                 EXEC [dbo].[GetColumnAlias]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetColumnAlias]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON; 
 
 SELECT cal.[Id]
      ,cal.[LangCode]
      ,cal.[ColTableName]
      ,cal.[ColColumnName]
      ,cal.[ColAliasName]
      ,cal.[ColCaption]
      ,cal.[ColDescription]
      ,cal.[ColSortOrder]
      ,cal.[ColIsReadOnly]
      ,cal.[ColIsVisible]
      ,cal.[ColIsDefault]
	  ,cal.[StatusId]
	  ,cal.[IsGridColumn]
	  ,cal.ColGridAliasName
  FROM [dbo].[SYSTM000ColumnsAlias] cal
 WHERE cal.[Id]=@id  AND cal.LangCode=@langCode
 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
