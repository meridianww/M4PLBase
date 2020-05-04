update[dbo].[SYSTM030Ref_TabPageName]
set TabPageTitle = 'Map' 
WHERE LangCode='EN' AND RefTableName = 'JobDelivery' AND (ISNULL(StatusId, 1) = 1) and TabPageTitle ='Map Route'