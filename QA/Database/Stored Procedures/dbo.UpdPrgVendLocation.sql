
GO
/****** Object:  StoredProcedure [dbo].[UpdPrgVendLocation]    Script Date: 10/29/2019 3:23:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program vendor location
-- Execution:                 EXEC [dbo].[UpdPrgVendLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE [dbo].[UpdPrgVendLocation] (
	@userId BIGINT                 
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@pvlProgramID BIGINT = NULL
	,@pvlVendorID BIGINT = NULL
	,@pvlItemNumber INT = NULL
	,@pvlLocationCode NVARCHAR(20) = NULL
	,@pvlLocationCodeCustomer NVARCHAR(20) = NULL
	,@pvlLocationTitle NVARCHAR(50) = NULL
	,@pvlContactMSTRID BIGINT = NULL
	,@statusId INT = NULL
	,@pvlDateStart DATETIME2(7) = NULL
	,@pvlDateEnd DATETIME2(7) = NULL
	,@pvlUserCode1 NVARCHAR(20) = NULL
	,@pvlUserCode2 NVARCHAR(20) = NULL
	,@pvlUserCode3 NVARCHAR(20) = NULL
	,@pvlUserCode4 NVARCHAR(20) = NULL
	,@pvlUserCode5 NVARCHAR(20) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0
	)
AS
BEGIN TRY
BEGIN TRAN

	SET NOCOUNT ON;

	DECLARE @updatedItemNumber INT

	EXEC [dbo].[ResetItemNumber] @userId
		,@id
		,@pvlProgramID
		,@entity
		,@pvlItemNumber
		,@statusId
		,NULL
		,NULL
		,@updatedItemNumber OUTPUT

 EXEC SyncVendDCLocation @userId ,@id,@entity,@pvlProgramID ,@pvlLocationCode,@pvlLocationCodeCustomer,@pvlLocationTitle,@changedBy,@dateChanged

	UPDATE [dbo].[PRGRM051VendorLocations]
	SET [PvlProgramID] = CASE 
			WHEN (@isFormView = 1)
				THEN @pvlProgramID
			WHEN (
					(@isFormView = 0)
					AND (@pvlProgramID = - 100)
					)
				THEN NULL
			ELSE ISNULL(@pvlProgramID, PvlProgramID)
			END
		,[PvlVendorID] = CASE 
			WHEN (@isFormView = 1)
				THEN @pvlVendorID
			WHEN (
					(@isFormView = 0)
					AND (@pvlVendorID = - 100)
					)
				THEN NULL
			ELSE ISNULL(@pvlVendorID, PvlVendorID)
			END
		,[PvlItemNumber] = CASE 
			WHEN (@isFormView = 1)
				THEN @updatedItemNumber
			WHEN (
					(@isFormView = 0)
					AND (@updatedItemNumber = - 100)
					)
				THEN NULL
			ELSE ISNULL(@updatedItemNumber, PvlItemNumber)
			END
		,[PvlLocationCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @pvlLocationCode
			WHEN (
					(@isFormView = 0)
					AND (@pvlLocationCode = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pvlLocationCode, PvlLocationCode)
			END
		,[PvlLocationCodeCustomer] = CASE 
			WHEN (@isFormView = 1)
				THEN @pvlLocationCodeCustomer
			WHEN (
					(@isFormView = 0)
					AND (@pvlLocationCodeCustomer = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pvlLocationCodeCustomer, PvlLocationCodeCustomer)
			END
		,[PvlLocationTitle] = CASE 
			WHEN (@isFormView = 1)
				THEN @pvlLocationTitle
			WHEN (
					(@isFormView = 0)
					AND (@pvlLocationTitle = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pvlLocationTitle, PvlLocationTitle)
			END
		,[PvlContactMSTRID] = CASE 
			WHEN (@isFormView = 1)
				THEN @pvlContactMSTRID
			WHEN (
					(@isFormView = 0)
					AND (@pvlContactMSTRID = - 100)
					)
				THEN NULL
			ELSE ISNULL(@pvlContactMSTRID, PvlContactMSTRID)
			END
		,[StatusId] = CASE 
			WHEN (@isFormView = 1)
				THEN @statusId
			WHEN (
					(@isFormView = 0)
					AND (@statusId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@statusId, StatusId)
			END
		,[PvlDateStart] = CASE 
			WHEN (@isFormView = 1)
				THEN @pvlDateStart
			WHEN (
					(@isFormView = 0)
					AND (CONVERT(CHAR(10), @pvlDateStart, 103) = '01/01/1753')
					)
				THEN NULL
			ELSE ISNULL(@pvlDateStart, PvlDateStart)
			END
		,[PvlDateEnd] = CASE 
			WHEN (@isFormView = 1)
				THEN @pvlDateEnd
			WHEN (
					(@isFormView = 0)
					AND (CONVERT(CHAR(10), @pvlDateEnd, 103) = '01/01/1753')
					)
				THEN NULL
			ELSE ISNULL(@pvlDateEnd, PvlDateEnd)
			END
		,[PvlUserCode1] = CASE 
			WHEN (@isFormView = 1)
				THEN @pvlUserCode1
			WHEN (
					(@isFormView = 0)
					AND (@pvlUserCode1 = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pvlUserCode1, PvlUserCode1)
			END
		,[PvlUserCode2] = CASE 
			WHEN (@isFormView = 1)
				THEN @pvlUserCode2
			WHEN (
					(@isFormView = 0)
					AND (@pvlUserCode2 = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pvlUserCode2, PvlUserCode2)
			END
		,[PvlUserCode3] = CASE 
			WHEN (@isFormView = 1)
				THEN @pvlUserCode3
			WHEN (
					(@isFormView = 0)
					AND (@pvlUserCode3 = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pvlUserCode3, PvlUserCode3)
			END
		,[PvlUserCode4] = CASE 
			WHEN (@isFormView = 1)
				THEN @pvlUserCode4
			WHEN (
					(@isFormView = 0)
					AND (@pvlUserCode4 = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pvlUserCode4, PvlUserCode4)
			END
		,[PvlUserCode5] = CASE 
			WHEN (@isFormView = 1)
				THEN @pvlUserCode5
			WHEN (
					(@isFormView = 0)
					AND (@pvlUserCode5 = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@pvlUserCode5, PvlUserCode5)
			END
		,[ChangedBy] = @changedBy
		,[DateChanged] = @dateChanged
	WHERE [Id] = @id

	UPDATE PBL
	SET PBL.[PblLocationCodeVendor] = PVL.PVLLocationCodeCustomer
	,PBL.PblLocationCode = PVL.PvlLocationCode
	,PBL.PblLocationTitle = PVL.PvlLocationTitle
	,PBL.[PblUserCode1] = PVL.PVLUserCode1
	,PBL.[PblUserCode2] = PVL.PVLUserCode2
	,PBL.[PblUserCode3] = PVL.PVLUserCode3
	,PBL.[PblUserCode4] = PVL.PVLUserCode4
	,PBL.[PblUserCode5] = PVL.PVLUserCode5
	From [dbo].[PRGRM042ProgramBillableLocations] PBL
	INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON  PBL.[PblVendorID] = PVL.PVLVendorID
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) PVL_fgus ON ISNULL(PVL.[StatusId], 1) = PVL_fgus.[StatusId] 
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) PBL_fgus ON ISNULL(PBL.[StatusId], 1) = PBL_fgus.[StatusId] 
	Where PVL.Id = @id 

	UPDATE PCL
	SET PCL.[PclLocationCodeCustomer] = PVL.PVLLocationCodeCustomer
	,PCL.PclLocationCode = PVL.PvlLocationCode
	,PCL.PclLocationTitle = PVL.PvlLocationTitle
	,PCL.[PclUserCode1] = PVL.PVLUserCode1
	,PCL.[PclUserCode2] = PVL.PVLUserCode2
	,PCL.[PclUserCode3] = PVL.PVLUserCode3
	,PCL.[PclUserCode4] = PVL.PVLUserCode4
	,PCL.[PclUserCode5] = PVL.PVLUserCode5
	From [dbo].[PRGRM043ProgramCostLocations] PCL
	INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON  PCL.[PclVendorID] = PVL.PVLVendorID
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) PVL_fgus ON ISNULL(PVL.[StatusId], 1) = PVL_fgus.[StatusId] 
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) PBL_fgus ON ISNULL(PCL.[StatusId], 1) = PBL_fgus.[StatusId] 
	Where   PVL.Id = @id

	SELECT prg.[Id]
		,prg.[PvlProgramID]
		,prg.[PvlVendorID]
		,prg.[PvlItemNumber]
		,prg.[PvlLocationCode]
		,prg.[PvlLocationCodeCustomer]
		,prg.[PvlLocationTitle]
		,prg.[PvlContactMSTRID]
		,prg.[StatusId]
		,prg.[PvlDateStart]
		,prg.[PvlDateEnd]
		,prg.[PvlUserCode1]
		,prg.[PvlUserCode2]
		,prg.[PvlUserCode3]
		,prg.[PvlUserCode4]
		,prg.[PvlUserCode5]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
	FROM [dbo].[PRGRM051VendorLocations] prg
	WHERE [Id] = @id
	COMMIT
END TRY

BEGIN CATCH
ROLLBACK
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
END CATCH

