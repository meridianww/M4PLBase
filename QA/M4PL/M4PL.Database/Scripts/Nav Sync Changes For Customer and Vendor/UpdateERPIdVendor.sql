
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
--==================================================================================    
-- Author        : Prashant Aggarwal  
-- Date          : 26 June 2019     
-- Description   : Stored Procedure to Update the ERP Id For The Customer When Application Get Mapping One To One. 
--=================================================================================  
CREATE PROCEDURE [dbo].[UpdateERPIdVendor] (
	 @changedBy NVARCHAR(50) = NULL
	,@uttNavVendor dbo.uttNavVendor READONLY
	)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY  
	UPDATE VEN
	SET VEN.VendERPID = NVEN.ERPId
		,[ChangedBy] = ISNULL(@changedBy, ChangedBy)
		,[DateChanged] = GETUTCDATE()
	FROM [dbo].[VEND000Master] VEN
	INNER JOIN @uttNavVendor NVEN ON NVEN.VendorId = VEN.Id

	Return 1
	END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity 
 Return 0               
END CATCH
END
