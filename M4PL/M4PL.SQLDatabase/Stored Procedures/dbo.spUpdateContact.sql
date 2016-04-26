-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateContact] 
	@ContactID		INT
	,@Title			NVARCHAR(5)
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
	
	UPDATE 
		dbo.CONTC000Master
	SET
		ConTitle		  = @Title 
		,ConFirstName	  = @FirstName 
		,ConMiddleName	  = @MiddleName 
		,ConLastName	  = @LastName
		,ConCompany		  = @Company
		,ConJobTitle	  = @JobTitle
		,ConAddress		  = @Address
		,ConCity		  = @City
		,ConStateProvince = @State
		,CountryRegion	  = @Country
		,ConZipPostal	  = @PostalCode
						  
		,ConBusinessPhone = @BusinessPhone
		,ConMobilePhone	  = @MobilePhone
		,ConEmailAddress  = @Email
		,ConHomePhone	  = @HomePhone
		,ConFaxNumber	  = @Fax
		,ConNotes		  = @Notes
		,ConFullName	  = (@Title + ' ' + @FirstName + ' ' + @LastName)
		,ConImage		  = @Image
	WHERE
		ContactID = @ContactID

END
