SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               02/20/2018      
-- Description:               Add or get error details into database 
-- Execution:                 EXEC [dbo].[GetOrInsErrorLog]
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [dbo].[GetOrInsErrorLog]
-- Add the parameters for the stored procedure here
@id bigint, 
@relatedTo varchar(100), 
@innerException nvarchar(1024),
@message nvarchar(MAX),
@source nvarchar(64),
@stackTrace nvarchar(MAX),
@additionalMessage nvarchar(4000)
AS
BEGIN TRY 
SET NOCOUNT ON;
IF( @id < 1 )
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
SET @id = SCOPE_IDENTITY();
END
SELECT err.[Id]
,err.[ErrRelatedTo]
,err.[ErrInnerException]
,err.[ErrMessage]
,err.[ErrSource]
,err.[ErrStackTrace]
,err.[ErrAdditionalMessage]
,err.[ErrDateStamp] FROM dbo.SYSTM000ErrorLog err WHERE err.Id = @id
END TRY                
BEGIN CATCH                
DECLARE  @errErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
  ,@errErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
  ,@errRelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
EXEC [dbo].[ErrorLog_InsDetails] @errRelatedTo, NULL, @errErrorMessage, NULL, NULL, @errErrorSeverity                
END CATCH
GO
