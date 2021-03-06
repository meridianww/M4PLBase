SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnCargoDetail 
-- Execution:                 EXEC [dbo].[InsScnCargoDetail]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsScnCargoDetail]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
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
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN006CargoDetail]
           ([CargoDetailID]
			,[CargoID]
			,[DetSerialNumber]
			,[DetQtyCounted]
			,[DetQtyDamaged]
			,[DetQtyShort]
			,[DetQtyOver]
			,[DetPickStatus]
			,[DetLong]
			,[DetLat])
     VALUES
           (@cargoDetailID
           ,@cargoID 
           ,@detSerialNumber -- @custItemNumber 
           ,@detQtyCounted  
           ,@detQtyDamaged 
           ,@detQtyShort  
           ,@detQtyOver  
           ,@detPickStatus  
           ,@detLong  
           ,@detLat) 

		   --SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetScnCargoDetail] @userId, @roleId,0 ,@currentId 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
