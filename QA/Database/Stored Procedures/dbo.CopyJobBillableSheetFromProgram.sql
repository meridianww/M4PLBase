USE [M4PL_DEV_NEW]
GO
/****** Object:  StoredProcedure [dbo].[CopyJobBillableSheetFromProgram]    Script Date: 8/7/2019 2:27:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2019) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */        
-- =============================================                
-- Author:                  Nikhil Chauhan          
-- Create date:             08/07/2019              
-- Description:             Copy Billable sheet from program        
-- Execution:               EXEC [dbo].[CopyJobBillableSheetFromProgram]     
-- Modified on:          
      
-- =============================================              
              
ALTER PROCEDURE  [dbo].[CopyJobBillableSheetFromProgram]              
     (
	 @JobID BIGINT,
	 @ProgramID  bigint,
	 @dateEntered datetime2(7),
	 @enteredBy nvarchar(50),
	 @jobSiteCode  nvarchar(30),
	 @userId BIGINT
	 )
AS              
BEGIN TRY        
IF NOT EXISTS (select 1 from PRGRM042ProgramBillableLocations PBL INNER JOIN    [dbo].[PRGRM000Master] PM ON PM.ID = PBL.PblProgramID   INNER JOIN    [dbo].[fnGetUserStatuses](1) STA  ON  STA.StatusId = PBL.StatusId  where PBL.PblLocationCode = @jobSiteCode and PBL.PblProgramID = @ProgramID)

 BEGIN                    
 INSERT INTO [dbo].[JOBDL061BillableSheet]
           ([JobID]
           ,[prcLineItem] 
           ,[prcChargeID]
           ,[prcChargeCode]
           ,[prcTitle]
           ,[prcUnitId]
           ,[prcRate]
		   ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
          )
SELECT   @JobID
		,ROW_NUMBER() OVER(ORDER BY Pbr.[Id])    -- this line needs to be updated 
		,Pbr.[Id]
		,Pbr.[PbrCustomerCode]
		,Pbr.[PbrTitle]
		,Pbr.[RateUnitTypeId]
		,Pbr.[PbrBillablePrice]
		,pbr.[StatusId]
		,@enteredBy
		,@dateEntered
		FROM [dbo].[PRGRM040ProgramBillableRate] Pbr  INNER JOIN  PRGRM042ProgramBillableLocations pbl on pbl.Id= pbr.ProgramLocationId   INNER JOIN  [dbo].[fnGetUserStatuses](@userId) fgus ON pbr.StatusId = fgus.StatusId  Where pbl.PblProgramID = @ProgramID AND pbl.PblVendorID IS NULL ORDER BY pbr.Id 
 END
 ELSE
 BEGIN
INSERT INTO [dbo].[JOBDL061BillableSheet]
           ([JobID]
           ,[prcLineItem] 
           ,[prcChargeID]
           ,[prcChargeCode]
           ,[prcTitle]
           ,[prcUnitId]
           ,[prcRate]
		   ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
           )
SELECT   @JobID
		,ROW_NUMBER() OVER(ORDER BY Pbr.[Id])    -- this line needs to be updated  
		,Pbr.[Id]
		,Pbr.[PbrCustomerCode]
		,Pbr.[PbrTitle]
		,Pbr.[RateUnitTypeId]
		,Pbr.[PbrBillablePrice]
		,Pbr.[StatusId]
		,@enteredBy
		,@dateEntered
		 FROM [dbo].[PRGRM040ProgramBillableRate]  Pbr  INNER JOIN  PRGRM042ProgramBillableLocations pbl on pbl.Id= pbr.ProgramLocationId  INNER JOIN  [dbo].[fnGetUserStatuses](@userId) fgus ON Pbr.StatusId = fgus.StatusId  ORDER BY Pbr.Id

    END                       
END TRY                            
BEGIN CATCH                              
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                              
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                              
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                              
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                              
END CATCH