CREATE PROCEDURE [dbo].[GetJobDeliveryComment]
	@JobId BIGINT
AS
BEGIN

	SET NOCOUNT ON;
		 
   SELECT 
   JobDeliveryCommentText
   from JOBDL000Master where Id = @JobId
   
END