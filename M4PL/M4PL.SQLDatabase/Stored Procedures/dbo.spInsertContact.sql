USE [M4PL]
GO

/****** Object: SqlProcedure [dbo].[spInsertContact] Script Date: 4/26/2016 12:47:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[spInsertContact] 
	 @Title			NVARCHAR(5)
	,@FirstName		NVARCHAR(25)
	,@MiddleName	NVARCHAR(25)
	,@LastName		NVARCHAR(25)
	,@Company		NVARCHAR(100)
	,@JobTitle		NVARCHAR(50)
	,@Address		NVARCHAR(255)
	,@City			NVARCHAR(25)
	,@State			NVARCHAR(25)
	,@Country		NVARCHAR(25)
	,@PostalCode	NVARCHAR(20)

	,@BusinessPhone NVARCHAR(25)
	,@MobilePhone	NVARCHAR(25)
	,@Email			NVARCHAR(100)
	,@HomePhone		NVARCHAR(25)
	,@Fax			NVARCHAR(25)
	,@Notes			NTEXT
	,@Image			VARBINARY(MAX)
AS
BEGIN
	
	INSERT INTO dbo.CONTC000Master
	(
		ConTitle
		,ConFirstName
		,ConMiddleName
		,ConLastName
		,ConCompany
		,ConJobTitle
		,ConAddress
		,ConCity
		,ConStateProvince 
		,CountryRegion
		,ConZipPostal

		,ConBusinessPhone
		,ConMobilePhone
		,ConEmailAddress
		,ConHomePhone
		,ConFaxNumber
		,ConNotes
		,ConFullName
		,ConImage
	)
	VALUES
	(
		@Title
		,@FirstName 
		,@MiddleName
		,@LastName
		,@Company
		,@JobTitle
		,@Address
		,@City
		,@State
		,@Country
		,@PostalCode

		,@BusinessPhone
		,@MobilePhone
		,@Email
		,@HomePhone
		,@Fax
		,@Notes
		,(@Title + ' ' + @FirstName + ' ' + @LastName)
		,@Image
	)

END
