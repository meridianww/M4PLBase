SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwDCLocationContactMapping]
AS
	SELECT 
		   br.Id 
		  ,br.[ContactMSTRID]
		  ,br.[ConTableName]
		  ,br.[ConOrgId]
		  ,br.[ConPrimaryRecordId]
		  ,br.[ConItemNumber]
		  ,br.[ConTitle]
		  ,br.[ConCodeId]
		  ,br.[ConTypeId]
		  ,br.[StatusId]
		  ,br.[ConIsDefault]
		  ,br.[ConDescription]
		  ,br.[ConInstruction]
		  ,br.[ConTableTypeId]
		  ,br.[EnteredBy]
		  ,br.[DateEntered]
		  ,br.[ChangedBy]
		  ,br.[DateChanged]
		  ,con.Id ContactMasterID
		  ,con.[ConERPId] 
		  ,con.[ConCompanyId]
		  ,con.[ConCompanyName] 
		  ,con.[ConLastName]
		  ,con.[ConFirstName]
		  ,con.[ConMiddleName]
		  ,con.[ConEmailAddress]
		  ,con.[ConEmailAddress2]
		  ,con.[ConJobTitle]
		  ,con.[ConBusinessPhone]
		  ,con.[ConBusinessPhoneExt]
		  ,con.[ConHomePhone]
		  ,con.[ConMobilePhone]
		  ,con.[ConFaxNumber]
		  ,con.[ConBusinessAddress1]
		  ,con.[ConBusinessAddress2]
		  ,con.[ConBusinessCity]
		  ,con.[ConBusinessStateId]
		  ,con.[ConBusinessZipPostal]
		  ,con.[ConBusinessCountryId]
		  ,con.[ConHomeAddress1]
		  ,con.[ConHomeAddress2]
		  ,con.[ConHomeCity]
		  ,con.[ConHomeStateId]
		  ,con.[ConHomeZipPostal]
		  ,con.[ConHomeCountryId]
		  ,con.[ConAttachments]
		  ,con.[ConWebPage]
		  ,con.[ConNotes] 
		  ,con.[ConOutlookId]
		  ,con.[ConUDF01]
		  ,con.[ConUDF02]
		  ,con.[ConUDF03]
		  ,con.[ConUDF04]
		  ,con.[ConUDF05]  
		  ,Con.ConTitleId 
		  ,Con.ConFullName
		  FROM CONTC000Master con WITH(NOLOCK) 
		  INNER JOIN CONTC010Bridge br WITH(NOLOCK) ON con.Id= br.ContactMSTRID AND br.StatusId=1
GO
