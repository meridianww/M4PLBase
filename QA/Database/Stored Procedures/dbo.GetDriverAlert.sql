/* Copyright (2021) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Nathan Fujimoto        
-- Create date:               05/06/2021      
-- Description:               Get a Job Driver Alert Notes
-- Execution                  EXEC [dbo].[GetJobDriverAlert] 37417 
-- =============================================    
Create PROCEDURE [dbo].[GetJobDriverAlert]
	@JobId BIGINT
AS
BEGIN

	SET NOCOUNT ON;
		 
   SELECT Id, 
   JobDriverAlert
   from JOBDL000Master where Id = @JobId
   
END