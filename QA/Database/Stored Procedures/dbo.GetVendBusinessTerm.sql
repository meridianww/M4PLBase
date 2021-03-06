SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/16/2018      
-- Description:               Get a vend business term 
-- Execution:                 EXEC [dbo].[GetVendBusinessTerm]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetVendBusinessTerm]
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
SELECT vend.[Id]
      ,vend.[LangCode]
      ,vend.[VbtOrgID]
      ,vend.[VbtVendorID]
      ,vend.[VbtItemNumber]
      ,vend.[VbtCode]
      ,vend.[VbtTitle]
      ,vend.[BusinessTermTypeId]
      ,vend.[VbtActiveDate]
      ,vend.[VbtValue]
      ,vend.[VbtHiThreshold]
      ,vend.[VbtLoThreshold]
      ,vend.[VbtAttachment]
      ,vend.[StatusId]
      ,vend.[EnteredBy]
      ,vend.[DateEntered]
      ,vend.[ChangedBy]
      ,vend.[DateChanged]
  FROM [dbo].[VEND020BusinessTerms] vend
 WHERE [Id]=@id 
END
ELSE
 BEGIN
SELECT vend.[Id]
      ,vend.[LangCode]
      ,vend.[VbtOrgID]
      ,vend.[VbtVendorID]
      ,vend.[VbtItemNumber]
      ,vend.[VbtCode]
      ,vend.[VbtTitle]
      ,vend.[BusinessTermTypeId]
      ,vend.[VbtActiveDate]
      ,vend.[VbtValue]
      ,vend.[VbtHiThreshold]
      ,vend.[VbtLoThreshold]
      ,vend.[VbtAttachment]
      ,vend.[StatusId]
      ,vend.[EnteredBy]
      ,vend.[DateEntered]
      ,vend.[ChangedBy]
      ,vend.[DateChanged]
  FROM [dbo].[VEND020BusinessTerms] vend
 WHERE [Id]=@id  
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
