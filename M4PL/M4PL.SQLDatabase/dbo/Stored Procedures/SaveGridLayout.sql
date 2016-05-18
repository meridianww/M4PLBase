 

-- =============================================
-- Author:		Ramkumar
-- Create date: May 17 2016
-- Description:	Saving the Grid Layout of the Page
-- =============================================


Create PROCEDURE [dbo].[SaveGridLayout] 
@pagename varchar(20),
@layout  varchar(max),
@userid int= 0
AS
BEGIN
	
	SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM [dbo].[SYSTM000ColumnsSorting&Ordering] (NOLOCK) WHERE ColPageName = @pagename AND ColUserID = @userid)
			GOTO EditUpdate;
		ELSE
			GOTO AddInsert;

	 
	AddInsert:
	BEGIN
		INSERT INTO [dbo].[SYSTM000ColumnsSorting&Ordering]
           ([ColPageName]
           ,[ColUserId]
           ,[ColGridLayout]          
           ,[ColDateEntered]
           ,[ColEnteredBy])
     VALUES
           (@pagename
           ,@userid
           ,@layout
           ,getdate()
           ,@userid) 
 
	END

	EditUpdate:
	BEGIN
		UPDATE 
			[dbo].[SYSTM000ColumnsSorting&Ordering]
		SET
            [ColGridLayout]    = @layout           
           ,[ColDateChanged]   = getdate()
           ,[ColDateChangedBy] = @userid
		 WHERE ColPageName = @pagename AND ColUserID = @userid
	END

END