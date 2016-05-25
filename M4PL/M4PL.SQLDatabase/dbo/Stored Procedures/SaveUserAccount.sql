-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveUserAccount] 
	@SysUserID BIGINT
	,@SysUserContactID INT          
	,@SysScreenName    NVARCHAR (50)
	,@SysPassword      NVARCHAR (50)
	,@SysComments      NTEXT         = ''
	,@SysStatusAccount SMALLINT      = 1
	,@SysEnteredBy     NVARCHAR (50) = ''
	,@SysDateChangedBy NVARCHAR (50) = ''
AS
BEGIN TRY

	IF @SysUserID = 0 
		GOTO AddInsert;
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM dbo.SYSTM000OpnSezMe (NOLOCK) WHERE SysUserID = @SysUserID)
			GOTO EditUpdate;
		ELSE
			GOTO AddInsert;
	END

	AddInsert:
	BEGIN
		INSERT INTO dbo.SYSTM000OpnSezMe
		(
			[SysUserContactID] 
			,[SysScreenName]    
			,[SysPassword]      
			,[SysComments]      
			,[SysStatusAccount] 
			,[SysDateEntered]   
			,[SysEnteredBy]     
		)
		VALUES
		(
			 @SysUserContactID 
			,@SysScreenName    
			,@SysPassword      
			,@SysComments      
			,@SysStatusAccount 
			,GETDATE()
			,@SysEnteredBy     
		)
	END

	EditUpdate:
	BEGIN
		UPDATE 
			dbo.SYSTM000OpnSezMe
		SET
			[SysUserContactID] 	= @SysUserContactID
			,[SysScreenName]    = @SysScreenName   
			,[SysPassword]      = @SysPassword     
			,[SysComments]      = @SysComments     
			,[SysStatusAccount] = @SysStatusAccount
			,[SysDateChanged]   = GETDATE()  
			,[SysDateChangedBy]	= @SysDateChangedBy
		WHERE
			SysUserID = @SysUserID
	END
END TRY
BEGIN CATCH

	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity

END CATCH