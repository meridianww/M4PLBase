USE [M4PL_DEV]
GO
/****** Object:  StoredProcedure [dbo].[GetOrganization]    Script Date: 3/29/2019 5:13:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               08/16/2018      
-- Description:               Get a Organization
-- Execution:                 EXEC [dbo].[GetOrganization]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetOrganization] 
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 SELECT  org.[Id]
        ,org.[OrgCode]
        ,org.[OrgTitle]
        ,org.[OrgGroupId]
        ,CASE WHEN EXISTS(SELECT Id FROM SYSTM000OpnSezMe WHERE id=@userId and IsSysAdmin =1) THEN  org.[OrgSortOrder] ELSE 1 END AS OrgSortOrder
		--,org.[OrgSortOrder]
        ,org.[StatusId]
        ,org.[DateEntered]
        ,org.[EnteredBy]
        ,org.[DateChanged]
        ,org.[ChangedBy]
        ,org.[OrgContactId]
        ,org.[OrgImage]
   FROM [dbo].[ORGAN000Master] org
  WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH