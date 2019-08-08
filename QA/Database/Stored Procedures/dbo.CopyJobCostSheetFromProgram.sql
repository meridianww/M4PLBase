
GO
/****** Object:  StoredProcedure [dbo].[CopyJobCostSheetFromProgram]    Script Date: 8/7/2019 12:12:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2019) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */        
-- =============================================                
-- Author:                  Nikhil Chauhan          
-- Create date:             08/06/2019              
-- Description:             Copy cost sheet from program        
-- Execution:               EXEC [dbo].[CopyJobCostSheetFromProgram]     
-- Modified on:          
      
-- =============================================              
              
Alter PROCEDURE  [dbo].[CopyJobCostSheetFromProgram]              
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
IF NOT EXISTS (select 1 from PRGRM043ProgramCostLocations Pcl INNER JOIN   [dbo].[PRGRM000Master] PM ON PM.ID = Pcl.PclProgramID   INNER JOIN    [dbo].[fnGetUserStatuses](1) STA  ON  STA.StatusId = Pcl.StatusId  where Pcl.PclLocationCode = @jobSiteCode and Pcl.PclProgramID = @ProgramID)
 BEGIN                    
 INSERT INTO [dbo].[JOBDL062CostSheet]
           ([JobID]
           ,[CstLineItem] 
           ,[CstChargeID]
           ,[CstChargeCode]
           ,[CstTitle]
           ,[CstUnitId]
           ,[CstRate]
		   ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
          )
SELECT   @JobID
		,ROW_NUMBER() OVER(ORDER BY pcr.[Id])    -- this line needs to be updated 
		,pcr.[Id]
		,pcr.[PcrVendorCode]
		,pcr.[PcrTitle]
		,pcr.[RateUnitTypeId]
		,pcr.[PcrCostRate]
		,pcr.[StatusId]
		,@enteredBy
		,@dateEntered
		FROM [dbo].[PRGRM041ProgramCostRate]  pcr   INNER JOIN  [PRGRM043ProgramCostLocations] pcl on pcl.Id= pcr.ProgramLocationId   INNER JOIN  [dbo].[fnGetUserStatuses](@userId) fgus ON pcr.StatusId = fgus.StatusId  Where pcl.PclProgramID = @ProgramID AND pcl.PclVendorID IS NULL ORDER BY pcr.Id 
 END                            
 ELSE
 BEGIN
 INSERT INTO [dbo].[JOBDL062CostSheet]
           ([JobID]
           ,[CstLineItem] --	 ,
           ,[CstChargeID]
           ,[CstChargeCode]
           ,[CstTitle]
           ,[CstUnitId]
           ,[CstRate]
		   ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
           )
SELECT   @JobID
		,ROW_NUMBER() OVER(ORDER BY pcr.[Id])    -- this line needs to be updated 
		,pcr.[Id]
		,pcr.[PcrVendorCode]
		,pcr.[PcrTitle]
		,pcr.[RateUnitTypeId]
		,pcr.[PcrCostRate]
		,pcr.[StatusId]
		,@enteredBy
		,@dateEntered
		 FROM [dbo].[PRGRM041ProgramCostRate]  pcr INNER JOIN  [PRGRM043ProgramCostLocations] pcl on pcl.Id= pcr.ProgramLocationId     INNER JOIN  [dbo].[fnGetUserStatuses](@userId) fgus ON pcr.StatusId = fgus.StatusId  Where pcl.PclProgramID = @ProgramID AND pcl.PclVendorID IS NOT NULL ORDER BY pcr.Id
 END
END TRY                            
BEGIN CATCH                              
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                              
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                              
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                              
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                              
END CATCH