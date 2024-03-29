SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*Copyright (2018) Meridian Worldwide Transportation Group
  All Rights Reserved Worldwide */
-- =====================================================================  
-- Author:                    Akhil         
-- Create date:               04/02/2018
-- Description:               Check Contact LoggedIn or not 
-- Execution:                 EXEC [dbo].[CheckContactLoggedIn] '1'   
-- Modified on:  
-- Modified Desc:  
-- ======================================================================    

CREATE PROCEDURE  [dbo].[CheckContactLoggedIn] 
@id BIGINT
AS

BEGIN TRY
  SET NOCOUNT ON;
  DECLARE @loggedInCount INT = 0;
  SELECT @loggedInCount = ISNULL(SysLoggedIn, 0) FROM [dbo].[SYSTM000OpnSezMe] WHERE SysUserContactID = @id
  IF @loggedInCount = 0
  BEGIN
       SELECT CAST(0 AS BIT) -- RETURNS FASLE
  END
  ELSE 
  BEGIN
      SELECT CAST(1 AS BIT) -- NOT FOUND RETURNS TRUE
  END 
END TRY
BEGIN CATCH                
DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
  ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
  ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
