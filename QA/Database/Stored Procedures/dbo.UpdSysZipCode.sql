SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Upd a Sys ZipCode
-- Execution:                 EXEC [dbo].[UpdSysZipCode]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
CREATE PROCEDURE  [dbo].[UpdSysZipCode]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@zipcode NVARCHAR(15) = NULL
	,@zipCity NVARCHAR(50) =  NULL
	,@zipState NVARCHAR(50) =  NULL
	,@zipLatitude FLOAT =  NULL
	,@zipLongitude FLOAT = NULL 
	,@zipTimezone FLOAT =  NULL
	,@zipDST FLOAT =  NULL
	,@mrktId BIGINT  =  NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   UPDATE [dbo].[SYSTM000ZipcodeMaster]
     SET    ZipCity 		    = ISNULL(@zipCity, ZipCity)  
           ,ZipState 	        = ISNULL(@zipState, ZipState)  
           ,ZipLatitude 	    = ISNULL(@zipLatitude, ZipLatitude) 
           ,ZipLongitude        = ISNULL(@zipLongitude, ZipLongitude)  
           ,ZipTimezone 	    = ISNULL(@zipTimezone, ZipTimezone)   
           ,ZipDST 		        = ISNULL(@zipDST, ZipDST)   
           ,MrktID 		        = ISNULL(@mrktID, MrktID) 
           ,DateChanged      =   @dateChanged  
           ,ChangedBy    = @changedBy
      WHERE Zipcode = @zipcode               
	SELECT * FROM [dbo].[SYSTM000ZipcodeMaster] WHERE Zipcode = @zipcode
END TRY      
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
