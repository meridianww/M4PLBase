SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScrInfoList 
-- Execution:                 EXEC [dbo].[InsScrInfoList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsScrInfoList]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@infoListID BIGINT = NULL
	,@infoListDesc NVARCHAR(MAX) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCR010InfoList]
           ([InfoListID]
           ,[InfoListDesc])
     VALUES
           (@infoListID
           ,@infoListDesc) 

		   --SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetScrInfoList] @userId, @roleId,0 ,@infoListID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
