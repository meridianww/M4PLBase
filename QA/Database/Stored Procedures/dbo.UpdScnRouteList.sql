SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/09/2018      
-- Description:               Update a ScnRouteList
-- Execution:                 EXEC [dbo].[UpdScnRouteList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[UpdScnRouteList]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@routeID BIGINT = NULL
	,@routeName NVARCHAR(50) = NULL
	,@programID BIGINT = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0)
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 UPDATE [dbo].[SCN016RouteList]
      SET   [RouteID]			= CASE WHEN (@isFormView = 1) THEN @routeID WHEN ((@isFormView = 0) AND (@routeID=-100)) THEN NULL ELSE ISNULL(@routeID, [RouteID]) END
           ,[RouteName]			= CASE WHEN (@isFormView = 1) THEN @routeName WHEN ((@isFormView = 0) AND (@routeName='#M4PL#')) THEN NULL ELSE ISNULL(@routeName, [RouteName]) END
           ,[ProgramID]			= CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, [ProgramID]) END
	WHERE	[RouteID] = @id

	EXEC [dbo].[GetScnRouteList] @userId, @roleId, 0 ,@id 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
