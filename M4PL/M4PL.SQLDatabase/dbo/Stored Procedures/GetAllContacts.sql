




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllContacts] 
	@ColUserId INT = 0
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @Query NVARCHAR(MAX) = '';
	SELECT @Query = ColOrderingQuery FROM [dbo].[SYSTM000ColumnsSorting&Ordering] (NOLOCK) WHERE ColPageName = 'Contact' AND ColUserId = @ColUserId;

	IF LEN(@Query) = 0
	BEGIN
		SELECT 
			[ContactID]                	
			,[ConERPID]                         
			,[ConCompany]                       
			,[ConTitle]                         
			,[ConLastName]                      
			,[ConFirstName]                     
			,[ConMiddleName]                    
			,[ConEmailAddress]                  
			,[ConEmailAddress2]                 
			--,[ConImage]                              
			,[ConJobTitle]              
			,[ConBusinessPhone]         
			,[ConBusinessPhoneExt]      
			,[ConHomePhone]             
			,[ConMobilePhone]           
			,[ConFaxNumber]             
			,[ConBusinessAddress1]      
			,[ConBusinessAddress2]      
			,[ConBusinessCity]          
			,[ConBusinessStateProvince] 
			,[ConBusinessZIPPostal]     
			,[ConBusinessCountryRegion] 
			,[ConHomeAddress1]          
			,[ConHomeAddress2]          
			,[ConHomeCity]              
			,[ConHomeStateProvince]     
			,[ConHomeZIPPostal]         
			,[ConHomeCountryRegion]     
			,[ConAttachments]           
			,[ConWebPage]               
			,[ConNotes]                 
			,[ConStatus]                
			,[ConType]                  
			,ISNULL([ConFullName], ([ConFirstName] + ' ' + [ConLastName])) AS [ConFullName]    
			,[ConFileAs]                      
			,[ConOutlookID]                   
			,[ConDateEntered]                 
			,[ConDateEnteredBy]               
			,[ConDateChanged]                 
			,[ConDateChangedBy]               
		FROM 
			DBO.CONTC000Master (NOLOCK)
		ORDER BY [ContactID] DESC
	END
	ELSE
	BEGIN
		PRINT(@Query);
		EXEC(@Query);
	END

END