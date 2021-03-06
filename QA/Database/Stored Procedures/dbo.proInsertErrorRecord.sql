SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/26/2018
-- Description:	The stored procedure Inserts the M4PL Processor Exception into the Processor Exception Log table
-- =============================================
CREATE PROCEDURE [dbo].[proInsertErrorRecord]
	-- Add the parameters for the stored procedure here
	@ProcessorName nvarchar(50),
	@SourceTable nvarchar(100),
	@SourceId bigint,
	@ExceptionPriority int,
	@ProcessorException nvarchar(1024),
	@ProcessorMessage nvarchar(max),
	@ProcessorMethod nvarchar(64),
	@ProcessorStackTrace nvarchar(max),
	@ProcessorAdditionalMessage nvarchar(4000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[SYSTM041ProcessorErrorLog]
           ([PelProcessorName]
           ,[PelSourceTable]
           ,[PelSourceId]
		   ,[PelPriority]
           ,[PelInnerException]
           ,[PelMessage]
           ,[PelMethod]
           ,[PelStackTrace]
           ,[PelAdditionalMessage]
           ,[PelDateStamp])
     VALUES
           (@ProcessorName
           ,@SourceTable
           ,@SourceId
		   ,@ExceptionPriority
           ,@ProcessorException
           ,@ProcessorMessage
           ,@ProcessorMethod
           ,@ProcessorStackTrace
           ,@ProcessorAdditionalMessage
           ,GETDATE())
END
GO
