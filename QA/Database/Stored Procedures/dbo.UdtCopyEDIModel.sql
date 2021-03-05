CREATE PROCEDURE [dbo].[UdtCopyEDIModel] (
	@UdtCopyPPPModel CopyPPPModel READONLY
	,@createdBy NVARCHAR(50)
	,@OrgId BIGINT
	,@userId BIGINT
	,@langCode NVARCHAR(10)
	,@PacificDateTime DATETIME2(7)
	)
AS
BEGIN
	DECLARE @recordId BIGINT
		,@IsSelected BIT
		,@configIds NVARCHAR(MAX)
		,@toCustOrPPIds NVARCHAR(MAX)
		,@ediHeaderIdOld BIGINT
		,@ediHeaderIdScope BIGINT
		,@ediMappingIdScope BIGINT
		,@countItemNumber INT = 0

	SELECT @recordId = RecordId
		,@IsSelected = SelectAll
		,@configIds = ConfigurationIds
		,@toCustOrPPIds = ToPPPIds
	FROM @UdtCopyPPPModel
	WHERE (
			ParentId IS NULL
			OR ParentId = 0
			);

	IF (ISNULL(@recordId, 0) > 0)
	BEGIN
		SELECT @countItemNumber = MAX(ID) + 1 FROM [dbo].[PRGRM070EdiHeader]
		
		INSERT INTO [dbo].[PRGRM070EdiHeader] (
			[PehParentEDI]
			,[PehProgramID]
			,[PehItemNumber]
			,[PehEdiCode]
			,[PehEdiTitle]
			,[PehEdiDescription]
			,[PehTradingPartner]
			,[PehEdiDocument]
			,[PehEdiVersion]
			,[PehSCACCode]
			,[PehSndRcv]
			,[PehInsertCode]
			,[PehUpdateCode]
			,[PehCancelCode]
			,[PehHoldCode]
			,[PehOriginalCode]
			,[PehReturnCode]
			,[PehInOutFolder]
			,[PehArchiveFolder]
			,[PehProcessFolder]
			,[UDF01]
			,[UDF02]
			,[UDF03]
			,[UDF04]
			,[UDF05]
			,[UDF06]
			,[UDF07]
			,[UDF08]
			,[UDF09]
			,[UDF10]
			,[PehAttachments]
			,[StatusId]
			,[PehDateStart]
			,[PehDateEnd]
			,[EnteredBy]
			,[DateEntered]
			,[ChangedBy]
			,[DateChanged]
			,[PehFtpServerUrl]
			,[PehFtpUsername]
			,[PehFtpPassword]
			,[PehFtpPort]
			,[IsSFTPUsed]
			)
		SELECT [PehParentEDI]
			,[PehProgramID]
			,@countItemNumber
			,[PehEdiCode]
			,[PehEdiTitle]
			,[PehEdiDescription]
			,[PehTradingPartner]
			,[PehEdiDocument]
			,[PehEdiVersion]
			,[PehSCACCode]
			,[PehSndRcv]
			,[PehInsertCode]
			,[PehUpdateCode]
			,[PehCancelCode]
			,[PehHoldCode]
			,[PehOriginalCode]
			,[PehReturnCode]
			,[PehInOutFolder]
			,[PehArchiveFolder]
			,[PehProcessFolder]
			,[UDF01]
			,[UDF02]
			,[UDF03]
			,[UDF04]
			,[UDF05]
			,[UDF06]
			,[UDF07]
			,[UDF08]
			,[UDF09]
			,[UDF10]
			,[PehAttachments]
			,[StatusId]
			,[PehDateStart]
			,[PehDateEnd]
			,[EnteredBy]
			,[DateEntered]
			,[ChangedBy]
			,[DateChanged]
			,[PehFtpServerUrl]
			,[PehFtpUsername]
			,[PehFtpPassword]
			,[PehFtpPort]
			,[IsSFTPUsed]
		FROM [dbo].[PRGRM070EdiHeader] WHERE [PehProgramID] = @recordId AND [StatusId] = 1
		
		SET @ediHeaderIdScope = SCOPE_IDENTITY();

		IF(ISNULL(@ediHeaderIdScope, 0) > 0)
		BEGIN
		INSERT INTO [dbo].[PRGRM071EdiMapping]
           ([PemHeaderID]
           ,[PemEdiTableName]
           ,[PemEdiFieldName]
           ,[PemEdiFieldDataType]
           ,[PemSysTableName]
           ,[PemSysFieldName]
           ,[PemSysFieldDataType]
           ,[StatusId]
           ,[PemInsertUpdate]
           ,[PemDateStart]
           ,[PemDateEnd]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
     SELECT [PemHeaderID]
           ,[PemEdiTableName]
           ,[PemEdiFieldName]
           ,[PemEdiFieldDataType]
           ,[PemSysTableName]
           ,[PemSysFieldName]
           ,[PemSysFieldDataType]
           ,[StatusId]
           ,[PemInsertUpdate]
           ,[PemDateStart]
           ,[PemDateEnd]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged] 
		   FROM [dbo].[PRGRM071EdiMapping] PRGEM
		   INNER JOIN [dbo].[PRGRM070EdiHeader] PRGEH 
		   ON PRGEM.[PemHeaderID] = PRGEH.Id AND PRGEM.[StatusId] = 1 AND PRGEH.[StatusId] = 1 AND PRGEH.[PehProgramID] = @recordId
		   
		   SET @ediMappingIdScope = SCOPE_IDENTITY();
		   --IF(ISNULL(@ediMappingIdScope, 0)>0)
		   --BEGIN

		   --END
		END

	END
END
GO

