
INSERT INTO [dbo].[CONTC000Master]
           ([ConERPId]
           ,[ConTitleId]
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
           ,[ConBusinessStateId]
           ,[ConBusinessZipPostal]
           ,[ConBusinessCountryId]
           ,[ConHomeAddress1]
           ,[ConHomeAddress2]
           ,[ConHomeCity]
           ,[ConHomeStateId]
           ,[ConHomeZipPostal]
           ,[ConHomeCountryId]
           ,[ConAttachments]
           ,[ConWebPage]
           ,[ConNotes]
           ,[StatusId]
           ,[ConTypeId]
           ,[ConOutlookId]
           ,[ConUDF01]
           ,[ConUDF02]
           ,[ConUDF03]
           ,[ConUDF04]
           ,[ConUDF05]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy]
           ,[ConOrgId]
		   ,[3030Id])
     SELECT [ConERPId]
           ,[ConTitleId]
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
           ,[ConBusinessStateId]
           ,[ConBusinessZipPostal]
           ,[ConBusinessCountryId]
           ,[ConHomeAddress1]
           ,[ConHomeAddress2]
           ,[ConHomeCity]
           ,[ConHomeStateId]
           ,[ConHomeZipPostal]
           ,[ConHomeCountryId]
           ,[ConAttachments]
           ,[ConWebPage]
           ,[ConNotes]
           ,[StatusId]
           ,[ConTypeId]
           ,[ConOutlookId]
           ,[ConUDF01]
           ,[ConUDF02]
           ,[ConUDF03]
           ,[ConUDF04]
           ,[ConUDF05]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy] 
		   , 1 
		   ,CM.Id
		   From [M4PL_3030_Test].[dbo].[CONTC000Master] CM
		   where 
		   (CM.ConEmailAddress not like '%@mailinator.com%'
		   or CM.ConEmailAddress2 not like '%@mailinator.com%')
		   and (CM.ConEmailAddress not like '%@dreamorbit.com%'
		   or CM.ConEmailAddress2 not like '%@dreamorbit.com%')

GO



