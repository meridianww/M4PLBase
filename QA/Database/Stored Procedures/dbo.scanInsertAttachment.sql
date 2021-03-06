SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/10/2018
-- Description:	The stored procedure Inserts attachments for the Scanner into the M4PL Attachment table
-- =============================================
CREATE PROCEDURE [dbo].[scanInsertAttachment]
	-- Add the parameters for the stored procedure here
	@TableName nvarchar,
	@PrimaryRecordId bigint,
	@ItemNumber int,
	@AttachmentTitle nvarchar,
	@TypeId int,
	@FileName nvarchar,
	@Data varbinary,
	@StatusId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/****** Script for SelectTopNRows command from SSMS  ******/
INSERT INTO [SYSTM020Ref_Attachments]([AttTableName]
      ,[AttPrimaryRecordID]
      ,[AttItemNumber]
      ,[AttTitle]
      ,[AttTypeId]
      ,[AttFileName]
      ,[AttData]
      ,[StatusId] )
     VALUES
	 (@TableName,@PrimaryRecordId,@ItemNumber,@AttachmentTitle,@TypeId,@FileName,@Data,@StatusId)
          --( 'JobCargo',27261,1,'Test Insert.txt',NULL,'File.txt',NULL,1)
END
GO
