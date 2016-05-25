


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetContactDetails] 
	@ContactID INT
AS
BEGIN TRY
	
	SET NOCOUNT ON;
	SELECT
		[ContactID]                	
		,[ConERPID]                           
		,[ConCompany]                         
		,ISNULL([ConTitle], 'Mr.')  AS [ConTitle]                
		,[ConLastName]              
		,[ConFirstName]             
		,[ConMiddleName]            
		,[ConEmailAddress]          
		,[ConEmailAddress2]         
		,[ConImage]                 
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
	WHERE 
		ContactID = @ContactID

END TRY
BEGIN CATCH

	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity

END CATCH