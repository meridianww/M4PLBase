SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Sys ZipCode  
-- Execution:                 EXEC [dbo].[GetSysZipCode]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetSysZipCode]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT syst.[Zipcode]
      ,syst.[ZipCity]
      ,syst.[ZipState]
      ,syst.[ZipLatitude]
      ,syst.[ZipLongitude]
      ,syst.[ZipTimezone]
      ,syst.[ZipDST]
      ,syst.[MrktID]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM000ZipcodeMaster] syst
 WHERE [Zipcode]=@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
