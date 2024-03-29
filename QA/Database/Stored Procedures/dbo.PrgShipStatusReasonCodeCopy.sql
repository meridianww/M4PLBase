SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  

  CREATE  PROCEDURE [dbo].[PrgShipStatusReasonCodeCopy]
  (
    @programId BIGINT,
	@enteredBy NVARCHAR(50),
	@fromRecordId BIGINT,
	@PacificDateTime DATETIME2(7)
  )
  AS 
  BEGIN
   SET NOCOUNT ON;   

  INSERT INTO [dbo].[PRGRM030ShipStatusReasonCodes]
           ( [PscOrgID]
			,[PscProgramID]
			,[PscShipItem]
			,[PscShipReasonCode]
			,[PscShipLength]
			,[PscShipInternalCode]
			,[PscShipPriorityCode]
			,[PscShipTitle]
			,[PscShipCategoryCode]
			,[PscShipUser01Code]
			,[PscShipUser02Code]
			,[PscShipUser03Code]
			,[PscShipUser04Code]
			,[PscShipUser05Code]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy])
      
			SELECT 
			 [PscOrgID]
			,@programId   
			,[PscShipItem]
			,[PscShipReasonCode]
			,[PscShipLength]
			,[PscShipInternalCode]
			,[PscShipPriorityCode]
			,[PscShipTitle]
			,[PscShipCategoryCode]
			,[PscShipUser01Code]
			,[PscShipUser02Code]
			,[PscShipUser03Code]
			,[PscShipUser04Code]
			,[PscShipUser05Code]
			,[StatusId]  
			,@PacificDateTime      
			,@enteredBy            
			FROM [PRGRM030ShipStatusReasonCodes] WHERE [PscProgramID]= @fromRecordId   AND StatusId IN(1,2)   
			
END
GO
