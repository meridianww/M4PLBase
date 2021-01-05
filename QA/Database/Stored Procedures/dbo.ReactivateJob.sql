SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal          
-- Create date:               01/04/2021      
-- Description:               ReactivateJob 
-- =============================================
CREATE PROCEDURE dbo.ReactivateJob @jobId BIGINT
AS
BEGIN
UPDATE dbo.JobDL000Master SET StatusId = 1, JobCompleted = 0 Where Id = @jobId
END