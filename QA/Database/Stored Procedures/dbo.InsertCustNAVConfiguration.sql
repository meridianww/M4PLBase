SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal      
-- Create date:               12/17/2020
-- Description:               INSERT Customer Nav Configuration  
-- Execution:                
-- =============================================  
ALTER PROCEDURE [dbo].[InsertCustNAVConfiguration] 
	@userId BIGINT = 0,
	@roleId BIGINT = 0,
	@orgId BIGINT = 0,
	@entity NVARCHAR(50) = NULL,
	@NAVConfigurationId BIGINT = 0,
	@ServiceUrl NVARCHAR(200) = NULL,
	@ServiceUserName NVARCHAR(200) = NULL,
	@ServicePassword NVARCHAR(200) = NULL,
	@isProductionEnvironment BIT = 0,
	@CustomerId BIGINT =0,
	@statusId INT =1,
	@enteredBy NVARCHAR(50) = NULL,
	@dateEntered DATETIME2 = NULL
AS
BEGIN
IF NOT EXISTS( SELECT 1 FROM SYSTM000CustNAVConfiguration WHERE ServiceUrl=@ServiceUrl 
AND ServiceUserName=@ServiceUserName AND ServicePassword =@ServicePassword AND CustomerId= @CustomerId)
	BEGIN
	   INSERT INTO SYSTM000CustNAVConfiguration(ServiceUrl,ServiceUserName,ServicePassword,IsProductionEnvironment,CustomerId,EnteredBy,DateEntered,StatusId)
	   VALUES (@ServiceUrl,@ServiceUserName,@ServicePassword,@isProductionEnvironment,@CustomerId,@enteredBy,@dateEntered,@statusId)
	   SELECT 1
	END
	ELSE
	BEGIN
	  SELECT 0
	END
END

