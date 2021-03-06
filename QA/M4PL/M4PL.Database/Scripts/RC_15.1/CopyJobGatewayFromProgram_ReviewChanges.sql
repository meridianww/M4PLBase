/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */        
-- =============================================                
-- Author:                    Sanyogita Pandey               
-- Create date:               11/16/2018              
-- Description:              Copy Job gateway from program        
-- Execution:                 EXEC [dbo].[InsJob]        
-- Modified on:          
-- Modified Desc:          
-- =============================================              
              
ALTER PROCEDURE  [dbo].[CopyJobGatewayFromProgram]              
     (
	 @JobID BIGINT,
	 @ProgramID  bigint,
	 @dateEntered datetime2(7),
	 @enteredBy nvarchar(50),
	 @userId BIGINT
	 )
AS              
BEGIN TRY                              
 SET NOCOUNT ON;                 
 --Adding this to handle job gatweay item number issue
DECLARE @updatedItemNumber INT;
DECLARE @prgGtwy TABLE(GWYROWID int identity(1,1) primary key,GtwyID int,JobType NVARCHAR(50),ShpmntType NVARCHAR(50))
DECLARE @gtwyCounter INT=1, @maxGatewayId int

INSERT INTO @prgGtwy SELECT DISTINCT GatewayTypeId,prgm.PgdOrderType,prgm.PgdShipmentType FROM [dbo].[PRGRM010Ref_GatewayDefaults] prgm              
  INNER JOIN  [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId              
  WHERE PgdGatewayDefault = 1 AND prgm.PgdProgramID = @programId

SELECT @maxGatewayId=COUNT(*) FROM @prgGtwy

WHILE(@gtwyCounter<=@maxGatewayId)
BEGIN
 INSERT INTO [dbo].[JOBDL020Gateways]              
    (JobID              
    ,ProgramID        
    ,GwyGatewaySortOrder              
    ,GwyGatewayCode              
    ,GwyGatewayTitle              
    ,GwyGatewayDuration              
    ,GwyGatewayDescription              
    ,GwyComment              
    ,GatewayUnitId              
    ,GwyGatewayDefault              
    ,GatewayTypeId              
    ,GwyDateRefTypeId         
 ,Scanner         
 ,GwyShipApptmtReasonCode        
 ,GwyShipStatusReasonCode          
 ,GwyGatewayResponsible      
 ,GwyGatewayAnalyst      
 ,GwyOrderType      
 ,GwyShipmentType            
    ,StatusId              
    ,DateEntered              
    ,EnteredBy              
    )              
 SELECT                 
  @JobID              
    ,prgm.[PgdProgramID]
	 ,ROW_NUMBER() OVER(ORDER BY prgm.[PgdGatewaySortOrder])        
    ,prgm.[PgdGatewayCode]                      
    ,prgm.[PgdGatewayTitle]               
    ,prgm.[PgdGatewayDuration]            
    ,prgm.[PgdGatewayDescription]                  
    ,prgm.[PgdGatewayComment]           
    ,prgm.[UnitTypeId]                      
    ,prgm.[PgdGatewayDefault]                   
    ,(SELECT GtwyID FROM @prgGtwy WHERE GWYROWID=@gtwyCounter)                       
    ,prgm.[GatewayDateRefTypeId]           
  ,prgm.[Scanner]         
  ,prgm.PgdShipApptmtReasonCode        
  ,prgm.PgdShipStatusReasonCode           
  ,prgm.PgdGatewayResponsible      
  ,prgm.PgdGatewayAnalyst        
  ,(SELECT JobType FROM @prgGtwy WHERE GWYROWID=@gtwyCounter)    
  ,(SELECT ShpmntType FROM @prgGtwy WHERE GWYROWID=@gtwyCounter)         
  ,194 --prgm.[StatusId]     given 194 as gateway status lookup's 'Active' status id            
 ,@dateEntered              
 ,@enteredBy              
  FROM [dbo].[PRGRM010Ref_GatewayDefaults] prgm     
   INNER JOIN  [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId 
   WHERE PgdGatewayDefault = 1 AND prgm.PgdProgramID = @programId 
  AND prgm.GatewayTypeId=(SELECT GTWYID FROM @prgGtwy WHERE GWYROWID=@gtwyCounter) 
  AND prgm.PgdOrderType =(SELECT JobType FROM @prgGtwy WHERE GWYROWID=@gtwyCounter)
  AND prgm.PgdShipmentType=(SELECT ShpmntType FROM @prgGtwy WHERE GWYROWID=@gtwyCounter)  
  ORDER BY prgm.[PgdGatewaySortOrder];              

SET @gtwyCounter=@gtwyCounter+1
END
                           
END TRY                            
BEGIN CATCH                              
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                              
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                              
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                              
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                              
END CATCH