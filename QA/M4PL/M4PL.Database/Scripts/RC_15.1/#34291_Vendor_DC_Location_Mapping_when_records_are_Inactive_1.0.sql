USE [M4PL_Dev]
GO
/****** Object:  StoredProcedure [dbo].[InsAssignUnassignProgram]    Script Date: 2/18/2019 10:54:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               12/01/2018      
-- Description:               Map vendor Locations
-- Execution:                 EXEC [dbo].[InsAssignUnassignProgram]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
                 
ALTER PROCEDURE [dbo].[InsAssignUnassignProgram] @userId BIGINT        
	 ,@parentId BIGINT        
	 ,@assign BIT        
	 ,@locationIds VARCHAR(MAX)        
	 ,@vendorIds VARCHAR(MAX) = NULL      
	 ,@enteredBy NVARCHAR(50) = NULL      
	 ,@assignedOn DATETIME2(7) = NULL        
AS        
BEGIN TRY        
 BEGIN TRANSACTION        
        
 DECLARE @success BIT  = 0        
        
 IF @assign = 1        
 BEGIN        
  DECLARE @MaxItemNumber INT        
       
  SELECT @MaxItemNumber = PvlItemNumber        
  FROM [dbo].[PRGRM051VendorLocations]        
  WHERE PvlProgramID = @parentId        
   AND StatusId IN (1,2)        
        
  IF LEN(ISNULL(@locationIds, '')) > 0        
  BEGIN        
   -- map vendor locations by location Ids            
   INSERT INTO [dbo].[PRGRM051VendorLocations] (        
    PvlProgramID        
    ,PvlVendorID        
    ,PvlItemNumber        
    ,PvlLocationCode        
    ,PvlLocationTitle        
    ,PvlContactMSTRID        
    ,StatusId        
    ,EnteredBy        
    ,DateEntered        
    )        
   SELECT @parentId        
    ,(SELECT VdcVendorID       FROM VEND040DCLocations  WHERE Id = Item  )        
    ,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (ORDER BY Item  )        
    ,(SELECT VdcLocationCode  FROM VEND040DCLocations  WHERE Id = Item  )        
    ,(SELECT VdcLocationTitle  FROM VEND040DCLocations  WHERE Id = Item  )        
    ,(SELECT VdcContactMSTRID  FROM VEND040DCLocations WHERE Id = Item )        
    ,1        
    ,@enteredBy        
    ,ISNULL(@assignedOn,GETUTCDATE())        
   FROM dbo.fnSplitString(@locationIds, ',');        
        
    SET @success = 1        
        
   END        
        
  -- map vendor locations by vendor Ids            
      
      
  IF LEN(ISNULL(@vendorIds, '')) > 0        
  BEGIN        
     SELECT @MaxItemNumber = PvlItemNumber   FROM [dbo].[PRGRM051VendorLocations] WHERE PvlProgramID = @parentId  AND StatusId IN (1,2)        
      
      
    INSERT INTO [dbo].[PRGRM051VendorLocations] (        
     PvlProgramID        
    ,PvlVendorID        
    ,PvlItemNumber        
    ,PvlLocationCode        
    ,PvlLocationTitle        
    ,PvlContactMSTRID        
    ,StatusId        
    ,EnteredBy        
    ,DateEntered        
    )        
   SELECT @parentId        
    ,VdcVendorID        
    ,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (ORDER BY Id  )        
    ,VdcLocationCode       
    ,VdcLocationTitle       
    ,VdcContactMSTRID      
    ,1        
    ,@enteredBy        
    ,ISNULL(@assignedOn,GETUTCDATE())  
 FROM  VEND040DCLocations  
 WHERE VdcVendorID IN (select Item from dbo.fnSplitString(@vendorIds, ',')) 
 AND StatusId =1 
 AND VdcLocationCode NOT IN (select PvlLocationCode FROM PRGRM051VendorLocations WHERE PvlProgramID = @parentId AND StatusId IN (1,2) AND PvlVendorID  IN (select Item from dbo.fnSplitString(@vendorIds, ',')));      
      
   INSERT INTO [dbo].[PRGRM051VendorLocations] (        
    PvlProgramID        
    ,PvlVendorID        
    ,PvlItemNumber        
    ,PvlLocationCode        
    ,PvlLocationTitle        
    ,PvlContactMSTRID        
    ,StatusId        
    ,EnteredBy        
    ,DateEntered        
    )        
   SELECT @parentId        
    ,Item        
    ,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (        
     ORDER BY Item        
     )        
    ,(        
     SELECT VendCode        
     FROM VEND000Master        
     WHERE Id = Item        
     )        
    ,(        
     SELECT VendTitle        
     FROM VEND000Master        
     WHERE Id = Item        
     )        
    ,(        
     SELECT ISNULL(VendWorkAddressId, ISNULL(VendCorporateAddressId, VendBusinessAddressId))        
     FROM VEND000Master        
     WHERE Id = Item    
     )        
    ,1        
     ,@enteredBy        
    ,ISNULL(@assignedOn,GETUTCDATE())  
   FROM dbo.fnSplitString(@vendorIds, ',')      
   WHERE ITEM  Not In (SELECT VdcVendorID FROM  VEND040DCLocations WHERE vdcvendorId IN (select Item from dbo.fnSplitString(@vendorIds, ',')) AND StatusId =1  );        
        
   -- Create DC Locations for the vendor When location is not exits        
   INSERT INTO  VEND040DCLocations (        
     VdcVendorID        
    ,VdcItemNumber        
    ,VdcLocationCode  
	,VdcCustomerCode            
    ,VdcLocationTitle        
    ,VdcContactMSTRID        
    ,StatusId        
    ,EnteredBy        
    ,DateEntered        
    )        
   SELECT Item        
    ,1        
    ,(        
     SELECT VendCode        
     FROM VEND000Master        
     WHERE Id = Item        
     ) 
	 ,(        
     SELECT VendCode        
     FROM VEND000Master        
     WHERE Id = Item        
     )      
	        
    ,(        
     SELECT VendTitle        
     FROM VEND000Master        
     WHERE Id = Item        
     )        
    ,(        
     SELECT ISNULL(VendWorkAddressId, ISNULL(VendCorporateAddressId, VendBusinessAddressId))        
     FROM VEND000Master        
     WHERE Id = Item        
     )        
    ,1        
     ,@enteredBy        
    ,ISNULL(@assignedOn,GETUTCDATE())   
   FROM dbo.fnSplitString(@vendorIds, ',')  WHERE ITEM  Not In (SELECT VdcVendorID FROM  VEND040DCLocations WHERE vdcvendorId IN (select Item from dbo.fnSplitString(@vendorIds, ',')) AND StatusId =1 );          
        
   SET @success = 1        
  END        
 END        
 ELSE        
 BEGIN      
  IF LEN(ISNULL(@locationIds, '')) > 0        
  BEGIN        
        UPDATE [dbo].[PRGRM051VendorLocations]   SET StatusId = 3  
                                              ,DateChanged = ISNULL(@assignedOn,GETUTCDATE())        
             ,ChangedBy = @enteredBy  
           WHERE Id IN ( SELECT Item    FROM dbo.fnSplitString(@LocationIds, ',') )        
                AND PvlProgramID = @parentId;     
  END    
  IF LEN(ISNULL(@vendorIds, '')) > 0    
  BEGIN    
        UPDATE [dbo].[PRGRM051VendorLocations]   SET StatusId = 3    
                                           ,DateChanged = ISNULL(@assignedOn,GETUTCDATE())        
             ,ChangedBy = @enteredBy      
           WHERE Id IN (SELECT Id FROM PRGRM051VendorLocations WHERE PvlVendorID IN (SELECT Item    FROM dbo.fnSplitString(@vendorIds, ',')) AND StatusId IN(1,2) )        
                AND PvlProgramID = @parentId;     
             
  END    
       
        
        
  --Update Item No after delete           
  CREATE TABLE #temptable (        
   Id BIGINT        
   ,PvlItemNumber INT        
   )        
        
  INSERT INTO #temptable (        
   Id        
   ,PvlItemNumber        
   )        
  SELECT Id        
   ,ROW_NUMBER() OVER (        
    ORDER BY PvlItemNumber        
    )        
  FROM PRGRM051VendorLocations        
  WHERE PvlProgramID = @parentId        
   AND StatusId IN (        
    1        
    ,2        
    )        
  ORDER BY Id        
        
  MERGE INTO PRGRM051VendorLocations c1        
  USING #temptable c2        
   ON c1.Id = c2.Id        
  WHEN MATCHED        
   THEN        
    UPDATE        
    SET c1.PvlItemNumber = c2.PvlItemNumber;        
        
     SET @success = 1        
 END        
        
 COMMIT TRANSACTION        
 SELECT @success        
END TRY        
        
BEGIN CATCH        
 ROLLBACK TRANSACTION        
        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity   
END CATCH
