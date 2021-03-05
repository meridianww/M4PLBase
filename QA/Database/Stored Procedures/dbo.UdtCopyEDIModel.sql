SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2019) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               03/05/2021      
-- Description:               EDI copy
-- Execution:                 EXEC [dbo].[UdtCopyEDIModel]
-- =============================================  
ALTER PROCEDURE [dbo].[UdtCopyEDIModel] (
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
		,@ediHeaderIdScope BIGINT
		,@toCustOrPPIds NVARCHAR(MAX)

	SELECT @recordId = RecordId
		,@IsSelected = SelectAll
		,@toCustOrPPIds = ToPPPIds
	FROM @UdtCopyPPPModel
	WHERE (
			ParentId IS NULL
			OR ParentId = 0
			);

	DECLARE @CustPPPIdTables TABLE (
		PrimaryId INT PRIMARY KEY IDENTITY(1, 1)
		,Id BIGINT
		);

	INSERT INTO @CustPPPIdTables (Id)
	SELECT item
	FROM [dbo].[fnSplitString](@toCustOrPPIds, ',');

	DECLARE @pId INT = 1
	DECLARE @targetId BIGINT

	SELECT @targetId = Id
	FROM @CustPPPIdTables
	WHERE PrimaryId = @pId;

	WHILE (@targetId IS NOT NULL)
	BEGIN
		IF (ISNULL(@recordId, 0) > 0)
		BEGIN
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
				,@targetId
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
			FROM [dbo].[PRGRM070EdiHeader]
			WHERE [PehProgramID] = @recordId
				AND [StatusId] = 1

			SET @ediHeaderIdScope = SCOPE_IDENTITY();

			INSERT INTO [dbo].[PRGRM072EdiConditions] (
				[PecParentProgramId]
				,[PecProgramId]
				,[PecJobField]
				,[PecCondition]
				,[PerLogical]
				,[PecJobField2]
				,[PecCondition2]
				,[EnteredBy]
				,[DateEntered]
				,[ChangedBy]
				,[DateChanged]
				)
			SELECT [PecParentProgramId]
				,@targetId
				,[PecJobField]
				,[PecCondition]
				,[PerLogical]
				,[PecJobField2]
				,[PecCondition2]
				,[EnteredBy]
				,[DateEntered]
				,[ChangedBy]
				,[DateChanged]
			FROM PRGRM072EdiConditions
			WHERE [PecProgramId] = @recordId
				AND [StatusId] = 1

			--IF (ISNULL(@ediHeaderIdScope, 0) > 0)
			--BEGIN
				INSERT INTO [dbo].[PRGRM071EdiMapping] (
					[PemHeaderID]
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
					)
				SELECT @ediHeaderIdScope
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
				FROM [dbo].[PRGRM071EdiMapping]
				WHERE PemHeaderID IN(SELECT Id FROM PRGRM070EdiHeader WHERE PehProgramID=@recordId)
			--END
		END
	END
END
GO

