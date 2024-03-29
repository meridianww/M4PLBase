SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara
-- Create date:               05/09/2018      
-- Description:               Get  Login error Message
-- Execution:                 SELECT  [dbo].[fnGetLoginErrorMessage]('02.10')
-- Modified on:  
-- Modified Desc:  
-- =============================================     
CREATE FUNCTION  [dbo].[fnGetLoginErrorMessage] (   
    @sysmessageCode NVARCHAR(25)
	--,@sysRefId INT    
 )  
 returns NVARCHAR(MAX)  
  
AS    
BEGIN  
              
  DECLARE @errorMessage NVARCHAR(MAX)   
  SELECT @errorMessage = SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = @sysmessageCode -- and SysRefId = @sysRefId;  
  RETURN @errorMessage;  
  
  END
GO
