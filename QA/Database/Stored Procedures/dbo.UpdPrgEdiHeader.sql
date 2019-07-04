SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program EDI header
-- Execution:                 EXEC [dbo].[UpdPrgEdiHeader]
-- Modified Desc:             Added OrderType and SetPurpose fields
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)               05/10/2018
-- =============================================
CREATE PROCEDURE  [dbo].[UpdPrgEdiHeader]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@pehProgramId bigint = NULL
	,@pehItemNumber int = NULL
	,@pehEdiCode nvarchar(20) = NULL
	,@pehEdiTitle nvarchar(50) = NULL
	,@pehTradingPartner nvarchar(20) = NULL
	,@pehEdiDocument nvarchar(20) = NULL
	,@pehEdiVersion nvarchar(20) = NULL
	,@pehSCACCode nvarchar(20) = NULL
	,@pehInsertCode   nvarchar(20)
	,@pehUpdateCode   nvarchar(20)
	,@pehCancelCode   nvarchar(20)
	,@pehHoldCode     nvarchar(20)
	,@pehOriginalCode nvarchar(20)
	,@pehReturnCode	  nvarchar(20)
	,@uDF01 nvarchar(20)
	,@uDF02 nvarchar(20)
	,@uDF03 nvarchar(20)
	,@uDF04 nvarchar(20)
	,@uDF05 nvarchar(20)
	,@uDF06 nvarchar(20)
	,@uDF07 nvarchar(20)
	,@uDF08 nvarchar(20)
	,@uDF09 nvarchar(20)
	,@uDF10 nvarchar(20)           
	,@pehAttachments int = NULL
	,@statusId int = NULL
	,@pehDateStart datetime2(7) = NULL
	,@pehDateEnd datetime2(7) = NULL
	,@pehSndRcv bit =NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @pehProgramId, @entity, @pehItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT

 UPDATE [dbo].[PRGRM070EdiHeader]
		SET  [PehProgramID]          =  CASE WHEN (@isFormView = 1) THEN @pehProgramId WHEN ((@isFormView = 0) AND (@pehProgramId=-100)) THEN NULL ELSE ISNULL(@pehProgramId, PehProgramID) END
			,[PehItemNumber]         =  CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PehItemNumber) END
			,[PehEdiCode]            =  CASE WHEN (@isFormView = 1) THEN @pehEdiCode WHEN ((@isFormView = 0) AND (@pehEdiCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehEdiCode, PehEdiCode) END
			,[PehEdiTitle]           =  CASE WHEN (@isFormView = 1) THEN @pehEdiTitle WHEN ((@isFormView = 0) AND (@pehEdiTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pehEdiTitle, PehEdiTitle) END
			,[PehTradingPartner]     =  CASE WHEN (@isFormView = 1) THEN @pehTradingPartner WHEN ((@isFormView = 0) AND (@pehTradingPartner='#M4PL#')) THEN NULL ELSE ISNULL(@pehTradingPartner, PehTradingPartner) END
			,[PehEdiDocument]        =  CASE WHEN (@isFormView = 1) THEN @pehEdiDocument WHEN ((@isFormView = 0) AND (@pehEdiDocument='#M4PL#')) THEN NULL ELSE ISNULL(@pehEdiDocument, PehEdiDocument) END
			,[PehEdiVersion]         =  CASE WHEN (@isFormView = 1) THEN @pehEdiVersion WHEN ((@isFormView = 0) AND (@pehEdiVersion='#M4PL#')) THEN NULL ELSE ISNULL(@pehEdiVersion, PehEdiVersion) END
			,[PehSCACCode]           =  CASE WHEN (@isFormView = 1) THEN @pehSCACCode WHEN ((@isFormView = 0) AND (@pehSCACCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehSCACCode, PehSCACCode) END
			,[PehInsertCode]         =  CASE WHEN (@isFormView = 1) THEN @pehInsertCode WHEN ((@isFormView = 0) AND (@pehInsertCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehInsertCode, PehInsertCode) END
			,[PehUpdateCode]         =  CASE WHEN (@isFormView = 1) THEN @pehUpdateCode WHEN ((@isFormView = 0) AND (@pehUpdateCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehUpdateCode, PehUpdateCode) END
			,[PehCancelCode]         =  CASE WHEN (@isFormView = 1) THEN @pehCancelCode WHEN ((@isFormView = 0) AND (@pehCancelCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehCancelCode, PehCancelCode) END
			,[PehHoldCode]           =  CASE WHEN (@isFormView = 1) THEN @pehHoldCode WHEN ((@isFormView = 0) AND (@pehHoldCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehHoldCode, PehHoldCode) END
			,[PehOriginalCode]       =  CASE WHEN (@isFormView = 1) THEN @pehOriginalCode WHEN ((@isFormView = 0) AND (@pehOriginalCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehOriginalCode, PehOriginalCode) END
			,[PehReturnCode]         =  CASE WHEN (@isFormView = 1) THEN @pehReturnCode WHEN ((@isFormView = 0) AND (@pehReturnCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehReturnCode, PehReturnCode) END
			,[UDF01]         =  CASE WHEN (@isFormView = 1) THEN @uDF01 WHEN ((@isFormView = 0) AND (@uDF01='#M4PL#')) THEN NULL ELSE ISNULL(@uDF01, UDF01) END
			,[UDF02]         =  CASE WHEN (@isFormView = 1) THEN @uDF02 WHEN ((@isFormView = 0) AND (@uDF02='#M4PL#')) THEN NULL ELSE ISNULL(@uDF02, UDF02) END
			,[UDF03]         =  CASE WHEN (@isFormView = 1) THEN @uDF03 WHEN ((@isFormView = 0) AND (@uDF03='#M4PL#')) THEN NULL ELSE ISNULL(@uDF03, UDF03) END
			,[UDF04]         =  CASE WHEN (@isFormView = 1) THEN @uDF04 WHEN ((@isFormView = 0) AND (@uDF04='#M4PL#')) THEN NULL ELSE ISNULL(@uDF04, UDF04) END
			,[UDF05]         =  CASE WHEN (@isFormView = 1) THEN @uDF05 WHEN ((@isFormView = 0) AND (@uDF05='#M4PL#')) THEN NULL ELSE ISNULL(@uDF05, UDF05) END
			,[UDF06]         =  CASE WHEN (@isFormView = 1) THEN @uDF06 WHEN ((@isFormView = 0) AND (@uDF06='#M4PL#')) THEN NULL ELSE ISNULL(@uDF06, UDF06) END
			,[UDF07]         =  CASE WHEN (@isFormView = 1) THEN @uDF07 WHEN ((@isFormView = 0) AND (@uDF07='#M4PL#')) THEN NULL ELSE ISNULL(@uDF07, UDF07) END
			,[UDF08]         =  CASE WHEN (@isFormView = 1) THEN @uDF08 WHEN ((@isFormView = 0) AND (@uDF08='#M4PL#')) THEN NULL ELSE ISNULL(@uDF08, UDF08) END
			,[UDF09]         =  CASE WHEN (@isFormView = 1) THEN @uDF09 WHEN ((@isFormView = 0) AND (@uDF09='#M4PL#')) THEN NULL ELSE ISNULL(@uDF09, UDF09) END
			,[UDF10]         =  CASE WHEN (@isFormView = 1) THEN @uDF10 WHEN ((@isFormView = 0) AND (@uDF10='#M4PL#')) THEN NULL ELSE ISNULL(@uDF10, UDF10) END
			

			--,[PehAttachments]        =  CASE WHEN (@isFormView = 1) THEN @pehAttachments WHEN ((@isFormView = 0) AND (@pehAttachments=-100)) THEN NULL ELSE ISNULL(@pehAttachments, PehAttachments) END
			,[StatusId]              =  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[PehDateStart]          =  CASE WHEN (@isFormView = 1) THEN @pehDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pehDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pehDateStart, PehDateStart) END
			,[PehDateEnd]            =  CASE WHEN (@isFormView = 1) THEN @pehDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pehDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pehDateEnd, PehDateEnd) END
			,[PehSndRcv]            =  ISNULL(@pehSndRcv, PehSndRcv)  
			,[ChangedBy]             =  @changedBy
			,[DateChanged]           =  @dateChanged
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[PehProgramID]
		,prg.[PehItemNumber]
		,prg.[PehEdiCode]
		,prg.[PehEdiTitle]
		,prg.[PehTradingPartner]
		,prg.[PehEdiDocument]
		,prg.[PehEdiVersion]
		,prg.[PehSCACCode]
		,prg.[UDF01]  
		,prg.[UDF02]  
		,prg.[UDF03]  
		,prg.[UDF04]
		,prg.[PehAttachments]
		,prg.[StatusId]
		,prg.[PehDateStart]
		,prg.[PehDateEnd]
		,prg.[PehSndRcv]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
  FROM   [dbo].[PRGRM070EdiHeader] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
