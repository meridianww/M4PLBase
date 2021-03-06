SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
    
  
  CREATE  PROCEDURE [dbo].[PrgVendLocationCopy]  
  (  
    @programId BIGINT,  
 @enteredBy NVARCHAR(50),  
 @fromRecordId BIGINT,  
 @PacificDateTime DATETIME2(7)
  )  
  AS   
  BEGIN  
   SET NOCOUNT ON;     
  
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
        
   SELECT   
    @programId  
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
	 ,@enteredBy     
   ,@PacificDateTime        
            
   FROM PRGRM051VendorLocations WHERE PvlProgramID= @fromRecordId   AND StatusId IN(1,2)     
     
END
GO
