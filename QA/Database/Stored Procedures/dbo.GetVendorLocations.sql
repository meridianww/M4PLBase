SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               02/28/2018      
-- Description:               Get all Vendor location by id  
-- Execution:                 EXEC [dbo].[GetVendorLocations]
-- Modified on:  
-- Modified Desc:  
-- =============================================                
CREATE PROCEDURE [dbo].[GetVendorLocations]
     @id BIGINT,
	 @pageNo INT,  
	 @pageSize INT,  
	 @orderBy NVARCHAR(500),  
	 @like NVARCHAR(500) = NULL,  
	 @where NVARCHAR(500) = null,
	 @primaryKeyValue NVARCHAR(100) = null,
	 @primaryKeyName NVARCHAR(50) = null      

AS                  
BEGIN TRY         
 SET NOCOUNT ON;  
 DECLARE @programId BIGINT,@vendorId BIGINT
 DECLARE @newPgNo INT
 SELECT @programId = PvlProgramID,@vendorId = PvlVendorID  FROM  [dbo].[PRGRM051VendorLocations](NOLOCK) WHERE Id =@id;
 
 IF(ISNULL(@primaryKeyValue, '') > '')
  BEGIN
	SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY Id) as Item, Id FROM [dbo].[PRGRM051VendorLocations] (NOLOCK) 
	WHERE PvlProgramID =@programId AND  PvlVendorID =@vendorId AND StatusId IN (1,2) ) t WHERE t.Id = CAST(@primaryKeyValue AS BIGINT)
	SET @newPgNo =  @newPgNo/@pageSize + 1; 
	SET @pageSize = @newPgNo * @pageSize;
  END

  SELECT Id, PvlLocationCode FROM  [dbo].[PRGRM051VendorLocations](NOLOCK) 
  WHERE  PvlProgramID =@programId 
    AND  PvlVendorID =@vendorId 
   AND StatusId IN (1,2)  
 ORDER BY Id OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);   
                
END TRY                  
BEGIN CATCH                  
                  
 DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),                  
   @ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),                  
   @RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity                  
                  
END CATCH
GO
