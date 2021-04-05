SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- DROP VIEW [dbo].[vwJobMasterData]
CREATE VIEW [dbo].[vwJobCargoData]
	WITH SCHEMABINDING
AS
SELECT JobID
,Id
,CgoTitle
	,CgoPartNumCode
	,CgoQtyDamaged
	,CgoQtyOver
	,CgoQtyShortOver
	,CgoCubes 
	,CgoWeight 
	,CgoPackagingTypeId
	,StatusId
	,CgoSerialNumber
	,CgoQtyUnitsId
	,CgoQtyOnHand
	,CASE WHEN ISNULL(CgoQtyDamaged,0)<>0 THEN 'D'
		WHEN  ISNULL(CgoQtyOver,0)<>0 THEN 'O'
		WHEN  ISNULL(CgoQtyShortOver,0)<>0 THEN 'S'
		ELSE 'N' END ExceptionType
	FROM dbo.JOBDL010Cargo
	WHERE StatusId = 1
		--AND (
		--JC.CgoQtyDamaged <> 0
		--OR  JC.CgoQtyShortOver  <> 0
		--OR  JC.CgoQtyOver  <> 0
		--)

		GO
CREATE UNIQUE CLUSTERED INDEX [IX_vwJobCargoData] ON [dbo].[vwJobCargoData]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO