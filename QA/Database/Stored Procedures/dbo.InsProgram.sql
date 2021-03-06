SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */
-- =============================================                
-- Author:                    Akhil Chauhan                 
-- Create date:               09/06/2018              
-- Description:               Ins a program         
-- Execution:                 EXEC [dbo].[InsProgram]        
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)          
-- Modified Desc:    
-- Modified on:               15/07/2019( Nikhil)          
-- Modified Desc:             Modified to add a call to Sp CopyPPPRoleContacts. 
-- Modified on:               31/07/2019( Prashant) 
-- Modified Desc:             Modified to add insert for [PRGRM043ProgramCostLocations]. 
-- =============================================        
CREATE PROCEDURE [dbo].[InsProgram] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@prgOrgId BIGINT
	,@prgCustId BIGINT
	,@prgItemNumber NVARCHAR(20)
	,@prgProgramCode NVARCHAR(20)
	,@prgProjectCode NVARCHAR(20)
	,@prgPhaseCode NVARCHAR(20)
	,@prgProgramTitle NVARCHAR(50)
	,@prgAccountCode NVARCHAR(50)
	,@delEarliest DECIMAL(18, 2) = NULL
	,@delLatest DECIMAL(18, 2) = NULL
	,@delDay BIT = NULL
	,@pckEarliest DECIMAL(18, 2) = NULL
	,@pckLatest DECIMAL(18, 2) = NULL
	,@pckDay BIT = NULL
	,@statusId INT
	,@prgDateStart DATETIME2(7)
	,@prgDateEnd DATETIME2(7)
	,@prgDeliveryTimeDefault DATETIME2(7)
	,@prgPickUpTimeDefault DATETIME2(7)
	,@dateEntered DATETIME2(7)
	,@enteredBy NVARCHAR(50)
	,@parentId BIGINT = NULL
	,@prgRollUpBilling BIT 
	,@prgRollUpBillingJobFieldId BIGINT
	,@prgElectronicInvoice BIT
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @currentId BIGINT, @MaxItemNumber INT;

		IF(@statusId=0)
		BEGIN
			SET @statusId =1
		END

	IF ISNULL(@parentId, 0) = 0
	BEGIN
		INSERT INTO [dbo].[PRGRM000Master] (
			[PrgOrgId]
			,[PrgCustId]
			,[PrgItemNumber]
			,[PrgProgramCode]
			,[PrgProjectCode]
			,[PrgPhaseCode]
			,[PrgProgramTitle]
			,[PrgAccountCode]
			,[DelEarliest]
			,[DelLatest]
			,[DelDay]
			,[PckEarliest]
			,[PckLatest]
			,[PckDay]
			,[StatusId]
			,[PrgDateStart]
			,[PrgDateEnd]
			,[PrgDeliveryTimeDefault]
			,[PrgPickUpTimeDefault]
			,[PrgHierarchyID]
			,[PrgRollUpBilling]
			,[PrgRollUpBillingJobFieldId]
			,[PrgElectronicInvoice]
			,[DateEntered]
			,[EnteredBy]
			)
		VALUES (
			@prgOrgId
			,@prgCustId
			,@prgItemNumber
			,@prgProgramCode
			,@prgProjectCode
			,@prgPhaseCode
			,@prgProgramTitle
			,@prgAccountCode
			,@delEarliest
			,@delLatest
			,@delDay
			,@pckEarliest
			,@pckLatest
			,@pckDay
			,@statusId
			,@prgDateStart
			,@prgDateEnd
			,@prgDeliveryTimeDefault
			,@prgPickUpTimeDefault
			,HIERARCHYID::GetRoot().GetDescendant((
					SELECT MAX(PrgHierarchyID)
					FROM [dbo].[PRGRM000Master]
					WHERE PrgHierarchyID.GetAncestor(1) = HIERARCHYID::GetRoot()
					), NULL)
			,@prgRollUpBilling  
	        ,@prgRollUpBillingJobFieldId 
			,@prgElectronicInvoice
			,@dateEntered
			,@enteredBy
			)

		SET @currentId = SCOPE_IDENTITY();
			--SELECT * FROM [dbo].[PRGRM000Master] WHERE Id = @currentId;        
	END
	ELSE
	BEGIN
		DECLARE @parentNode HIERARCHYID
			,@lc HIERARCHYID

		SELECT @parentNode = [PrgHierarchyID]
		FROM [dbo].[PRGRM000Master]
		WHERE Id = @parentId

		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

		BEGIN TRANSACTION

		SELECT @lc = max(PrgHierarchyID)
		FROM [dbo].[PRGRM000Master]
		WHERE PrgHierarchyID.GetAncestor(1) = @parentNode;

		INSERT INTO [dbo].[PRGRM000Master] (
			[PrgOrgId]
			,[PrgCustId]
			,[PrgItemNumber]
			,[PrgProgramCode]
			,[PrgProjectCode]
			,[PrgPhaseCode]
			,[PrgProgramTitle]
			,[PrgAccountCode]
			,[DelEarliest]
			,[DelLatest]
			,[DelDay]
			,[PckEarliest]
			,[PckLatest]
			,[PckDay]
			,[StatusId]
			,[PrgDateStart]
			,[PrgDateEnd]
			,[PrgDeliveryTimeDefault]
			,[PrgPickUpTimeDefault]
			,[PrgHierarchyID]
			,[PrgRollUpBilling]
			,[PrgRollUpBillingJobFieldId]
			,[PrgElectronicInvoice]
			,[DateEntered]
			,[EnteredBy]
			)
		VALUES (
			@prgOrgId
			,@prgCustId
			,@prgItemNumber
			,@prgProgramCode
			,@prgProjectCode
			,@prgPhaseCode
			,@prgProgramTitle
			,@prgAccountCode
			,@delEarliest
			,@delLatest
			,@delDay
			,@pckEarliest
			,@pckLatest
			,@pckDay
			,@statusId
			,@prgDateStart
			,@prgDateEnd
			,@prgDeliveryTimeDefault
			,@prgPickUpTimeDefault
			,@parentNode.GetDescendant(@lc, NULL)
			,@prgRollUpBilling  
	        ,@prgRollUpBillingJobFieldId 
			,@prgElectronicInvoice
			,@dateEntered
			,@enteredBy
			)

		SET @currentId = SCOPE_IDENTITY();

		EXEC [dbo].[CopyPPPRoleContacts] @currentId
			,@parentId
			,@userId
			,'PrgRole'
			,NULL
			,@statusId

		COMMIT
	END

	SELECT @MaxItemNumber = PclItemNumber
	FROM [dbo].[PRGRM043ProgramCostLocations]
	WHERE PclProgramID = @currentId

	IF @parentId > 0
	BEGIN
		EXEC CopyProgramGatewaysAndAttributesFromParent @userId
			,@roleId
			,@prgOrgId
			,@currentId
			,@parentId
			,@dateEntered
			,@enteredBy;
END

INSERT INTO [dbo].[PRGRM043ProgramCostLocations] (
		[PclProgramID]
		,[PclItemNumber]
		,[PclLocationCode]
		,[PclLocationCodeCustomer]
		,[PclLocationTitle]
		,[EnteredBy]
		,[DateEntered]
		,[StatusId]
		)
	VALUES (
		@currentId
		,1
		,'Default'
		,'Default'
		,'Default Rates'
		,@enteredBy
		,@dateEntered
		,1 
		)

INSERT INTO [dbo].[PRGRM042ProgramBillableLocations] (
		[PblProgramID]
		,[PblItemNumber]
		,[PblLocationCode]
		,[PblLocationCodeVendor]
		,[PblLocationTitle]
		,[EnteredBy]
		,[DateEntered]
		,[StatusId]
		)
	VALUES (
		@currentId
		,1
		,'Default'
		,'Default'
		,'Default Rates'
		,@enteredBy
		,@dateEntered
		,1 
		)

	SELECT prg.[Id]
		,prg.[PrgOrgID]
		,prg.[PrgCustID]
		,prg.[PrgItemNumber]
		,prg.[PrgProgramCode]
		,prg.[PrgProjectCode]
		,prg.[PrgPhaseCode]
		,prg.[PrgProgramTitle]
		,prg.[PrgAccountCode]
		,prg.[DelEarliest]
		,prg.[DelLatest]
		,prg.[DelDay]
		,prg.[PckEarliest]
		,prg.[PckLatest]
		,prg.[PckDay]
		,prg.[StatusId]
		,prg.[PrgDateStart]
		,prg.[PrgDateEnd]
		,prg.[PrgDeliveryTimeDefault]
		,prg.[PrgPickUpTimeDefault]
		,prg.[PrgHierarchyID].ToString() AS PrgHierarchyID
		,prg.[PrgHierarchyLevel]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
		,prg.[PrgRollUpBilling]
		,prg.[PrgRollUpBillingJobFieldId]
		,prg.[PrgElectronicInvoice]
	FROM [dbo].[PRGRM000Master] prg
	WHERE Id = @currentId;
END TRY

BEGIN CATCH
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
