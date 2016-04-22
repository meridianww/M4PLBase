
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetContactDetails] 
	@ContactID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT 					       
		 [ContactID]			AS [ContactID]              
		,[ConCompany]			AS [Company]          
		,ISNULL([ConTitle], 'Mr.')	AS [Title]          
		,[ConLastName]			AS [LastName]         
		,[ConFirstName]			AS [FirstName]        
		,[ConMiddleName]		AS [MiddleName]       
		,[ConEmailAddress]		AS [Email]     
		,[ConEmailAddress2]		AS [Email2]    
		,[ConJobTitle]			AS [JobTitle]         
		,[ConBusinessPhone]		AS [BusinessPhone]    
		,[ConBusinessPhoneExt]	AS [BusinessPhoneExt] 
		,[ConHomePhone]			AS [HomePhone]        
		,[ConMobilePhone]		AS [MobilePhone]      
		,[ConFaxNumber]			AS [Fax]        
		,[ConAddress]			AS [Address]          
		,[ConCity]				AS [City]             
		,[ConStateProvince]		AS [State]    
		,[ConZIPPostal]			AS [PostalCode]        
		,[CountryRegion]		AS [Country]        
		,[ConNotes]				AS [Notes]            
		,[ConStatus]			AS [Status]           
		,[ConType]				AS [Type]             
		,[ConFullName]			AS [FullName]    
		,[ConDateEntered]		AS [DateEntered]      
		,[ConDateEnteredBy]		AS [DateEnteredBy]    
		,[ConDateChanged]		AS [DateChanged]      
		,[ConDateChangedBy]		AS [DateChangedBy]
		,[ConImage]				AS [Image]
	FROM 
		DBO.CONTC000Master (NOLOCK) 
	WHERE 
		ContactID = @ContactID

END