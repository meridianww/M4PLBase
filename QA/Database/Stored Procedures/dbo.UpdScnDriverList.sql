SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnDriverList
-- Execution:                 EXEC [dbo].[UpdScnDriverList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[UpdScnDriverList]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@driverID BIGINT = NULL
	,@firstName NVARCHAR(50) = NULL
	,@lastName NVARCHAR(50) = NULL
	,@programID BIGINT = NULL
	,@locationNumber NVARCHAR(20) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0  )
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN016DriverList]
      SET   [DriverID]			= CASE WHEN (@isFormView = 1) THEN @driverID WHEN ((@isFormView = 0) AND (@driverID=-100)) THEN NULL ELSE ISNULL(@driverID, [DriverID]) END
           ,[FirstName]			= CASE WHEN (@isFormView = 1) THEN @firstName WHEN ((@isFormView = 0) AND (@firstName='#M4PL#')) THEN NULL ELSE ISNULL(@firstName  , [FirstName]) END
           ,[LastName]			= CASE WHEN (@isFormView = 1) THEN @lastName WHEN ((@isFormView = 0) AND (@lastName='#M4PL#')) THEN NULL ELSE ISNULL(@lastName, [LastName]) END
           ,[ProgramID]			= CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, [ProgramID]) END
           ,[LocationNumber]	= CASE WHEN (@isFormView = 1) THEN @locationNumber WHEN ((@isFormView = 0) AND (@locationNumber='#M4PL#')) THEN NULL ELSE ISNULL(@locationNumber, [LocationNumber]) END
	WHERE	[DriverID] = @id

	EXEC [dbo].[GetScnDriverList] @userId, @roleId, 0 ,@driverID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
