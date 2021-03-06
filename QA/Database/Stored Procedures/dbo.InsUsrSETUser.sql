SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a usr SET user 
-- Execution:                 EXEC [dbo].[InsUsrSETUser]
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[InsUsrSETUser]		  
		    @userId BIGINT
		   ,@roleCode NVARCHAR(25)
		   ,@usrUserId int 
           ,@usrOrgId int 
           ,@usrBackgroundImage image 
           ,@usrCompanyLogo image 
           ,@usrLoginLogo image 
           ,@usrSiteFavicon image 
           ,@usrPageSize int 
           ,@usrDateEntered datetime2(7) 
           ,@usrEnteredBy nvarchar(50)   
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   INSERT INTO [dbo].[SET000User]
           ([UserId]
           ,[OrgId]
           ,[BackgroundImage]
           ,[CompanyLogo]
           ,[LoginLogo]
           ,[SiteFavicon]
           ,[PageSize]
           ,[DateEntered]
           ,[EnteredBy] )
     VALUES
		   (@usrUserId   
           ,@usrOrgId   
           ,@usrBackgroundImage   
           ,@usrCompanyLogo   
           ,@usrLoginLogo   
           ,@usrSiteFavicon   
           ,@usrPageSize   
           ,@usrDateEntered  
           ,@usrEnteredBy )
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdUsrSetUser]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
