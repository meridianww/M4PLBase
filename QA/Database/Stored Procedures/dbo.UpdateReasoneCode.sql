SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kirty
-- Create date: 03/11/2021
-- Description:	UpdateAppointmentCode
-- =============================================
--DROP PROCEDURE [dbo].[UpdateReasoneCode] 
CREATE PROCEDURE [dbo].[UpdateReasoneCode] @programId BIGINT
	,@changedBy NVARCHAR(150)
	,@dateChanged DATETIME2(7)
	,@uttReasonCode [dbo].[uttReasonCode] READONLY
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE dbo.PRGRM030ShipStatusReasonCodes
	SET StatusId = 3 WHERE PscProgramID = @programId

	INSERT INTO dbo.PRGRM030ShipStatusReasonCodes(
	[PscShipReasonCode]
      ,[PscShipInternalCode]
      ,[PscShipPriorityCode]
      ,[PscShipTitle]
      ,[PscShipDescription]
      ,[PscShipComment]
      ,[PscShipCategoryCode]
      ,[PscShipUser01Code]
      ,[PscShipUser02Code]
      ,[PscShipUser03Code]
      ,[PscShipUser04Code]
      ,[PscShipUser05Code]
	  ,[StatusId]
	  ,[PscProgramID]
	  ,[EnteredBy]
	  ,[DateEntered]
	)
	SELECT [ReasonCode],
			[InternalCode],
			[PriorityCode],
			[Title],
			ISNULL(CONVERT(varbinary(max), [Description]), 0x),
			ISNULL(CONVERT(varbinary(max), [Comment]), 0x), 
			[CategoryCode],
			[User01Code],
			[User02Code],
			[User03Code],
			[User04Code],
			[User05Code],
			1,
			@programId,
			@changedBy,
			@dateChanged
		FROM @uttReasonCode
END
GO
