SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Ins a Sys ZipCode
-- Execution:                 EXEC [dbo].[InsSysZipCode]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[InsSysZipCode]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@zipcode NVARCHAR(15) 
	,@zipCity NVARCHAR(50) = NULL
	,@zipState NVARCHAR(50) = NULL 
	,@zipLatitude FLOAT = NULL 
	,@zipLongitude FLOAT = NULL 
	,@zipTimezone FLOAT = NULL 
	,@zipDST FLOAT = NULL 
	,@mrktID INT = NULL 
	,@dateEntered DATETIME2(7) = NULL 
	,@enteredBy NVARCHAR(50) = NULL   
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId NVARCHAR(15);
   INSERT INTO [dbo].[SYSTM000ZipcodeMaster]
           ([Zipcode]
           ,[ZipCity]
           ,[ZipState]
           ,[ZipLatitude]
           ,[ZipLongitude]
           ,[ZipTimezone]
           ,[ZipDST]
           ,[MrktID]
           ,[DateEntered]
           ,[EnteredBy] )  
      VALUES
		   (@zipcode 
           ,@zipCity  
           ,@zipState  
           ,@zipLatitude 
           ,@zipLongitude  
           ,@zipTimezone   
           ,@zipDST   
           ,@mrktID 
           ,@dateEntered   
           ,@enteredBy)  
		   SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[SYSTM000ZipcodeMaster] WHERE Zipcode = @currentId;  
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH





/***** Object:  StoredProcedure [dbo].[UpdUsrSetUser]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
