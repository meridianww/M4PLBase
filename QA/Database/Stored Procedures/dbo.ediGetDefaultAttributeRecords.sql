SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 5/12/2018
-- Description:	The stored procedure gets all the active default records in the Program Attributes Defaults table by Program ID
-- =============================================
CREATE PROCEDURE [dbo].[ediGetDefaultAttributeRecords]
	-- Add the parameters for the stored procedure here
	@ProgramId bigint,
	@StatusActive nvarchar
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     -- Insert statements for procedure here
	SELECT [PRGRM020Ref_AttributesDefault].ProgramID, [PRGRM020Ref_AttributesDefault].AttItemNumber, [PRGRM020Ref_AttributesDefault].AttCode,
		[PRGRM020Ref_AttributesDefault].AttTitle, [PRGRM020Ref_AttributesDefault].[AttDescription], [PRGRM020Ref_AttributesDefault].AttComments,  
		[PRGRM020Ref_AttributesDefault].AttQuantity, [PRGRM020Ref_AttributesDefault].UnitTypeId, 
		[PRGRM020Ref_AttributesDefault].AttDefault, [PRGRM020Ref_AttributesDefault].StatusId
		FROM [PRGRM020Ref_AttributesDefault] INNER JOIN SYSTM000Ref_Options ON [PRGRM020Ref_AttributesDefault].UnitTypeId = SYSTM000Ref_Options.Id
		WHERE ProgramID = @ProgramId AND AttDefault = 1 AND [PRGRM020Ref_AttributesDefault].StatusId = @StatusActive
END
GO
