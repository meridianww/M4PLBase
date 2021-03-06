SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/17/2018
-- Description:	The stored procedure updates the JOBDL000Master table Status field for Customer Sales Number and Program ID
-- =============================================
CREATE PROCEDURE [dbo].[ediUpdateJobMasterStatus]  
 -- Add the parameters for the stored procedure here  
 @CustomerReferenceNo nvarchar(30),  
 @StatusId int  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 Update JOBDL000Master Set StatusId = @StatusId   
 Where JobCustomerSalesOrder = @CustomerReferenceNo  
END
GO
