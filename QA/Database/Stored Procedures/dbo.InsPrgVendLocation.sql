SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/16/2018      
-- Description:               Ins a  Program vendor location
-- Execution:                 EXEC [dbo].[InsPrgVendLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
  
CREATE PROCEDURE  [dbo].[InsPrgVendLocation]  
	(@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@pvlProgramID bigint  
	,@pvlVendorID bigint  
	,@pvlItemNumber int  
	,@pvlLocationCode nvarchar(20)  
	,@pvlLocationCodeCustomer nvarchar(20)  
	,@pvlLocationTitle nvarchar(50)  
	,@pvlContactMSTRID bigint  
	,@statusId int  
	,@pvlDateStart datetime2(7)  
	,@pvlDateEnd datetime2(7)
	,@pvlUserCode1 NVARCHAR(20) = NULL
	,@pvlUserCode2 NVARCHAR(20) = NULL
	,@pvlUserCode3 NVARCHAR(20) = NULL
	,@pvlUserCode4 NVARCHAR(20) = NULL
	,@pvlUserCode5 NVARCHAR(20) = NULL  
	,@enteredBy nvarchar(50)  
	,@dateEntered datetime2(7))  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT        
   EXEC [dbo].[ResetItemNumber] @userId, 0, @pvlProgramID, @entity, @pvlItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT    
 DECLARE @currentId BIGINT;  
 INSERT INTO [dbo].[PRGRM051VendorLocations]  
           ([PvlProgramID]  
   ,[PvlVendorID]  
   ,[PvlItemNumber]  
   ,[PvlLocationCode]  
   ,[PvlLocationCodeCustomer]  
   ,[PvlLocationTitle]  
   ,[PvlContactMSTRID]  
   ,[StatusId]  
   ,[PvlDateStart]  
   ,[PvlDateEnd] 
   ,[PvlUserCode1]
   ,[PvlUserCode2]
   ,[PvlUserCode3]
   ,[PvlUserCode4]
   ,[PvlUserCode5]
   ,[EnteredBy]  
   ,[DateEntered])  
     VALUES  
           (@pvlProgramID  
      ,@pvlVendorID  
      ,@updatedItemNumber  
      ,@pvlLocationCode  
      ,@pvlLocationCodeCustomer  
      ,@pvlLocationTitle  
      ,@pvlContactMSTRID  
      ,@statusId  
      ,@pvlDateStart  
      ,@pvlDateEnd
	  ,@pvlUserCode1
	  ,@pvlUserCode2
	  ,@pvlUserCode3
	  ,@pvlUserCode4
	  ,@pvlUserCode5
   ,@enteredBy  
   ,@dateEntered)  
   SET @currentId = SCOPE_IDENTITY();  
 SELECT * FROM [dbo].[PRGRM051VendorLocations] WHERE Id = @currentId;  
END TRY                
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
