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
	,@pehParentEDI bit
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
	,@isFormView BIT = 0
	,@PehInOutFolder VARCHAR(255)
	,@PehArchiveFolder VARCHAR(255)
	,@PehProcessFolder VARCHAR(255)
	,@PehFtpServerUrl nvarchar(255)
	,@PehFtpUsername  nvarchar(50)
	,@PehFtpPassword  nvarchar(50)
	,@PehFtpPort  nvarchar(10)
	,@IsSFTPUsed BIT = 0)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @pehProgramId, @entity, @pehItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT

 UPDATE [dbo].[PRGRM070EdiHeader]	
		SET  [PehParentEDI]           =    ISNULL(@pehParentEDI, PehParentEDI)
		    ,[PehProgramID]          =     ISNULL(@pehProgramId, PehProgramID) 
			,[PehItemNumber]         =     ISNULL(@updatedItemNumber, PehItemNumber) 
			,[PehEdiCode]            =   ISNULL(@pehEdiCode, PehEdiCode) 
			,[PehEdiTitle]           =   ISNULL(@pehEdiTitle, PehEdiTitle) 
			,[PehTradingPartner]     =   ISNULL(@pehTradingPartner, PehTradingPartner) 
			,[PehEdiDocument]        =   ISNULL(@pehEdiDocument, PehEdiDocument) 
			,[PehEdiVersion]         =  ISNULL(@pehEdiVersion, PehEdiVersion) 
			,[PehSCACCode]           =   ISNULL(@pehSCACCode, PehSCACCode) 
			,[PehInsertCode]         =   ISNULL(@pehInsertCode, PehInsertCode) 
			,[PehUpdateCode]         =   ISNULL(@pehUpdateCode, PehUpdateCode) 
			,[PehCancelCode]         =   ISNULL(@pehCancelCode, PehCancelCode) 
			,[PehHoldCode]           =   ISNULL(@pehHoldCode, PehHoldCode) 
			,[PehOriginalCode]       =   ISNULL(@pehOriginalCode, PehOriginalCode) 
			,[PehReturnCode]         =  ISNULL(@pehReturnCode, PehReturnCode) 
			,[UDF01]         =   ISNULL(@uDF01, UDF01) 
			,[UDF02]         =   ISNULL(@uDF02, UDF02) 
			,[UDF03]         =  ISNULL(@uDF03, UDF03) 
			,[UDF04]         =   ISNULL(@uDF04, UDF04) 
			,[UDF05]         =   ISNULL(@uDF05, UDF05) 
			,[UDF06]         =   ISNULL(@uDF06, UDF06) 
			,[UDF07]         =   ISNULL(@uDF07, UDF07) 
			,[UDF08]         =   ISNULL(@uDF08, UDF08) 
			,[UDF09]         =   ISNULL(@uDF09, UDF09) 
			,[UDF10]         =  ISNULL(@uDF10, UDF10) 
			,[PehInOutFolder] = ISNULL(@PehInOutFolder,PehInOutFolder)
			,[PehArchiveFolder] = ISNULL(@PehArchiveFolder, PehArchiveFolder)
			,[PehProcessFolder] = ISNULL(@PehProcessFolder,PehProcessFolder)
			,[PehFtpServerUrl] = ISNULL(@PehFtpServerUrl, PehFtpServerUrl)
			,[PehFtpUsername] = ISNULL(@PehFtpUsername, PehFtpUsername)
			,[PehFtpPassword] = ISNULL(@PehFtpPassword, PehFtpPassword)
			,[PehFtpPort] = ISNULL(@PehFtpPort, PehFtpPort)

			--,[PehAttachments]        =  CASE WHEN (@isFormView = 1) THEN @pehAttachments WHEN ((@isFormView = 0) AND (@pehAttachments=-100)) THEN NULL ELSE ISNULL(@pehAttachments, PehAttachments) END
			,[StatusId]              = ISNULL(@statusId, StatusId) 
			,[PehDateStart]          =  CASE WHEN  ((CONVERT(CHAR(10), @pehDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pehDateStart, PehDateStart) END
			,[PehDateEnd]            =  CASE  WHEN ((CONVERT(CHAR(10), @pehDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pehDateEnd, PehDateEnd) END
			,[PehSndRcv]            =  ISNULL(@pehSndRcv, PehSndRcv)  
			,[IsSFTPUsed]            =  ISNULL(@IsSFTPUsed, IsSFTPUsed)
			,[ChangedBy]             =  @changedBy
			,[DateChanged]           =  @dateChanged
	 WHERE   [Id] = @id
	SELECT prg.[Id]
	    ,prg.[PehParentEDI] 
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
