
 

-- =============================================
-- Author:		Ramkumar
-- Create date: May 17 2016
-- Description:	Saving the Grid Layout of the Page
-- =============================================


CREATE PROCEDURE [dbo].[SaveGridLayout] 
	@Pagename varchar(20),
	@Layout  varchar(max),
	@UserID int= 0
AS
BEGIN TRY
	
	SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM [dbo].[SYSTM000ColumnsSorting&Ordering] (NOLOCK) WHERE ColPageName = @Pagename AND ColUserID = @UserID)
			GOTO EditUpdate;
		ELSE
			GOTO AddInsert;

	 
	AddInsert:
	BEGIN
		INSERT INTO [dbo].[SYSTM000ColumnsSorting&Ordering]
        (
			[ColPageName]
			,[ColUserId]
			,[ColGridLayout]          
			,[ColDateEntered]
			,[ColEnteredBy]
		)
		VALUES
        (
		    @Pagename
            ,@UserID
            ,@Layout
            ,GETDATE()
            ,@UserID
		) 
 
	END

	EditUpdate:
	BEGIN
		UPDATE 
			[dbo].[SYSTM000ColumnsSorting&Ordering]
		SET
            [ColGridLayout]    = @Layout           
           ,[ColDateChanged]   = GETDATE()
           ,[ColDateChangedBy] = @UserID
		 WHERE ColPageName = @Pagename AND ColUserID = @UserID
	END

END TRY
BEGIN CATCH

	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity

END CATCH