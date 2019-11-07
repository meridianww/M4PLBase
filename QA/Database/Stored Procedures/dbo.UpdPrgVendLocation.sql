
GO
/****** Object:  StoredProcedure [dbo].[UpdPrgVendLocation]    Script Date: 11/4/2019 3:27:48 PM ******/
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

 
 	UPDATE PBL
	SET PBL.[PblLocationCodeVendor] = @pvlLocationCodeCustomer
	,PBL.PblLocationCode =@pvlLocationCode
	,PBL.PblLocationTitle = @pvlLocationTitle
	From [dbo].[PRGRM042ProgramBillableLocations] PBL
	INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON  PBL.PblVendorID = PVL.PVLVendorID  AND PVL.PvlLocationCode = PBL.PblLocationCode and PVL.PvlLocationTitle = PblLocationTitle
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) PVL_fgus ON ISNULL(PVL.[StatusId], 1) = PVL_fgus.[StatusId] 
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) PBL_fgus ON ISNULL(PBL.[StatusId], 1) = PBL_fgus.[StatusId] 
	Where  PVL.Id = @id  --AND PVL.PvlProgramID = @pvlProgramID

	UPDATE PCL
	SET PCL.[PclLocationCodeCustomer] =  @pvlLocationCodeCustomer
	,PCL.PclLocationCode =@pvlLocationCode
	,PCL.PclLocationTitle = @pvlLocationTitle
	From [dbo].[PRGRM043ProgramCostLocations] PCL
	INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON  PVL.PVLVendorID = PCL.PclVendorID  AND PVL.PvlLocationCode = PCL.PclLocationCode and PVL.PvlLocationTitle = PCL.PclLocationTitle
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) PVL_fgus ON ISNULL(PVL.[StatusId], 1) = PVL_fgus.[StatusId] 
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) PBL_fgus ON ISNULL(PCL.[StatusId], 1) = PBL_fgus.[StatusId] 
	Where   PVL.Id = @id  --AND PVL.PvlProgramID = @pvlProgramID

	EXEC SyncVendDCLocation @userId ,@id,@entity,@pvlProgramID ,@pvlLocationCode,@pvlLocationCodeCustomer,@pvlLocationTitle,@changedBy,@dateChanged

	UPDATE [dbo].[PRGRM051VendorLocations]
	SET [PvlProgramID] =  ISNULL(@pvlProgramID, PvlProgramID)
		,[PvlVendorID] = ISNULL(@pvlVendorID, PvlVendorID)
		,[PvlItemNumber] = ISNULL(@updatedItemNumber, PvlItemNumber)
		,[PvlLocationCode] =ISNULL(@pvlLocationCode, PvlLocationCode)
		,[PvlLocationCodeCustomer] = ISNULL(@pvlLocationCodeCustomer, PvlLocationCodeCustomer)
		,[PvlLocationTitle] =  ISNULL(@pvlLocationTitle, PvlLocationTitle)
		,[PvlContactMSTRID] = ISNULL(@pvlContactMSTRID, PvlContactMSTRID)
		,[StatusId] =  ISNULL(@statusId, StatusId)
		,[PvlDateStart] = CASE
		                	WHEN (CONVERT(CHAR(10), @pvlDateStart, 103) = '01/01/1753')
								THEN NULL
			               ELSE ISNULL(@pvlDateStart, PvlDateStart)
			              END
		,[PvlDateEnd] =  CASE 
							WHEN (CONVERT(CHAR(10), @pvlDateEnd, 103) = '01/01/1753')
								THEN NULL
							ELSE ISNULL(@pvlDateEnd, PvlDateEnd)
						 END
		,[PvlUserCode1] =  ISNULL(@pvlUserCode1, PvlUserCode1)
		,[PvlUserCode2] =  ISNULL(@pvlUserCode2, PvlUserCode2)
		,[PvlUserCode3] =  ISNULL(@pvlUserCode3, PvlUserCode3)
		,[PvlUserCode4] =  ISNULL(@pvlUserCode4, PvlUserCode4)
		,[PvlUserCode5] =  ISNULL(@pvlUserCode5, PvlUserCode5)
		,[ChangedBy] = @changedBy
		,[DateChanged] = @dateChanged
	WHERE [Id] = @id




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

