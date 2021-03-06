SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Sys Ref Option
-- Execution:                 EXEC [dbo].[GetSysRefOption]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetSysRefOption]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
IF(@langCode='EN')
 BEGIN
SELECT refOp.[Id]
	,refOp.[SysLookupId]
	,refOp.[SysOptionName]
	,refOp.[SysSortOrder]
	,refOp.[SysDefault]
	,refOp.[IsSysAdmin]
	,refOp.[StatusId]
	,refOp.[DateEntered]
	,refOp.[EnteredBy]
	,refOp.[DateChanged]
	,refOp.[ChangedBy]
	,lkup.[LkupCode] as LookupIdName
  FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) refOp
  INNER JOIN [dbo].[SYSTM000Ref_Lookup] (NOLOCK) lkup ON lkup.Id = refOp.SysLookupId
 WHERE refOp.[Id]=@id 
END
ELSE
 BEGIN
SELECT refOp.[Id]
	,refOp.[SysLookupId]
	,refOpLang.[SysOptionName]
	,refOp.[SysSortOrder]
	,refOp.[SysDefault]
	,refOp.[IsSysAdmin]
	,refOp.[StatusId]
	,refOp.[DateEntered]
	,refOp.[EnteredBy]
	,refOp.[DateChanged]
	,refOp.[ChangedBy]
	,lkup.[LkupCode] as LookupIdName
  FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) refOp
 INNER JOIN [dbo].[SYSTM010Ref_Options] refOpLang ON refOp.Id = refOpLang.[SysRefId]
 INNER JOIN [dbo].[SYSTM000Ref_Lookup] (NOLOCK) lkup ON lkup.Id = refOp.SysLookupId
 WHERE refOp.[Id]=@id AND refOpLang.LangCode=@langCode
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
