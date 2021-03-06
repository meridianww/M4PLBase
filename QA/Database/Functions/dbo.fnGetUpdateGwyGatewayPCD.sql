SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author       : Prasanta Mahankuda      
-- Create date  : 08 January 2020    
-- Description  : To Get Updated GwyGatewayPCD   
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- =============================================  
CREATE FUNCTION [dbo].[fnGetUpdateGwyGatewayPCD]  
(  
 @GatewayUnitId BIGINT,
 @GwyGatewayDuration decimal(18, 2),
 @GwyGatewayPCD datetime2(7) = NULL
)  
RETURNS datetime2(7)  
AS  
BEGIN  
  DECLARE @GatewayUnit VARCHAR(20);
  SELECT  @GatewayUnit =SysOptionName from SYSTM000Ref_Options where id =@GatewayUnitId 
  DECLARE @PCDDATE datetime2(7) = NULL; 
  SET @PCDDATE = @GwyGatewayPCD
  IF(@GatewayUnit = 'Hour' OR @GatewayUnit = 'Hours')
  BEGIN
    SELECT @PCDDATE = DATEADD(hour,@GwyGatewayDuration,@GwyGatewayPCD)  
  END
  ELSE IF(@GatewayUnit = 'Minute' OR @GatewayUnit = 'Minutes')
  BEGIN
    SELECT @PCDDATE = DATEADD(minute,@GwyGatewayDuration,@GwyGatewayPCD)  
  END
  ELSE IF(@GatewayUnit = 'Week' OR @GatewayUnit = 'Weeks')
  BEGIN
    SELECT @PCDDATE = DATEADD(Week,@GwyGatewayDuration,@GwyGatewayPCD)  
  END
  ELSE IF(@GatewayUnit = 'Months' OR @GatewayUnit = 'Month')
  BEGIN
    SELECT @PCDDATE = DATEADD(Month,@GwyGatewayDuration,@GwyGatewayPCD)  
  END
  ELSE IF(@GatewayUnit = 'Days' OR @GatewayUnit = 'Day')
  BEGIN
    SELECT @PCDDATE = DATEADD(day,@GwyGatewayDuration,@GwyGatewayPCD)  
  END 
  RETURN @PCDDATE  
END
GO
