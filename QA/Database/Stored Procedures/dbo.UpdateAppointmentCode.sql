SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kirty
-- Create date: 03/11/2021
-- Description:	UpdateAppointmentCode
-- =============================================
ALTER PROCEDURE [dbo].[UpdateAppointmentCode] @programId BIGINT
	,@changedBy NVARCHAR(150)
	,@dateChanged DATETIME2(7)
	,@uttAppointmentCode [dbo].[uttAppointmentCode] READONLY
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE dbo.PRGRM031ShipApptmtReasonCodes
	SET StatusId = 3 WHERE PacProgramID = @programId

	INSERT INTO dbo.PRGRM031ShipApptmtReasonCodes(
	[PacApptReasonCode]
      ,[PacApptInternalCode]
      ,[PacApptPriorityCode]
      ,[PacApptTitle]
      ,[PacApptDescription]
      ,[PacApptComment]
      ,[PacApptCategoryCodeId]
      ,[PacApptUser01Code]
      ,[PacApptUser02Code]
      ,[PacApptUser03Code]
      ,[PacApptUser04Code]
      ,[PacApptUser05Code]
	  ,[StatusId]
	  ,[PacProgramID]
	  ,[EnteredBy]
	  ,[DateEntered]
	  ,[PacOrgID]
	)
	SELECT [ReasonCode],
			[InternalCode],
			[PriorityCode],
			[Title],
			ISNULL(CONVERT(varbinary(max), [Description]), 0x),
			ISNULL(CONVERT(varbinary(max), [Comment]), 0x), 
			[CategoryCodeId],
			[User01Code],
			[User02Code],
			[User03Code],
			[User04Code],
			[User05Code],
			1,
			@programId,
			@changedBy,
			@dateChanged,
			1
		FROM @uttAppointmentCode
END
GO
