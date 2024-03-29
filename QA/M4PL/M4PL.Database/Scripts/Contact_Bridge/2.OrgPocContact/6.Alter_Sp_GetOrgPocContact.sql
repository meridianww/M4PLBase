USE [M4PL_Test]
GO
/****** Object:  StoredProcedure [dbo].[GetOrgPocContact]    Script Date: 5/9/2019 5:08:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a org POC contact   
-- Execution:                 EXEC [dbo].[GetOrgPocContact]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- Modified on:				  04/26/2018(Kirty)    
-- Modified Desc:			  Removed condition for @orgId, as this is belongs to loged in user
-- =============================================
ALTER PROCEDURE  [dbo].[GetOrgPocContact]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT conBridge.[Id]
      ,conBridge.[ConOrgId]
      ,conBridge.[ContactMSTRID]
      ,conBridge.[ConCodeId]
      ,conBridge.[ConTitle]
      ,conBridge.[ConTypeId]
	  ,conBridge.[ConTableTypeId]
      ,conBridge.[ConIsDefault]
      ,conBridge.[StatusId]
      ,conBridge.[DateEntered]
      ,conBridge.[EnteredBy]
      ,conBridge.[DateChanged]
      ,conBridge.[ChangedBy]
      ,conBridge.[ConItemNumber]
   FROM [dbo].[CONTC010Bridge] conBridge WITH(NOLOCK)
  
   WHERE conBridge.Id = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
