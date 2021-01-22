/* Copyright (2021) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    PrashantD         
-- Create date:               01/22/2021        
-- Description:               UpdateJobDriverAlert  
-- Execution:                 EXEC [dbo].[UpdateJobDriverAlert]  
-- Modified on:    
-- Modified Desc:    
-- =============================================  
CREATE PROCEDURE [dbo].[UpdateJobDriverAlert]
(
	@jobId BIGINT,
	@driverAlert NVARCHAR(MAX),
	@dateChanged DATETIME,
	@changedBy NVARCHAR(50)
)
AS                             
 SET NOCOUNT ON;    

 UPDATE JOBDL000Master
 SET JobDriverAlert=@driverAlert
 WHERE Id = @jobId

 Go