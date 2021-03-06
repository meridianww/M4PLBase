SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnDriverList 
-- Execution:                 EXEC [dbo].[InsScnDriverList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsScnDriverList]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@driverID BIGINT = NULL
	,@firstName NVARCHAR(50) = NULL
	,@lastName NVARCHAR(50) = NULL
	,@programID BIGINT = NULL
	,@locationNumber NVARCHAR(20) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN016DriverList]
           ([DriverID]
           ,[FirstName]
           ,[LastName]
           ,[ProgramID]
           ,[LocationNumber])
     VALUES
           (@driverID
		   ,@firstName
		   ,@lastName
		   ,@programID
		   ,@locationNumber) 
		   --SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetScnDriverList] @userId, @roleId, 0 ,@driverID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
