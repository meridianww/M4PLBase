SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
--==================================================================================    
-- Author        : Prashant Aggarwal  
-- Date          : 01 August 2019     
-- Description   : Stored Procedure to Update the Price Code Information From Nav Item
--=================================================================================  
CREATE PROCEDURE [dbo].[UpdateNavPriceCodeByItem] (
	@changedBy NVARCHAR(50) = NULL
	,@uttNavOrderItem dbo.uttNavOrderItem READONLY
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

		UPDATE PBR
		SET PBR.PbrBillablePrice = CC.Unit_Price
			,PBR.[ChangedBy] = ISNULL(@changedBy, PBR.ChangedBy)
			,PBR.[DateChanged] = GETUTCDATE()
		FROM [dbo].[PRGRM040ProgramBillableRate] PBR
		INNER JOIN @uttNavOrderItem CC ON CC.[No] = PBR.PbrCode
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
