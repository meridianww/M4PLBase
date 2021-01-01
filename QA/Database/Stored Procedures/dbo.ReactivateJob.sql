SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal          
-- Create date:               12/29/2020      
-- Description:               InsJobIsSchedule 
-- =============================================
CREATE PROCEDURE dbo.ReactivateJob @jobId BIGINT
AS
BEGIN
UPDATE dbo.JobDL000Master SET StatusId = 1 Where Id = @jobId
END