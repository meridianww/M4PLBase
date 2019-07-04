SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  

  CREATE  PROCEDURE [dbo].[PrgRefAttributeDefaultCopy]
  (
    @programId BIGINT,
	@enteredBy NVARCHAR(50),
	@fromRecordId BIGINT
  )
  AS 
  BEGIN
   SET NOCOUNT ON;   

 INSERT INTO [dbo].[PRGRM020Ref_AttributesDefault]
           ( [ProgramID]
			,[AttItemNumber]
			,[AttCode]
			,[AttTitle]
			,[AttQuantity]
			,[UnitTypeId]
			,[StatusId]
			,[AttDefault]
			,[DateEntered]
			,[EnteredBy])
      
			SELECT 
			 @programId
			,[AttItemNumber]
			,[AttCode]
			,[AttTitle]
			,[AttQuantity]
			,[UnitTypeId]
			,[StatusId]
			,[AttDefault]
			,GETUTCDATE()      
			,@enteredBy            
			FROM PRGRM020Ref_AttributesDefault WHERE ProgramID= @fromRecordId   AND StatusId IN(1,2)   
			
END
GO
