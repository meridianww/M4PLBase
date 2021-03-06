SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil        
-- Create date:               05/17/2018      
-- Description:               Get Display Message for cache
-- Execution:                 EXEC [dbo].[GetDisplayMessagesByCode]
-- Modified on:  
-- Modified Desc:  
-- =============================================                          
CREATE PROCEDURE [dbo].[GetDisplayMessagesByCode]     
@langCode NVARCHAR(10),  
@msgCode NVARCHAR(25)                  
AS                  
BEGIN TRY                  
  SET NOCOUNT ON;  
   
    SELECT  sysMsg.LangCode  
   ,refOp.SysOptionName as MessageType  
   ,sysMsg.SysMessageCode as Code  
   ,sysMsg.SysMessageScreenTitle as ScreenTitle  
   ,sysMsg.SysMessageTitle as Title  
   ,sysMsg.SysMessageDescription as [Description]  
   ,sysMsg.SysMessageInstruction as Instruction  
   ,sysMsg.SysMessageButtonSelection as MessageOperation  
   ,msgType.SysMsgTypeHeaderIcon as HeaderIcon  
   ,msgType.SysMsgTypeIcon as MessageTypeIcon 
  FROM [dbo].[SYSTM000Master] sysMsg (NOLOCK)  
  INNER JOIN [dbo].[SYSMS010Ref_MessageTypes] msgType (NOLOCK) ON  sysMsg.SysRefId = msgType.SysRefId  
  INNER JOIN [dbo].[SYSTM000Ref_Options] refOp (NOLOCK) ON refOp.Id = msgType.SysRefId    
  WHERE sysMsg.LangCode = @langCode AND sysMsg.SysMessageCode = @msgCode   
     
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
   
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
