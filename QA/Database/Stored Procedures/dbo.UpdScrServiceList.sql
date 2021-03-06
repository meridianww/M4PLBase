SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Upd a Scr Service List
-- Execution:                 EXEC [dbo].[UpdScrServiceList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdScrServiceList]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id  BIGINT
	,@programID bigint = NULL
	,@serviceLineItem int = NULL
	,@serviceCode nvarchar(20) = NULL
	,@serviceTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@changedBy  NVARCHAR(50)
	,@dateChanged  DATETIME2(7)
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, @id, @programID, @entity, @serviceLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   UPDATE  [dbo].[SCR013ServiceList] 
      SET    ProgramID        =	CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, ProgramID) END
			,ServiceLineItem         =	CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, ServiceLineItem) END
			,ServiceCode             =	CASE WHEN (@isFormView = 1) THEN @serviceCode WHEN ((@isFormView = 0) AND (@serviceCode='#M4PL#')) THEN NULL ELSE ISNULL(@serviceCode, ServiceCode) END
			,ServiceTitle            =	CASE WHEN (@isFormView = 1) THEN @serviceTitle WHEN ((@isFormView = 0) AND (@serviceTitle='#M4PL#')) THEN NULL ELSE ISNULL(@serviceTitle, ServiceTitle) END
			,StatusId                =	CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,DateChanged             =	ISNULL(@dateChanged, DateChanged)
			,ChangedBy               =	ISNULL(@changedBy, ChangedBy)
       WHERE [ServiceID] = @id		   

	EXEC GetScrServiceList @userId, @roleId, 0, @id

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
