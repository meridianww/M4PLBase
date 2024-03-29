SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Ins a security by role
-- Execution:                 EXEC [dbo].[InsSecurityByRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
  
CREATE PROCEDURE  [dbo].[InsSecurityByRole]  
	(@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@orgId bigint 
	,@secLineOrder int  = NULL  
	,@mainModuleId int  
	,@menuOptionLevelId int  
	,@menuAccessLevelId int  
	,@statusId int = NULL  
	,@actRoleId BIGINT
	,@dateEntered datetime2(7)  
	,@enteredBy nvarchar(50)  
)  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @updatedItemNumber INT
 DECLARE @currentId BIGINT;  
 SELECT TOP 1 @secLineOrder = [SecLineOrder] + 1 FROM [dbo].[SYSTM000SecurityByRole]  WHERE  [OrgRefRoleId] = @actRoleId ORDER BY SecLineOrder DESC
 SET @secLineOrder = ISNULL(@secLineOrder, 1)
EXEC [dbo].[ResetItemNumber] @userId, 0, @actRoleId, @entity, @secLineOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
 INSERT INTO [dbo].[SYSTM000SecurityByRole]  
           (
   [OrgRefRoleId]
   ,[SecLineOrder]  
   ,[SecMainModuleId]  
   ,[SecMenuOptionLevelId]  
   ,[SecMenuAccessLevelId]  
   ,[StatusId]  
   ,[DateEntered]  
   ,[EnteredBy])  
     VALUES  
           (
      @actRoleId
      ,@updatedItemNumber   
      ,@mainModuleId  
      ,@menuOptionLevelId  
      ,@menuAccessLevelId  
   ,@statusId  
      ,@dateEntered  
      ,@enteredBy)   
   SET @currentId = SCOPE_IDENTITY(); 
   
   EXECUTE  GetSecurityByRole @userId,@roleId,@orgId,@currentId;
 
END TRY                
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
