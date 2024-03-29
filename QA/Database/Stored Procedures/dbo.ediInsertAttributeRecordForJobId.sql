SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 5/14/2018
-- Description:	The stored procedure inserts a new record into the Job Attribute Table for the specified Job ID
-- =============================================
CREATE PROCEDURE [dbo].[ediInsertAttributeRecordForJobId]
	-- Add the parameters for the stored procedure here
	@JobId bigint,
	@ItemNumber int,
	@AttributeCode nvarchar(20) ,
	@AttributeTitle nvarchar(50),
	@AttributeDescription varbinary(max),
	@AttributeComments varbinary(max),
	@AttributeQuantity decimal(18,2),
	@AttributeTypeId int,
	@StatusId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[JOBDL030Attributes]
           ([JobID]
           ,[AjbLineOrder]
           ,[AjbAttributeCode]
           ,[AjbAttributeTitle]
           ,[AjbAttributeDescription]
           ,[AjbAttributeComments]
		   ,[AjbAttributeQty]
           ,[AjbUnitTypeId]
           ,[AjbDefault]
           ,[StatusId])
     VALUES
           (@JobId
           ,@ItemNumber
           ,@AttributeCode
           ,@AttributeTitle
           ,@AttributeDescription
           ,@AttributeComments
           ,@AttributeQuantity
           ,@AttributeTypeId
		   ,1
           ,@StatusId)
END
GO
