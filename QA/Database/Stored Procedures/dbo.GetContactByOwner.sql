SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/15/2018      
-- Description:               Get Contacts by Owner
-- Execution:                 EXEC [dbo].[GetContactByOwner] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE [dbo].[GetContactByOwner]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @custId BIGINT,
 @vendId BIGINT,
 @progId BIGINT,
 @jobId BIGINT,
 @contactId BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 DECLARE @sqlCommand NVARCHAR(MAX);
 
SELECT TOP 1 * FROM [dbo].[CONTC000Master] (NOLOCK) WHERE Id = @contactId 

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
