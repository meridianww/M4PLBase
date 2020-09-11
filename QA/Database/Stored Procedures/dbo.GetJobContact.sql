SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kirty Anurag     
-- Create date:               09/11/2020      
-- Description:               Get a GetJobContact  
-- =============================================   
CREATE PROCEDURE [dbo].[GetJobContact] 
    @userId BIGINT,  
    @roleId BIGINT,  
    @orgId BIGINT,  
    @id BIGINT,
	@parentId BIGINT  ,
	@PacificTime DATETIME2(7)
AS  
BEGIN                  
 SET NOCOUNT ON; 
  IF @id = 0 
BEGIN
SELECT @parentId AS ProgramID		       
END
ELSE
BEGIN  
SELECT job.[JobRouteId]
	  ,job.[JobStop]
	  ,job.ProgramID
	  ,job.[JobDriverId]
	 -- ,@parentId ParentId
	  ,Job.JobDeliveryAnalystContactID
	  ,job.JobDeliveryResponsibleContactID
		FROM [dbo].[JOBDL000Master] job
		WHERE job.[Id] = @id  
END

END
GO
