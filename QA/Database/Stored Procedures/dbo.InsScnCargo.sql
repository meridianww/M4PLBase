SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnCargo 
-- Execution:                 EXEC [dbo].[InsScnCargo]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsScnCargo]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
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
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN005Cargo]
           ([CargoID]
			,[JobID]
			,[CgoLineItem]
			,[CgoPartNumCode]
			,[CgoQtyOrdered]
			,[CgoQtyExpected]
			,[CgoQtyCounted]
			,[CgoQtyDamaged]
			,[CgoQtyOnHold]
			,[CgoQtyShort]
			,[CgoQtyOver]
			,[CgoQtyUnits]
			,[CgoStatus]
			,[CgoInfoID]
			,[ColorCD]
			,[CgoSerialCD]
			,[CgoLong]
			,[CgoLat]
			,[CgoProFlag01]
			,[CgoProFlag02]
			,[CgoProFlag03]
			,[CgoProFlag04]
			,[CgoProFlag05]
			,[CgoProFlag06]
			,[CgoProFlag07]
			,[CgoProFlag08]
			,[CgoProFlag09]
			,[CgoProFlag10]
			,[CgoProFlag11]
			,[CgoProFlag12]
			,[CgoProFlag13]
			,[CgoProFlag14]
			,[CgoProFlag15]
			,[CgoProFlag16]
			,[CgoProFlag17]
			,[CgoProFlag18]
			,[CgoProFlag19]
			,[CgoProFlag20])
     VALUES
           (@cargoID
			,@jobID
			,@cgoLineItem
			,@cgoPartNumCode
			,@cgoQtyOrdered
			,@cgoQtyExpected
			,@cgoQtyCounted
			,@cgoQtyDamaged
			,@cgoQtyOnHold
			,@cgoQtyShort
			,@cgoQtyOver
			,@cgoQtyUnits
			,@cgoStatus
			,@cgoInfoID
			,@colorCD
			,@cgoSerialCD
			,@cgoLong
			,@cgoLat
			,@cgoProFlag01
			,@cgoProFlag02
			,@cgoProFlag03
			,@cgoProFlag04
			,@cgoProFlag05
			,@cgoProFlag06
			,@cgoProFlag07
			,@cgoProFlag08
			,@cgoProFlag09
			,@cgoProFlag10
			,@cgoProFlag11
			,@cgoProFlag12
			,@cgoProFlag13
			,@cgoProFlag14
			,@cgoProFlag15
			,@cgoProFlag16
			,@cgoProFlag17
			,@cgoProFlag18
			,@cgoProFlag19
			,@cgoProFlag20) 

		   --SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetScnCargo] @userId, @roleId,0 ,@currentId 

END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
