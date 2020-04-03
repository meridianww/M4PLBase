SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 04/03/2020
-- Description:	Insert the System History Information In Database
-- =============================================
CREATE PROCEDURE [dbo].[UpdateDataForChangeHistory] (
	@EntityId [bigint]
	,@EntityTypeId [int]
	,@OrigionalData NVarchar(Max)
	,@ChangedData NVarchar(Max)
	,@EntityType [varchar](100)
	,@ChangedByUserId [bigint]
	,@ChangedBy [varchar](150)
	)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.Sys000AuditTrail (
		EntityId
		,EntityTypeId
		,OrigionalData
		,ChangedData
		,EntityType
		,ChangedByUserId
		,ChangedBy
		)
	VALUES (
		@EntityId
		,@EntityTypeId
		,@OrigionalData
		,@ChangedData
		,@EntityType
		,@ChangedByUserId
		,@ChangedBy
		)
END
GO

