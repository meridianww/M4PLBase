SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana             
-- Create date:               08/16/2018      
-- Description:               Get a Reference Lookup
-- Execution:                 EXEC [dbo].[GetRefLookup]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================         
CREATE PROCEDURE  [dbo].[GetRefLookup]        
    @userId BIGINT,        
    @roleId BIGINT,        
 @orgId BIGINT ,      
 @referenceType NVARCHAR(25)      
AS        
BEGIN TRY                        
 SET NOCOUNT ON;       
       
 IF @referenceType = 'Global'      
 BEGIN      
     SELECT LkupCode,LkupTableName FROM [dbo].[SYSTM000Ref_Lookup] WHERE LkupTableName=@referenceType;      
 END      
 ELSE IF @referenceType = 'Entity'      
 BEGIN      
     SELECT LkupCode,LkupTableName FROM [dbo].[SYSTM000Ref_Lookup] --WHERE TableName = 'Global' ;      
 END     
 ELSE      
 BEGIN      
        SELECT LkupCode,LkupTableName FROM [dbo].[SYSTM000Ref_Lookup]      
 END      
           
          
        
END TRY                        
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH
GO
