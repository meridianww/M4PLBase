SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               12/17/2018      
-- Description:               Get a System Account
-- Execution:                 EXEC [dbo].[GetSystemAccount] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE  [dbo].[GetSystemAccount]    
	@userId BIGINT,    
	@roleId BIGINT,    
	@orgId BIGINT,   
	@langCode NVARCHAR(10),        
	@id BIGINT    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;       
  SELECT OpenSez.[Id]    
      ,OpenSez.[SysUserContactID]    
      ,OpenSez.[SysScreenName]    
      ,OpenSez.[SysPassword]    
      ,OpenSez.[SysOrgId]    
      ,OpenSez.[SysOrgRefRoleId]    
      ,OpenSez.[IsSysAdmin]    
      ,OpenSez.[SysAttempts]    
      ,OpenSez.[SysLoggedIn]    
      ,OpenSez.[SysLoggedInCount]    
      ,OpenSez.[SysDateLastAttempt]    
      ,OpenSez.[SysLoggedInStart]    
      ,OpenSez.[SysLoggedInEnd]    
      ,OpenSez.[StatusId]    
      ,OpenSez.[DateEntered]    
      ,OpenSez.[EnteredBy]    
      ,OpenSez.[DateChanged]    
      ,OpenSez.[ChangedBy] 
	  ,job.NotScheduleInTransit 
	  ,job.NotScheduleOnHand 
	  ,job.NotScheduleOnTruck 
	  ,job.NotScheduleReturn 
	  ,job.SchedulePastDueInTransit 
	  ,job.SchedulePastDueOnHand 
	  ,job.SchedulePastDueOnTruck 
	  ,job.SchedulePastDueReturn 
	  ,job.ScheduleForTodayInTransit 
	  ,job.ScheduleForTodayOnHand 
	  ,job.ScheduleForTodayOnTruck 
	  ,job.ScheduleForTodayReturn 
	  ,job.xCBLAddressChanged 
	  ,job.xCBL48HoursChanged 
	  ,job.NoPODCompletion 
  FROM [dbo].[SYSTM000OpnSezMe] OpenSez
  INNER JOIN [dbo].[JobCardMappingByUser] (NOLOCK) job ON job.[UserID] = OpenSez.Id
 WHERE OpenSez.[Id]=@id AND job.UserID=@id   
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
