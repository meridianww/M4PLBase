﻿


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

END