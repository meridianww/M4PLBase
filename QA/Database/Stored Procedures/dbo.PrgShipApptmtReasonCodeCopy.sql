SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  

  CREATE  PROCEDURE [dbo].[PrgShipApptmtReasonCodeCopy]
  (
    @programId BIGINT,
	@enteredBy NVARCHAR(50),
	@fromRecordId BIGINT,
	 @PacificDateTime DATETIME2(7)
  )
  AS 
  BEGIN
   SET NOCOUNT ON;   

 INSERT INTO [dbo].[PRGRM031ShipApptmtReasonCodes]
           ( [PacOrgID]
			,[PacProgramID]
			,[PacApptItem]
			,[PacApptReasonCode]
			,[PacApptLength]
			,[PacApptInternalCode]
			,[PacApptPriorityCode]
			,[PacApptTitle]
			,[PacApptCategoryCodeId]
			,[PacApptUser01Code]
			,[PacApptUser02Code]
			,[PacApptUser03Code]
			,[PacApptUser04Code]
			,[PacApptUser05Code]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy])
      
			SELECT 
			 [PacOrgID]
			,@programId
			,[PacApptItem]
			,[PacApptReasonCode]
			,[PacApptLength]
			,[PacApptInternalCode]
			,[PacApptPriorityCode]
			,[PacApptTitle]
			,[PacApptCategoryCodeId]
			,[PacApptUser01Code]
			,[PacApptUser02Code]
			,[PacApptUser03Code]
			,[PacApptUser04Code]
			,[PacApptUser05Code]
			,[StatusId]
			,@PacificDateTime      
			,@enteredBy            
			FROM PRGRM031ShipApptmtReasonCodes WHERE [PacProgramID]= @fromRecordId   AND StatusId IN(1,2)   
			
END
GO
