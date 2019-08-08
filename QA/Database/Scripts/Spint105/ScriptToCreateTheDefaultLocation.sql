CREATE TABLE #TempTable
(
ID INT IDENTITY(1,1),
ProgramId BIGINT 
)

INSERT INTO #TempTable
Select ID  From PRGRM000Master

Declare @Count INT, @CurrentRecord INT = 1, @ProgramId BIGINT
Select @Count = Count(Id) From #TempTable
While(@CurrentRecord <= @Count)
BEGIN
Select @ProgramId = ProgramId From #TempTable Where ID = @CurrentRecord
IF NOT EXISTS(Select 1 From [PRGRM043ProgramCostLocations] Where [PclProgramID] = @ProgramId)
BEGIN
INSERT INTO [dbo].[PRGRM043ProgramCostLocations] (
		[PclProgramID]
		,[PclItemNumber]
		,[PclLocationCode]
		,[PclLocationCodeCustomer]
		,[PclLocationTitle]
		,[StatusId]
		)
	VALUES (
		@ProgramId
		,1
		,'Default'
		,'Default'
		,'Default Rates'
		,1 
		)
END

IF NOT EXISTS(Select 1 From [PRGRM042ProgramBillableLocations] Where [PblProgramID] = @ProgramId)
BEGIN
INSERT INTO [dbo].[PRGRM042ProgramBillableLocations] (
		[PblProgramID]
		,[PblItemNumber]
		,[PblLocationCode]
		,[PblLocationCodeCustomer]
		,[PblLocationTitle]
		,[StatusId]
		)
	VALUES (
		@ProgramId
		,1
		,'Default'
		,'Default'
		,'Default Rates'
		,1 
		)
END

SET @CurrentRecord = @CurrentRecord + 1
END

DROP TABLE #TempTable