SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  

  CREATE PROCEDURE [dbo].[ProgramGatewayCopy]
  (
    @programId BIGINT,
	@enteredBy NVARCHAR(50),
	@fromRecordId BIGINT,
	@PacificDateTime DATETIME2(7)
  )
  AS 
  BEGIN
   SET NOCOUNT ON;   
  INSERT INTO [dbo].[PRGRM010Ref_GatewayDefaults]      
			  (  [PgdProgramID]      
			  ,[PgdGatewaySortOrder]      
			  ,[PgdGatewayCode]      
			  ,[PgdGatewayTitle]      
			  ,[PgdGatewayDescription]      
			  ,[PgdGatewayDuration]      
			  ,[UnitTypeId]      
			  ,[PgdGatewayDefault]      
			  ,[GatewayTypeId]      
			  ,[GatewayDateRefTypeId]      
			  ,[Scanner]      
			  ,[PgdShipStatusReasonCode]      
			  ,[PgdShipApptmtReasonCode]      
			  ,[PgdOrderType]      
			  ,[PgdShipmentType]      
			  ,[PgdGatewayResponsible]      
			  ,[PgdGatewayAnalyst]      
			  ,[StatusId]      
			  ,[PgdGatewayComment]      
			  ,[DateEntered]      
			  ,[EnteredBy]      
			  )      
      
			SELECT       
			 @programId      
			,[PgdGatewaySortOrder]     
			,[PgdGatewayCode]      
			,[PgdGatewayTitle]      
			,[PgdGatewayDescription]      
			,[PgdGatewayDuration]      
			,[UnitTypeId]      
			,[PgdGatewayDefault]      
			,[GatewayTypeId]      
			,[GatewayDateRefTypeId]      
			,[Scanner]      
			,[PgdShipStatusReasonCode]      
			,[PgdShipApptmtReasonCode]      
			,[PgdOrderType]      
			,[PgdShipmentType]      
			,[PgdGatewayResponsible]      
			,[PgdGatewayAnalyst]      
			,[StatusId]      
			,[PgdGatewayComment]      
			,@PacificDateTime      
			,@enteredBy            
			FROM [PRGRM010Ref_GatewayDefaults] WHERE PgdProgramID= @fromRecordId     
			ORDER BY PgdGatewaySortOrder;  
END
GO
