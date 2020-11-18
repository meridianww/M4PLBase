SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 11/03/2020
-- Description:	Insert Email Processing Log
-- =============================================
CREATE PROCEDURE [dbo].[InsertEmailProcessingLog]
@ScenarioTypeId INT,
@ExecutionDateTime DateTime2(7)
AS
BEGIN
	SET NOCOUNT ON;
INSERT INTO [dbo].[EmailProcessingLog] ([ScenarioTypeId],[ExecutionDateTime])
VALUES (@ScenarioTypeId,@ExecutionDateTime)
END
GO
