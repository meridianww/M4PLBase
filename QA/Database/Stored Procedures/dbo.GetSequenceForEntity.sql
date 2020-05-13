SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manoj Kumar
-- Create date: 13/May/2020
-- Description:	Get the next sequence for Entity
-- =============================================
CREATE PROCEDURE [dbo].[GetSequenceForEntity] 
	@Entity VARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;
	 
   DECLARE @NextValue BIGINT

   IF(@Entity = 'DocumentReference')
   BEGIN
    SELECT @NextValue = NEXT VALUE FOR DocumentReferenceSequence
   END
   
  INSERT INTO [dbo].[EntitySequenceReference] VALUES
  (@NextValue,'DocumentReference',1)


  SELECT @NextValue

END
GO
