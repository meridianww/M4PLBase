SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Org MRKT Org Support
-- Execution:                 EXEC [dbo].[InsOrgMarketSupport]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE  [dbo].[InsOrgMarketSupport]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@mrkOrder INT = NULL
	,@mrkCode NVARCHAR(20) = NULL 
	,@mrkTitle NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@enteredBy NVARCHAR(50) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @orgId, @entity, @mrkOrder, NULL, NULL, NULL,  @updatedItemNumber OUTPUT  
 
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[ORGAN002MRKT_OrgSupport]
           ([OrgId]
           ,[MrkOrder]
           ,[MrkCode]
           ,[MrkTitle]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
		   (@orgId 
           ,@updatedItemNumber 
           ,@mrkCode 
           ,@mrkTitle 
           ,@dateEntered 
           ,@enteredBy) 	
		   SET @currentId = SCOPE_IDENTITY();
 EXEC [dbo].[GetOrgMarketSupport] @userId, @roleId, @orgId, @currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdOrgMrktOrgSupport]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
