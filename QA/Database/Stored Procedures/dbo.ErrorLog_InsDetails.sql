SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               5/1/2018      
-- Description:               Add error details into database  
-- Execution:                 EXEC [dbo].[ErrorLog_InsDetails]   
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE [dbo].[ErrorLog_InsDetails]
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
				DATEADD(HOUR,-7,GETUTCDATE())
			)
		END
	END TRY 
	BEGIN CATCH
		DECLARE	@spName VARCHAR(MAX) = (SELECT OBJECT_NAME(@@PROCID))
		EXEC [ErrorLog_LogDBErrors]  @spName   
	END CATCH 
END
GO
