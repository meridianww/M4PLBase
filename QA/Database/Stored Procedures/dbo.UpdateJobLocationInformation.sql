SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Kirty Anurag           
-- Create date:               09/08/2020        
-- Description:               Update Job Location Information        
-- =============================================        
CREATE PROCEDURE [dbo].[UpdateJobLocationInformation] (
	 @userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@jobOriginSiteName NVARCHAR(50) = NULL
	,@jobOriginSitePOC NVARCHAR(75) = NULL
	,@jobOriginSitePOCPhone NVARCHAR(50) = NULL
	,@jobOriginSitePOCEmail NVARCHAR(50) = NULL
	,@jobOriginStreetAddress NVARCHAR(100) = NULL
	,@jobOriginStreetAddress2 NVARCHAR(100) = NULL
	,@JobOriginStreetAddress3 NVARCHAR(100)
	,@JobOriginStreetAddress4 NVARCHAR(100)
	,@jobOriginCity NVARCHAR(50) = NULL
	,@jobOriginState NVARCHAR(50) = NULL
	,@jobOriginCountry NVARCHAR(50) = NULL
	,@jobOriginPostalCode NVARCHAR(50) = NULL
	,@jobDeliverySiteName NVARCHAR(50) = NULL
	,@jobDeliverySitePOC NVARCHAR(75) = NULL
	,@jobDeliverySitePOCPhone NVARCHAR(50) = NULL
	,@jobDeliverySitePOCEmail NVARCHAR(50) = NULL
	,@jobDeliveryStreetAddress NVARCHAR(100) = NULL
	,@jobDeliveryStreetAddress2 NVARCHAR(100) = NULL
	,@JobDeliveryStreetAddress3 NVARCHAR(100)
	,@JobDeliveryStreetAddress4 NVARCHAR(100)
	,@jobDeliveryCity NVARCHAR(50) = NULL
	,@jobDeliveryState NVARCHAR(50) = NULL
	,@jobDeliveryCountry NVARCHAR(50) = NULL
	,@jobDeliveryPostalCode NVARCHAR(50) = NULL
	,@jobDeliverySitePOC2 NVARCHAR(75) = NULL
	,@jobDeliverySitePOCPhone2 NVARCHAR(50) = NULL
	,@jobDeliverySitePOCEmail2 NVARCHAR(50) = NULL
	,@jobOriginSitePOC2 NVARCHAR(75) = NULL
	,@jobOriginSitePOCPhone2 NVARCHAR(50) = NULL
	,@jobOriginSitePOCEmail2 NVARCHAR(50) = NULL
	,@JobPreferredMethod INT
	,@IsJobVocSurvey BIT = 0
	,@jobSellerCode NVARCHAR(20) = NULL
	,@jobSellerSitePOC NVARCHAR(75) = NULL
	,@jobSellerSitePOCPhone NVARCHAR(50) = NULL
	,@jobSellerSitePOCEmail NVARCHAR(50) = NULL
	,@jobSellerSitePOC2 NVARCHAR(75) = NULL
	,@jobSellerSitePOCPhone2 NVARCHAR(50) = NULL
	,@jobSellerSitePOCEmail2 NVARCHAR(50) = NULL
	,@jobSellerSiteName NVARCHAR(50) = NULL
	,@jobSellerStreetAddress NVARCHAR(100) = NULL
	,@jobSellerStreetAddress2 NVARCHAR(100) = NULL
	,@jobSellerCity NVARCHAR(50) = NULL
	,@jobSellerState NVARCHAR(50) = NULL
	,@jobSellerPostalCode NVARCHAR(50) = NULL
	,@jobSellerCountry NVARCHAR(50) = NULL
	,@JobShipFromSiteName NVARCHAR(50)
	,@JobShipFromStreetAddress NVARCHAR(100)
	,@JobShipFromStreetAddress2 NVARCHAR(100)
	,@JobShipFromCity NVARCHAR(50)
	,@JobShipFromState NVARCHAR(50)
	,@JobShipFromPostalCode NVARCHAR(50)
	,@JobShipFromCountry NVARCHAR(50)
	,@JobShipFromSitePOC NVARCHAR(75)
	,@JobShipFromSitePOCPhone NVARCHAR(50)
	,@JobShipFromSitePOCEmail NVARCHAR(50)
	,@JobShipFromSitePOC2 NVARCHAR(75)
	,@JobShipFromSitePOCPhone2 NVARCHAR(50)
	,@JobShipFromSitePOCEmail2 NVARCHAR(50)
	,@JobSellerStreetAddress3 NVARCHAR(100)
	,@JobSellerStreetAddress4 NVARCHAR(100)
	,@JobShipFromStreetAddress3 NVARCHAR(100)
	,@JobShipFromStreetAddress4 NVARCHAR(100)
	,@jobLatitude NVARCHAR(50) = NULL
	,@jobLongitude NVARCHAR(50) = NULL
	,@JobMileage DECIMAL(18, 2)
	,@IsSellerTabEdited BIT = NULL
	,@IsPODTabEdited BIT = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@isFormView BIT = 0
	,@jobSignText NVARCHAR(75) = NULL
	,@jobSignLatitude NVARCHAR(50) = NULL
	,@jobSignLongitude NVARCHAR(50) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;


	SET @IsSellerTabEdited = ISNULL(@IsSellerTabEdited,0)
	SET @IsPODTabEdited = ISNULL(@IsPODTabEdited,0)

	UPDATE [dbo].[JOBDL000Master]
	SET [JobPreferredMethod] = CASE 
			WHEN (@isFormView = 1)
				THEN @JobPreferredMethod
			ELSE ISNULL(@JobPreferredMethod, [JobPreferredMethod])
			END
		,[JobDeliverySitePOC] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySitePOC
			ELSE ISNULL(@jobDeliverySitePOC, JobDeliverySitePOC)
			END
		,[JobDeliverySitePOCPhone] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySitePOCPhone
			ELSE ISNULL(@jobDeliverySitePOCPhone, JobDeliverySitePOCPhone)
			END
		,[JobDeliverySitePOCEmail] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySitePOCEmail
			ELSE ISNULL(@jobDeliverySitePOCEmail, JobDeliverySitePOCEmail)
			END
		,[JobDeliverySiteName] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySiteName
			ELSE ISNULL(@jobDeliverySiteName, JobDeliverySiteName)
			END
		,[JobDeliveryStreetAddress] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryStreetAddress
			ELSE ISNULL(@jobDeliveryStreetAddress, JobDeliveryStreetAddress)
			END
		,[JobDeliveryStreetAddress2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryStreetAddress2
			ELSE ISNULL(@jobDeliveryStreetAddress2, JobDeliveryStreetAddress2)
			END
		,[JobDeliveryCity] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryCity
			ELSE ISNULL(@jobDeliveryCity, JobDeliveryCity)
			END
		,[JobDeliveryState] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryState
			ELSE ISNULL(@jobDeliveryState, JobDeliveryState)
			END
		,[JobDeliveryPostalCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryPostalCode
			ELSE ISNULL(@jobDeliveryPostalCode, JobDeliveryPostalCode)
			END
		,[JobDeliveryCountry] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliveryCountry
			ELSE ISNULL(@jobDeliveryCountry, JobDeliveryCountry)
			END
		,[JobLatitude] = CASE 
			WHEN (@isFormView = 1)
				THEN ISNULL(@jobLatitude, JobLatitude)
			ELSE ISNULL(@jobLatitude, JobLatitude)
			END
		,[JobLongitude] = CASE 
			WHEN (@isFormView = 1)
				THEN ISNULL(@jobLongitude, JobLongitude)
			ELSE ISNULL(@jobLongitude, JobLongitude)
			END
		,[JobOriginSitePOC] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSitePOC
			ELSE ISNULL(@jobOriginSitePOC, JobOriginSitePOC)
			END
		,[JobOriginSitePOCPhone] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSitePOCPhone
			ELSE ISNULL(@jobOriginSitePOCPhone, JobOriginSitePOCPhone)
			END
		,[JobOriginSitePOCEmail] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSitePOCEmail
			ELSE ISNULL(@jobOriginSitePOCEmail, JobOriginSitePOCEmail)
			END
		,[JobOriginSiteName] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSiteName
			ELSE ISNULL(@jobOriginSiteName, JobOriginSiteName)
			END
		,[JobOriginStreetAddress] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginStreetAddress
			ELSE ISNULL(@jobOriginStreetAddress, JobOriginStreetAddress)
			END
		,[JobOriginStreetAddress2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginStreetAddress2
			ELSE ISNULL(@jobOriginStreetAddress2, JobOriginStreetAddress2)
			END
		,[JobOriginCity] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginCity
			ELSE ISNULL(@jobOriginCity, JobOriginCity)
			END
		,[JobOriginState] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginState
			ELSE ISNULL(@jobOriginState, JobOriginState)
			END
		,[JobOriginPostalCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginPostalCode
			ELSE ISNULL(@jobOriginPostalCode, JobOriginPostalCode)
			END
		,[JobOriginCountry] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginCountry
			ELSE ISNULL(@jobOriginCountry, JobOriginCountry)
			END
		,[JobDeliverySitePOC2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySitePOC2
			ELSE ISNULL(@jobDeliverySitePOC2, JobDeliverySitePOC2)
			END
		,[JobDeliverySitePOCPhone2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySitePOCPhone2
			ELSE ISNULL(@jobDeliverySitePOCPhone2, JobDeliverySitePOCPhone2)
			END
		,[JobDeliverySitePOCEmail2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobDeliverySitePOCEmail2
			ELSE ISNULL(@jobDeliverySitePOCEmail2, JobDeliverySitePOCEmail2)
			END
		,[JobOriginSitePOC2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSitePOC2
			ELSE ISNULL(@jobOriginSitePOC2, JobOriginSitePOC2)
			END
		,[JobOriginSitePOCPhone2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSitePOCPhone2
			ELSE ISNULL(@jobOriginSitePOCPhone2, JobOriginSitePOCPhone2)
			END
		,[JobOriginSitePOCEmail2] = CASE 
			WHEN (@isFormView = 1)
				THEN @jobOriginSitePOCEmail2
			ELSE ISNULL(@jobOriginSitePOCEmail2, JobOriginSitePOCEmail2)
			END
		,[JobSellerCode] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerCode
			ELSE ISNULL(@jobSellerCode, JobSellerCode)
			END
		,[JobSellerSitePOC] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSitePOC
			ELSE ISNULL(@jobSellerSitePOC, JobSellerSitePOC)
			END
		,[JobSellerSitePOCPhone] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSitePOCPhone
			ELSE ISNULL(@jobSellerSitePOCPhone, JobSellerSitePOCPhone)
			END
		,[JobSellerSitePOCEmail] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSitePOCEmail
			ELSE ISNULL(@jobSellerSitePOCEmail, JobSellerSitePOCEmail)
			END
		,[JobSellerSitePOC2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSitePOC2
			ELSE ISNULL(@jobSellerSitePOC2, JobSellerSitePOC2)
			END
		,[JobSellerSitePOCPhone2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSitePOCPhone2
			ELSE ISNULL(@jobSellerSitePOCPhone2, JobSellerSitePOCPhone2)
			END
		,[JobSellerSitePOCEmail2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSitePOCEmail2
			ELSE ISNULL(@jobSellerSitePOCEmail2, JobSellerSitePOCEmail2)
			END
		,[JobSellerSiteName] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerSiteName
			ELSE ISNULL(@jobSellerSiteName, JobSellerSiteName)
			END
		,[JobSellerStreetAddress] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerStreetAddress
			ELSE ISNULL(@jobSellerStreetAddress, JobSellerStreetAddress)
			END
		,[JobSellerStreetAddress2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerStreetAddress2
			ELSE ISNULL(@jobSellerStreetAddress2, JobSellerStreetAddress2)
			END
		,[JobSellerCity] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerCity
			ELSE ISNULL(@jobSellerCity, JobSellerCity)
			END
		,[JobSellerState] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerState
			ELSE ISNULL(@jobSellerState, JobSellerState)
			END
		,[JobSellerPostalCode] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerPostalCode
			ELSE ISNULL(@jobSellerPostalCode, JobSellerPostalCode)
			END
		,[JobSellerCountry] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @jobSellerCountry
			ELSE ISNULL(@jobSellerCountry, JobSellerCountry)
			END
		,[JobSignText] = CASE 
			WHEN (@isFormView = 1 AND @IsPODTabEdited = 1)
				THEN @jobSignText
			ELSE ISNULL(@jobSignText, JobSignText)
			END
		,[JobSignLatitude] = CASE 
			WHEN (@isFormView = 1 AND @IsPODTabEdited = 1)
				THEN @jobSignLatitude
			ELSE ISNULL(@jobSignLatitude, JobSignLatitude)
			END
		,[JobSignLongitude] = CASE 
			WHEN (@isFormView = 1 AND @IsPODTabEdited = 1)
				THEN @jobSignLongitude
			ELSE ISNULL(@jobSignLongitude, JobSIgnLongitude)
			END
		,JobShipFromSiteName = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSiteName
			ELSE ISNULL(@JobShipFromSiteName, JobShipFromSiteName)
			END
		,JobShipFromStreetAddress = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromStreetAddress
			ELSE ISNULL(@JobShipFromStreetAddress, JobShipFromStreetAddress)
			END
		,JobShipFromStreetAddress2 = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromStreetAddress2
			WHEN (
					(@isFormView = 0)
					AND (@JobShipFromStreetAddress2 = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@JobShipFromStreetAddress2, JobShipFromStreetAddress2)
			END
		,[JobShipFromCity] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromCity
			ELSE ISNULL(@JobShipFromCity, JobShipFromCity)
			END
		,[JobShipFromState] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromState
			ELSE ISNULL(@JobShipFromState, JobShipFromState)
			END
		,[JobShipFromPostalCode] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromPostalCode
			ELSE ISNULL(@JobShipFromPostalCode, JobShipFromPostalCode)
			END
		,[JobShipFromCountry] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromCountry
			ELSE ISNULL(@JobShipFromCountry, JobShipFromCountry)
			END
		,[JobShipFromSitePOC] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSitePOC
			ELSE ISNULL(@JobShipFromSitePOC, JobShipFromSitePOC)
			END
		,[JobShipFromSitePOCPhone] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSitePOCPhone
			ELSE ISNULL(@JobShipFromSitePOCPhone, JobShipFromSitePOCPhone)
			END
		,[JobShipFromSitePOCEmail] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSitePOCEmail
			ELSE ISNULL(@JobShipFromSitePOCEmail, JobShipFromSitePOCEmail)
			END
		,[JobShipFromSitePOC2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSitePOC2
			ELSE ISNULL(@JobShipFromSitePOC2, JobShipFromSitePOC2)
			END
		,[JobShipFromSitePOCPhone2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSitePOCPhone2
			ELSE ISNULL(@JobShipFromSitePOCPhone2, JobShipFromSitePOCPhone2)
			END
		,[JobShipFromSitePOCEmail2] = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromSitePOCEmail2
			ELSE ISNULL(@JobShipFromSitePOCEmail2, JobShipFromSitePOCEmail2)
			END
		,JobOriginStreetAddress3 = CASE 
			WHEN (@isFormView = 1)
				THEN @JobOriginStreetAddress3
			ELSE ISNULL(@JobOriginStreetAddress3, JobOriginStreetAddress3)
			END
		,JobOriginStreetAddress4 = CASE 
			WHEN (@isFormView = 1)
				THEN @JobOriginStreetAddress4
			ELSE ISNULL(@JobOriginStreetAddress4, JobOriginStreetAddress4)
			END
		,JobDeliveryStreetAddress3 = CASE 
			WHEN (@isFormView = 1)
				THEN @JobDeliveryStreetAddress3
			ELSE ISNULL(@JobDeliveryStreetAddress3, JobDeliveryStreetAddress3)
			END
		,JobDeliveryStreetAddress4 = CASE 
			WHEN (@isFormView = 1)
				THEN @JobDeliveryStreetAddress4
			ELSE ISNULL(@JobDeliveryStreetAddress4, JobDeliveryStreetAddress4)
			END
		,JobSellerStreetAddress3 = CASE 
			WHEN (@isFormView = 1)
				THEN @JobSellerStreetAddress3
			ELSE ISNULL(@JobSellerStreetAddress3, JobSellerStreetAddress3)
			END
		,JobSellerStreetAddress4 = CASE 
			WHEN (@isFormView = 1)
				THEN @JobSellerStreetAddress4
			ELSE ISNULL(@JobSellerStreetAddress4, JobSellerStreetAddress4)
			END
		,JobShipFromStreetAddress3 = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromStreetAddress3
			ELSE ISNULL(@JobShipFromStreetAddress3, JobShipFromStreetAddress3)
			END
		,JobShipFromStreetAddress4 = CASE 
			WHEN (@isFormView = 1 AND @IsSellerTabEdited = 1)
				THEN @JobShipFromStreetAddress4
			ELSE ISNULL(@JobShipFromStreetAddress4, JobShipFromStreetAddress4)
			END
		,[ChangedBy] = @changedBy
		,[DateChanged] = @dateChanged
		,[JobMileage] = CASE 
			WHEN (@isFormView = 1)
				THEN ISNULL(@JobMileage, JobMileage)
			WHEN (
					(@isFormView = 0)
					AND (@JobMileage = - 100)
					)
				THEN 0
			ELSE ISNULL(@JobMileage, JobMileage)
			END
		,[IsJobVocSurvey] =  @IsJobVocSurvey
	WHERE [Id] = @id;

END 
GO