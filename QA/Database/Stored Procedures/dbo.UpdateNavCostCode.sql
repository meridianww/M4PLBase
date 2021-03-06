SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
--==================================================================================    
-- Author        : Prashant Aggarwal  
-- Date          : 01 August 2019     
-- Description   : Stored Procedure to Update Cost Code From Nav. 
--=================================================================================  
CREATE PROCEDURE [dbo].[UpdateNavCostCode] (
	@changedBy NVARCHAR(50) = NULL
	,@uttNavCostCode dbo.uttNavCostCode READONLY
	,@dateChanged DATETIME2(7)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

     UPDATE PCR
		SET PCR.PcrCostRate = CC.DirectUnitCost
			,PCR.[ChangedBy] = ISNULL(@changedBy, PCR.ChangedBy)
			,PCR.[DateChanged] = @dateChanged
		FROM [dbo].[PRGRM041ProgramCostRate] PCR
	    INNER JOIN dbo.PRGRM043ProgramCostLocations PCL ON PCL.Id = PCR.ProgramLocationId
		INNER JOIN dbo.VEND000Master VM ON VM.Id = PCL.PclVendorID
		INNER JOIN @uttNavCostCode CC ON CC.ItemId = PCR.PcrCode AND CC.VendorNo = VM.VendERPID

		RETURN 1
	END TRY

	BEGIN CATCH
		DECLARE @ErrorMessage VARCHAR(MAX) = (
				SELECT ERROR_MESSAGE()
				)
			,@ErrorSeverity VARCHAR(MAX) = (
				SELECT ERROR_SEVERITY()
				)
			,@RelatedTo VARCHAR(100) = (
				SELECT OBJECT_NAME(@@PROCID)
				)

		EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
			,NULL
			,@ErrorMessage
			,NULL
			,NULL
			,@ErrorSeverity

		RETURN 0
	END CATCH
END
GO
