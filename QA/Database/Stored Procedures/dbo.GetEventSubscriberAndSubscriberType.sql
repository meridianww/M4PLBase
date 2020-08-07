-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar
-- Create date: 07 August 2020
-- Description:	Get Subscriber and Subscriber List
-- =============================================
CREATE PROCEDURE [dbo].[GetEventSubscriberAndSubscriberType]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT SubscriberId AS Id
		,SubscriberDescription
	FROM [dbo].[EventSubscriber]

	SELECT Id
		,EventSubscriberTypeName
	FROM [dbo].[EventSubscriberType]
END
GO

