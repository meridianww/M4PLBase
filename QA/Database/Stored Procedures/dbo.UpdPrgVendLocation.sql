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

	DECLARE @updatedItemNumber INT, @ids NVARCHAR(50) = CAST(@id AS VARCHAR(50))

	EXEC [dbo].[ResetItemNumber] @userId
		,@id
		,@pvlProgramID
		,@entity
		,@pvlItemNumber
		,@statusId
		,NULL
		,NULL
		,@updatedItemNumber OUTPUT

 
 	UPDATE PVL
	SET PVL.[PblLocationCodeVendor] = @pvlLocationCodeCustomer
	,PVL.PblLocationCode =@pvlLocationCode
	,PVL.PblLocationTitle = @pvlLocationTitle
	,PVL.[StatusId] =  ISNULL(@statusId, PVL.[StatusId])
	From [dbo].[PRGRM042ProgramBillableLocations] PVL
	INNER JOIN PRGRM051VendorLocations PV ON PV.VendDCLocationId = PVL.PblVenderDCLocationId AND PV.StatusId IN (1,2)
	Where  PV.Id = @id  AND PVL.StatusId IN (1,2)

	UPDATE PBL
	SET PBL.[PclLocationCodeCustomer] =  @pvlLocationCodeCustomer
	,PBL.PclLocationCode =@pvlLocationCode
	,PBL.PclLocationTitle = @pvlLocationTitle
	,PBL.[StatusId] =  ISNULL(@statusId, PBL.[StatusId])
	From [dbo].[PRGRM043ProgramCostLocations]  PBL
	INNER JOIN PRGRM051VendorLocations PV ON PV.VendDCLocationId = PBL.PclVenderDCLocationId AND PV.StatusId IN (1,2)
	Where  PV.ID = @id  AND PBL.StatusId IN (1,2)

	UPDATE Job
	SET Job.[JobSiteCode] =  CASE WHEN ISNULL(@statusId,0) = 3 THEN NULL ELSE @pvlLocationCode END
	,Job.VendDCLocationId = CASE WHEN ISNULL(@statusId,0) = 3 THEN NULL ELSE Job.VendDCLocationId END
	From [dbo].[JOBDL000Master]  Job
	INNER JOIN PRGRM051VendorLocations PV ON PV.VendDCLocationId = Job.VendDCLocationId AND PV.StatusId IN (1,2)
	Where  PV.ID = @id  AND Job.StatusId IN (1,2)

	EXEC [dbo].[UpdatePrgCostLocationItemByVendor] @ids
	EXEC [dbo].[UpdatePrgBillableLocationItemByVendor] @ids
	

	--EXEC SyncVendDCLocation @userId ,@id,@entity,@pvlProgramID ,@pvlLocationCode,@pvlLocationCodeCustomer,@pvlLocationTitle,@changedBy,@dateChanged

	UPDATE [dbo].[PRGRM051VendorLocations]
	SET [PvlProgramID] =  ISNULL(@pvlProgramID, PvlProgramID)
		,[PvlVendorID] = ISNULL(@pvlVendorID, PvlVendorID)
		,[PvlItemNumber] = ISNULL(@updatedItemNumber, PvlItemNumber)
		,[PvlLocationCode] =ISNULL(@pvlLocationCode, PvlLocationCode)
		,[PvlLocationCodeCustomer] = @pvlLocationCodeCustomer
		,[PvlLocationTitle] =  @pvlLocationTitle
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

GO
