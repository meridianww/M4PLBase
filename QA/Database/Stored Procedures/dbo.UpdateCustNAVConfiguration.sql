SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal      
-- Create date:               12/18/2020
-- Description:               Update/delete Customer Nav Configuration  
-- Execution:                
-- =============================================  
ALTER PROCEDURE UpdateCustNAVConfiguration
    @id BIGINT =0,
    @userId BIGINT = 0,
	@roleId BIGINT = 0,
	@orgId BIGINT = 0,
	@entity NVARCHAR(50) = NULL,
	@NAVConfigurationId BIGINT = 0,
	@ServiceUrl NVARCHAR(200) = NULL,
	@ServiceUserName NVARCHAR(200) = NULL,
	@ServicePassword NVARCHAR(200) = NULL,
	@CustomerId BIGINT =0,
	@statusId INT =1,
	@changedBy NVARCHAR(50) = NULL,
	@dateChanged DATETIME2 = NULL,
	@isFormView INT= 1
AS
BEGIN
   IF(@NAVConfigurationId >0)
   BEGIN
       IF(@statusId = 1)
	   BEGIN
		   UPDATE SYSTM000CustNAVConfiguration 
		   SET ServiceUrl = @ServiceUrl,
			   ServiceUserName = @ServiceUserName,
			   ServicePassword = @ServicePassword,
			   ChangedBy = @changedBy,
			   DateChanged = @dateChanged
			   WHERE NAVConfigurationId = @NAVConfigurationId
			   SELECT * FROM SYSTM000CustNAVConfiguration WHERE NAVConfigurationId = @NAVConfigurationId
		END
		ELSE
		BEGIN
		   UPDATE SYSTM000CustNAVConfiguration 
		   SET StatusId =3
			   WHERE NAVConfigurationId = @NAVConfigurationId
			SELECT 1
		END
   END
END