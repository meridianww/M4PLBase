SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a vend doc ref
-- Execution:                 EXEC [dbo].[GetVendDocReference]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetVendDocReference]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT vend.[Id]
      ,vend.[VdrOrgID]
      ,vend.[VdrVendorID]
      ,vend.[VdrItemNumber]
      ,vend.[VdrCode]
      ,vend.[VdrTitle]
      ,vend.[DocRefTypeId]
      ,vend.[DocCategoryTypeId]
      ,vend.[VdrAttachment]
      ,vend.[VdrDateStart]
      ,vend.[VdrDateEnd]
      ,vend.[VdrRenewal]
      ,vend.[StatusId]
      ,vend.[EnteredBy]
      ,vend.[DateEntered]
      ,vend.[ChangedBy]
      ,vend.[DateChanged]
  FROM [dbo].[VEND030DocumentReference] vend
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
