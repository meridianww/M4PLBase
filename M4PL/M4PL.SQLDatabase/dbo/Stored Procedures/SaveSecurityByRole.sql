﻿
CREATE PROCEDURE [dbo].[SaveSecurityByRole]
	 @SecurityLevelID  INT
	,@OrgRoleID        INT
	,@SecLineOrder     INT = 1
	,@SecModule        INT
	,@SecSecurityMenu  INT
	,@SecSecurityData  INT
	,@SecEnteredBy     NVARCHAR (50)
	,@SecDateChangedBy NVARCHAR (50)
AS
BEGIN TRY
	
	BEGIN TRANSACTION

	IF EXISTS (SELECT 1 FROM [dbo].SYSTM000SecurityByRole (NOLOCK) WHERE OrgRoleID = @OrgRoleID AND SecLineOrder = @SecLineOrder)
	BEGIN
		UPDATE 
			[dbo].SYSTM000SecurityByRole
		SET
			SecLineOrder = (SecLineOrder + 1)
		WHERE
			OrgRoleID = @OrgRoleID
			AND SecLineOrder >= @SecLineOrder
	END

	IF @SecurityLevelID = 0 
		GOTO AddInsert;
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM [dbo].SYSTM000SecurityByRole (NOLOCK) WHERE SecurityLevelID = @SecurityLevelID)
			GOTO EditUpdate;
		ELSE
			GOTO AddInsert;
	END

	AddInsert:
	BEGIN
		INSERT INTO [dbo].SYSTM000SecurityByRole
		(   
			 [OrgRoleID]      
			,[SecLineOrder]   
			,[SecModule]      
			,[SecSecurityMenu]
			,[SecSecurityData]
			,[SecDateEntered] 
			,[SecEnteredBy]   
		)
		VALUES
		(
			 @OrgRoleID      
			,@SecLineOrder   
			,@SecModule      
			,@SecSecurityMenu
			,@SecSecurityData
			,GETDATE()
			,@SecEnteredBy   
		)
	END

	EditUpdate:
	BEGIN
		UPDATE 
			[dbo].SYSTM000SecurityByRole
		SET
			 [OrgRoleID]        = @OrgRoleID      
			,[SecLineOrder]     = @SecLineOrder   
			,[SecModule]        = @SecModule      
			,[SecSecurityMenu]  = @SecSecurityMenu
			,[SecSecurityData]  = @SecSecurityData
			,[SecDateChanged]   = GETDATE()
			,[SecDateChangedBy] = @SecDateChangedBy 
		WHERE					   
			[SecurityLevelID] = @SecurityLevelID
	END

	COMMIT TRANSACTION

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity
END CATCH