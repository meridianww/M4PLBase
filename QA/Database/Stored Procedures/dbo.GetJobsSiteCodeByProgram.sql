
/****** Object:  StoredProcedure [dbo].[GetJobsSiteCodeByProgram]    Script Date: 8/5/2019 5:21:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Nikhil Chauhan           
-- Create date:               08/2/2019       
-- Description:               Get SiteCode for Program Id passed
-- Execution:                 EXEC [dbo].[GetJobsSiteCodeByProgram]     
  
-- =============================================        C
Create PROCEDURE [dbo].[GetJobsSiteCodeByProgram]
    @userId BIGINT,      
    @roleId BIGINT,      
    @orgId BIGINT,      
    @id BIGINT,  
 @parentId BIGINT      
AS      
BEGIN TRY                      
 SET NOCOUNT ON;      
   

 SELECT pvl.PvlLocationCode,PvlVendorID
  FROM [PRGRM051VendorLocations]  pvl  Inner join  PRGRM000MASTER  pm on  pm.Id = pvl.PvlProgramID  where pm.id = @parentId and  pvl.StatusId  IN (1,2)   and pm.PrgOrgID =@orgId
      
  
   


END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH