Declare @BusinessAddressType INT,@CorporateAddressType INT,@WorkAddressType INT
Select @BusinessAddressType = ID From [dbo].[SYSTM000Ref_Options] Where SysOptionName='Business'
Select @CorporateAddressType = ID From [dbo].[SYSTM000Ref_Options] Where SysOptionName='Corporate'
Select @WorkAddressType = ID From [dbo].[SYSTM000Ref_Options] Where SysOptionName='Work'

INSERT INTO [dbo].[COMPADD000Master]
           ([AddCompId]
           ,[AddItemNumber]
           ,[Address1]
           ,[Address2]
           ,[City]
           ,[StateId]
           ,[ZipPostal]
           ,[CountryId]
           ,[AddTypeId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
Select COMP.Id, 1 AddItemNumber, CC.ConBusinessAddress1 Address1, CC.ConBusinessAddress2 Address2,CC.ConBusinessCity City, ConBusinessStateId StateId,
ConBusinessZipPostal ZipPostal, ConBusinessCountryId CountryId, @CorporateAddressType AddTypeId,ISNULL(CC.DateEntered,GETUTCDATE()) DateEntered,ISNULL(CC.EnteredBy, '') EnteredBy,CC.DateChanged,CC.ChangedBy
From [dbo].[Vend000Master] CM
INNER JOIN dbo.[COMP000Master] COMP ON COMP.CompPrimaryRecordId = CM.Id AND CompTableName = 'Vendor'
LEFT JOIN [dbo].[CONTC000Master] CC ON CC.Id = CM.VendCorporateAddressId
Where CM.VendOrgId = 1
UNION
Select COMP.Id ,2 AddItemNumber, CC.ConBusinessAddress1 Address1, CC.ConBusinessAddress2 Address2,CC.ConBusinessCity City, ConBusinessStateId StateId,
ConBusinessZipPostal ZipPostal, ConBusinessCountryId CountryId, @BusinessAddressType AddTypeId,ISNULL(CC.DateEntered,GETUTCDATE()) DateEntered,ISNULL(CC.EnteredBy, '') EnteredBy,CC.DateChanged,CC.ChangedBy
From [dbo].[Vend000Master] CM
INNER JOIN dbo.[COMP000Master] COMP ON COMP.CompPrimaryRecordId = CM.Id AND CompTableName = 'Vendor'
LEFT JOIN [dbo].[CONTC000Master] CC ON CC.Id = CM.VendBusinessAddressId
Where CM.VendOrgId = 1
UNION
Select COMP.Id , 3 AddItemNumber, CC.ConBusinessAddress1 Address1, CC.ConBusinessAddress2 Address2,CC.ConBusinessCity City, ConBusinessStateId StateId,
ConBusinessZipPostal ZipPostal, ConBusinessCountryId CountryId, @WorkAddressType AddTypeId,ISNULL(CC.DateEntered,GETUTCDATE()) DateEntered,ISNULL(CC.EnteredBy, '') EnteredBy,CC.DateChanged,CC.ChangedBy
From [dbo].[Vend000Master] CM
INNER JOIN dbo.[COMP000Master] COMP ON COMP.CompPrimaryRecordId = CM.Id AND CompTableName = 'Vendor'
LEFT JOIN [dbo].[CONTC000Master] CC ON CC.Id = CM.VendWorkAddressId
Where CM.VendOrgId = 1