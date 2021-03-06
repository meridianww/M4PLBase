SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnCargoDetail
-- Execution:                 EXEC [dbo].[UpdScnCargoDetail]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[UpdScnCargoDetail]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@cargoDetailID BIGINT = NULL
	,@cargoID BIGINT = NULL
	,@detSerialNumber NVARCHAR(255) = NULL
	,@detQtyCounted DECIMAL(18, 2) = NULL
	,@detQtyDamaged  DECIMAL(18, 2) = NULL
	,@detQtyShort  DECIMAL(18, 2) = NULL
	,@detQtyOver  DECIMAL(18, 2) = NULL
	,@detPickStatus NVARCHAR(20) = NULL
	,@detLong NVARCHAR(30) = NULL
	,@detLat NVARCHAR(30) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0)
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN006CargoDetail]
      --SET   [CargoDetailID]		= CASE WHEN (@isFormView = 1) THEN @cargoDetailID WHEN ((@isFormView = 0) AND (@cargoDetailID=-100)) THEN NULL ELSE ISNULL(@cargoDetailID, [CargoDetailID]) END
      SET   [CargoID]			= CASE WHEN (@isFormView = 1) THEN @cargoID WHEN ((@isFormView = 0) AND (@cargoID=-100)) THEN NULL ELSE ISNULL(@cargoID, [CargoID]) END
		   ,[DetSerialNumber]	= CASE WHEN (@isFormView = 1) THEN @detSerialNumber WHEN ((@isFormView = 0) AND (@detSerialNumber='#M4PL#')) THEN NULL ELSE ISNULL(@detSerialNumber, [DetSerialNumber]) END
           ,[DetQtyCounted]		= CASE WHEN (@isFormView = 1) THEN @detQtyCounted WHEN ((@isFormView = 0) AND (@detQtyCounted=-100.00)) THEN NULL ELSE ISNULL(@detQtyCounted, [DetQtyCounted]) END
           ,[DetQtyDamaged]		= CASE WHEN (@isFormView = 1) THEN @detQtyDamaged WHEN ((@isFormView = 0) AND (@detQtyDamaged=-100.00)) THEN NULL ELSE ISNULL(@detQtyDamaged, [DetQtyDamaged]) END
           ,[DetQtyShort]		= CASE WHEN (@isFormView = 1) THEN @detQtyShort WHEN ((@isFormView = 0) AND (@detQtyShort=-100.00)) THEN NULL ELSE ISNULL(@detQtyShort, [DetQtyShort]) END
           ,[DetQtyOver]		= CASE WHEN (@isFormView = 1) THEN @detQtyOver WHEN ((@isFormView = 0) AND (@detQtyOver=-100.00)) THEN NULL ELSE ISNULL(@detQtyOver, [DetQtyOver]) END
           ,[DetPickStatus]		= CASE WHEN (@isFormView = 1) THEN @detPickStatus WHEN ((@isFormView = 0) AND (@detPickStatus='#M4PL#')) THEN NULL ELSE ISNULL(@detPickStatus, [DetPickStatus]) END
           ,[DetLong]			= CASE WHEN (@isFormView = 1) THEN @detLong WHEN ((@isFormView = 0) AND (@detLong='#M4PL#')) THEN NULL ELSE ISNULL(@detLong, [DetLong]) END
           ,[DetLat]			= CASE WHEN (@isFormView = 1) THEN @detLat WHEN ((@isFormView = 0) AND (@detLat='#M4PL#')) THEN NULL ELSE ISNULL(@detLat, [DetLat]) END
	WHERE	[CargoDetailID] = @id

	EXEC [dbo].[GetScnCargoDetail] @userId, @roleId,0 ,@id 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
