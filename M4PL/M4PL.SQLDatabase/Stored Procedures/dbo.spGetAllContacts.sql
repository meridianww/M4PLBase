
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetAllContacts] 
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT 					       
		 [ContactID]           AS [ContactID]              
		,[ConCompany]          AS [Company]          
		,[ConLastName]         AS [LastName]         
		,[ConFirstName]        AS [FirstName]        
		,[ConMiddleName]       AS [MiddleName]       
		,[ConEmailAddress]     AS [Email]     
		,[ConEmailAddress2]    AS [Email2]    
		,[ConJobTitle]         AS [JobTitle]         
		,[ConBusinessPhone]    AS [BusinessPhone]    
		,[ConBusinessPhoneExt] AS [BusinessPhoneExt] 
		,[ConHomePhone]        AS [HomePhone]        
		,[ConMobilePhone]      AS [MobilePhone]      
		,[ConFaxNumber]        AS [FaxNumber]        
		,[ConAddress]          AS [Address]          
		,[ConCity]             AS [City]             
		,[ConStateProvince]    AS [StateProvince]    
		,[ConZIPPostal]        AS [PostalCode]        
		,[CountryRegion]       AS [Country]        
		,[ConNotes]            AS [Notes]            
		,[ConStatus]           AS [Status]           
		,[ConType]             AS [Type]             
		,ISNULL([ConFullName], ([ConFirstName] + ' ' + [ConLastName]))         AS [FullName]    
		,[ConDateEntered]      AS [DateEntered]      
		,[ConDateEnteredBy]    AS [DateEnteredBy]    
		,[ConDateChanged]      AS [DateChanged]      
		,[ConDateChangedBy]    AS [DateChangedBy]   
	FROM 
		DBO.CONTC000Master (NOLOCK)
	ORDER BY [ContactID] DESC

END