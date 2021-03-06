SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
--==================================================================================    
-- Author        : Prashant Aggarwal  
-- Date          : 01 August 2019     
-- Description   : Stored Procedure to Update the Price Code Information From Nav
--=================================================================================  
CREATE PROCEDURE [dbo].[UpdateNavPriceCode] (
	@changedBy NVARCHAR(50) = NULL
	,@uttNavPriceCode dbo.uttNavPriceCode READONLY
	,@dateChanged DATETIME2(7)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

		UPDATE PBR
		SET PBR.PbrBillablePrice = CC.UnitPrice
			,PBR.[ChangedBy] = ISNULL(@changedBy, PBR.ChangedBy)
			,PBR.[DateChanged] = @dateChanged
		FROM [dbo].[PRGRM040ProgramBillableRate] PBR
		INNER JOIN dbo.PRGRM042ProgramBillableLocations PBL ON PBL.Id = PBR.ProgramLocationId
		INNER JOIN dbo.PRGRM000Master PRGM ON PRGM.Id = PBL.PblProgramID
		INNER JOIN dbo.CUST000Master CM ON CM.ID = PRGM.PrgCustID
		INNER JOIN @uttNavPriceCode CC ON CC.ItemId = PBR.PbrCode AND CM.CustERPID = CC.SalesCode

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
