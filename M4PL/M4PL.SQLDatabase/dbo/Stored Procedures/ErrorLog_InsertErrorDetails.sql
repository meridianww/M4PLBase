

-- =============================================
-- Author:  Ramkumar 
-- Create date: 11 April 2016
-- Description: Add error details into database
-- =============================================
CREATE PROCEDURE [dbo].[ErrorLog_InsertErrorDetails]
 -- Add the parameters for the stored procedure here
 @RelatedTo varchar(100), 
 @InnerException nvarchar(1024),
 @Message nvarchar(MAX),
 @Source nvarchar(64),
 @StackTrace nvarchar(MAX),
 @AdditionalMessage nvarchar(4000)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY 
		BEGIN
			INSERT INTO dbo.SYSTM000ErrorLog
			(
				ErrRelatedTo, 
				ErrInnerException,
				ErrMessage,
				ErrSource,
				ErrStackTrace,
				ErrAdditionalMessage,
				ErrDateStamp
			)
			VALUES
			(
				@RelatedTo, 
				@InnerException,
				@Message,
				@Source,
				@StackTrace,
				@AdditionalMessage,
				GETUTCDATE()
			)
		END
	END TRY 
	BEGIN CATCH
		DECLARE	@spName VARCHAR(MAX) = (SELECT OBJECT_NAME(@@PROCID))
		EXEC [ErrorLog_LogDBErrors]  @spName   
	END CATCH 
END