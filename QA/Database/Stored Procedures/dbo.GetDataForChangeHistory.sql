SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 04/03/2020
-- Description:	Get the System History Information In Database
-- =============================================
CREATE PROCEDURE [dbo].[GetDataForChangeHistory] (
	 @EntityId [bigint]
	,@EntityType [varchar](100)
	)
AS
BEGIN
	SET NOCOUNT ON;

	Select OrigionalData
		,ChangedData
		,ChangedBy
		,ChangedDate
		From dbo.Sys000AuditTrail
		Where EntityId = @EntityId AND EntityType = @EntityType
	
END
GO
