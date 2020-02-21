SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
--==================================================================================    
-- Author        : Prashant Aggarwal  
-- Date          : 01 August 2019     
-- Description   : Stored Procedure to Update the Cost Code Information From Nav Item
--=================================================================================  
CREATE PROCEDURE [dbo].[UpdateNavCostCodeByItem] (
	@changedBy NVARCHAR(50) = NULL
	,@uttNavOrderItem dbo.uttNavOrderItem READONLY
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

		UPDATE PCR
		SET PCR.PcrCostRate = CC.Unit_Cost
			,PCR.[ChangedBy] = ISNULL(@changedBy, PCR.ChangedBy)
			,PCR.[DateChanged] = GETUTCDATE()
		FROM [dbo].[PRGRM041ProgramCostRate] PCR
		INNER JOIN @uttNavOrderItem CC ON CC.[No] = PCR.PcrCode
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
