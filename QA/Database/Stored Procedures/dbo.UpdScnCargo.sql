SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnCargo
-- Execution:                 EXEC [dbo].[UpdScnCargo]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[UpdScnCargo]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@cargoID BIGINT = NULL
	,@jobID BIGINT = NULL
	,@cgoLineItem INT = NULL
	,@cgoPartNumCode NVARCHAR(30) = NULL
	,@cgoQtyOrdered DECIMAL(18, 2) = NULL
	,@cgoQtyExpected DECIMAL(18, 2) = NULL
	,@cgoQtyCounted DECIMAL(18, 2) = NULL
	,@cgoQtyDamaged DECIMAL(18, 2) = NULL
	,@cgoQtyOnHold DECIMAL(18, 2) = NULL
	,@cgoQtyShort DECIMAL(18, 2) = NULL
	,@cgoQtyOver DECIMAL(18, 2) = NULL
	,@cgoQtyUnits NVARCHAR(20) = NULL
	,@cgoStatus NVARCHAR(20) = NULL
	,@cgoInfoID NVARCHAR(50) = NULL
	,@colorCD INT = NULL
	,@cgoSerialCD NVARCHAR(255) = NULL
	,@cgoLong NVARCHAR(30) = NULL
	,@cgoLat NVARCHAR(30) = NULL
	,@cgoProFlag01 NVARCHAR(1) = NULL
	,@cgoProFlag02 NVARCHAR(1) = NULL
	,@cgoProFlag03 NVARCHAR(1) = NULL
	,@cgoProFlag04 NVARCHAR(1) = NULL
	,@cgoProFlag05 NVARCHAR(1) = NULL
	,@cgoProFlag06 NVARCHAR(1) = NULL
	,@cgoProFlag07 NVARCHAR(1) = NULL
	,@cgoProFlag08 NVARCHAR(1) = NULL
	,@cgoProFlag09 NVARCHAR(1) = NULL
	,@cgoProFlag10 NVARCHAR(1) = NULL
	,@cgoProFlag11 NVARCHAR(1) = NULL
	,@cgoProFlag12 NVARCHAR(1) = NULL
	,@cgoProFlag13 NVARCHAR(1) = NULL
	,@cgoProFlag14 NVARCHAR(1) = NULL
	,@cgoProFlag15 NVARCHAR(1) = NULL
	,@cgoProFlag16 NVARCHAR(1) = NULL
	,@cgoProFlag17 NVARCHAR(1) = NULL
	,@cgoProFlag18 NVARCHAR(1) = NULL
	,@cgoProFlag19 NVARCHAR(1) = NULL
	,@cgoProFlag20 NVARCHAR(1) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN005Cargo]
      SET  [CargoID]			= CASE WHEN (@isFormView = 1) THEN @cargoID WHEN ((@isFormView = 0) AND (@cargoID=-100)) THEN NULL ELSE ISNULL(@cargoID, [CargoID]) END
		   ,[JobID]				= CASE WHEN (@isFormView = 1) THEN @jobID WHEN ((@isFormView = 0) AND (@jobID=-100)) THEN NULL ELSE ISNULL(@jobID, [JobID]) END
		   ,[CgoLineItem]		= CASE WHEN (@isFormView = 1) THEN @cgoLineItem WHEN ((@isFormView = 0) AND (@cgoLineItem=-100)) THEN NULL ELSE ISNULL(@cgoLineItem, [CgoLineItem]) END 
		   ,[CgoPartNumCode]	= CASE WHEN (@isFormView = 1) THEN @cgoPartNumCode WHEN ((@isFormView = 0) AND (@cgoPartNumCode='#M4PL#')) THEN NULL ELSE ISNULL(@cgoPartNumCode, [CgoPartNumCode]) END
           ,[CgoQtyOrdered]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyOrdered WHEN ((@isFormView = 0) AND (@cgoQtyOrdered=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyOrdered, [CgoQtyOrdered]) END
           ,[CgoQtyExpected]	= CASE WHEN (@isFormView = 1) THEN @cgoQtyExpected WHEN ((@isFormView = 0) AND (@cgoQtyExpected=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyExpected, [CgoQtyExpected]) END
           ,[CgoQtyCounted]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyCounted WHEN ((@isFormView = 0) AND (@cgoQtyCounted=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyCounted, [CgoQtyCounted]) END
           ,[CgoQtyDamaged]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyDamaged WHEN ((@isFormView = 0) AND (@cgoQtyDamaged=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyDamaged, [CgoQtyDamaged]) END
           ,[CgoQtyOnHold]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyOnHold WHEN ((@isFormView = 0) AND (@cgoQtyOnHold=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyOnHold, [CgoQtyOnHold]) END
           ,[CgoQtyShort]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyShort WHEN ((@isFormView = 0) AND (@cgoQtyShort=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyShort, [CgoQtyShort]) END
           ,[CgoQtyOver]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyOver WHEN ((@isFormView = 0) AND (@cgoQtyOver=-100.00)) THEN NULL ELSE ISNULL(@cgoQtyOver, [CgoQtyOver]) END
           ,[CgoQtyUnits]		= CASE WHEN (@isFormView = 1) THEN @cgoQtyUnits WHEN ((@isFormView = 0) AND (@cgoQtyUnits='#M4PL#')) THEN NULL ELSE ISNULL(@cgoQtyUnits, [CgoQtyUnits]) END
           ,[CgoStatus]			= CASE WHEN (@isFormView = 1) THEN @cgoStatus WHEN ((@isFormView = 0) AND (@cgoStatus='#M4PL#')) THEN NULL ELSE ISNULL(@cgoStatus, [CgoStatus]) END
           ,[CgoInfoID]			= CASE WHEN (@isFormView = 1) THEN @cgoInfoID WHEN ((@isFormView = 0) AND (@cgoInfoID='#M4PL#')) THEN NULL ELSE ISNULL(@cgoInfoID, [CgoInfoID]) END
		   ,[ColorCD]			= CASE WHEN (@isFormView = 1) THEN @colorCD WHEN ((@isFormView = 0) AND (@colorCD=-100)) THEN NULL ELSE ISNULL(@colorCD, [ColorCD]) END 
           ,[CgoSerialCD]		= CASE WHEN (@isFormView = 1) THEN @cgoSerialCD WHEN ((@isFormView = 0) AND (@cgoSerialCD='#M4PL#')) THEN NULL ELSE ISNULL(@cgoSerialCD, [CgoSerialCD]) END
           ,[CgoLong]			= CASE WHEN (@isFormView = 1) THEN @cgoLong WHEN ((@isFormView = 0) AND (@cgoLong='#M4PL#')) THEN NULL ELSE ISNULL(@cgoLong, [CgoLong]) END
           ,[CgoLat]			= CASE WHEN (@isFormView = 1) THEN @cgoLat WHEN ((@isFormView = 0) AND (@cgoLat='#M4PL#')) THEN NULL ELSE ISNULL(@cgoLat, [CgoLat]) END
           ,[CgoProFlag01]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag01 WHEN ((@isFormView = 0) AND (@cgoProFlag01='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag01, [CgoProFlag01]) END
           ,[CgoProFlag02]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag02 WHEN ((@isFormView = 0) AND (@cgoProFlag02='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag02, [CgoProFlag02]) END
           ,[CgoProFlag03]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag03 WHEN ((@isFormView = 0) AND (@cgoProFlag03='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag03, [CgoProFlag03]) END
           ,[CgoProFlag04]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag04 WHEN ((@isFormView = 0) AND (@cgoProFlag04='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag04, [CgoProFlag04]) END
           ,[CgoProFlag05]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag05 WHEN ((@isFormView = 0) AND (@cgoProFlag05='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag05, [CgoProFlag05]) END
           ,[CgoProFlag06]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag06 WHEN ((@isFormView = 0) AND (@cgoProFlag06='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag06, [CgoProFlag06]) END
           ,[CgoProFlag07]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag07 WHEN ((@isFormView = 0) AND (@cgoProFlag07='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag07, [CgoProFlag07]) END
           ,[CgoProFlag08]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag08 WHEN ((@isFormView = 0) AND (@cgoProFlag08='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag08, [CgoProFlag08]) END
           ,[CgoProFlag09]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag09 WHEN ((@isFormView = 0) AND (@cgoProFlag09='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag09, [CgoProFlag09]) END
           ,[CgoProFlag10]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag10 WHEN ((@isFormView = 0) AND (@cgoProFlag10='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag10, [CgoProFlag10]) END
           ,[CgoProFlag11]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag11 WHEN ((@isFormView = 0) AND (@cgoProFlag11='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag11, [CgoProFlag11]) END
           ,[CgoProFlag12]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag12 WHEN ((@isFormView = 0) AND (@cgoProFlag12='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag12, [CgoProFlag12]) END
           ,[CgoProFlag13]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag13 WHEN ((@isFormView = 0) AND (@cgoProFlag13='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag13, [CgoProFlag13]) END
           ,[CgoProFlag14]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag14 WHEN ((@isFormView = 0) AND (@cgoProFlag14='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag14, [CgoProFlag14]) END
           ,[CgoProFlag15]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag15 WHEN ((@isFormView = 0) AND (@cgoProFlag15='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag15, [CgoProFlag15]) END
           ,[CgoProFlag16]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag16 WHEN ((@isFormView = 0) AND (@cgoProFlag16='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag16, [CgoProFlag16]) END
           ,[CgoProFlag17]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag17 WHEN ((@isFormView = 0) AND (@cgoProFlag17='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag17, [CgoProFlag17]) END
           ,[CgoProFlag18]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag18 WHEN ((@isFormView = 0) AND (@cgoProFlag18='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag18, [CgoProFlag18]) END
           ,[CgoProFlag19]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag19 WHEN ((@isFormView = 0) AND (@cgoProFlag19='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag19, [CgoProFlag19]) END
           ,[CgoProFlag20]		= CASE WHEN (@isFormView = 1) THEN @cgoProFlag20 WHEN ((@isFormView = 0) AND (@cgoProFlag20='#M4PL#')) THEN NULL ELSE ISNULL(@cgoProFlag20, [CgoProFlag20]) END
	WHERE	[CargoID] = @id

	EXEC [dbo].[GetScnCargo] @userId, @roleId,0 ,@id 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
