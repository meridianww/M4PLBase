--vendor contact address

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'PACSTORG')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'PACSTORG')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'PACSTORG')))
WHERE VendCode = 'PACSTORG'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'RDMNMVST')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'RDMNMVST')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'RDMNMVST')))
WHERE VendCode = 'RDMNMVST'



update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ADVNTRLC')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ADVNTRLC')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ADVNTRLC')))
WHERE VendCode = 'ADVNTRLC'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ARVNLNS')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ARVNLNS')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ARVNLNS')))
WHERE VendCode = 'ARVNLNS'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ATWWLGS')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ATWWLGS')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ATWWLGS')))
WHERE VendCode = 'ATWWLGS'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ALBMVST')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ALBMVST')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ALBMVST')))
WHERE VendCode = 'ALBMVST'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ALRMVST')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ALRMVST')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ALRMVST')))
WHERE VendCode = 'ALRMVST'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'AMPMMVRS')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'AMPMMVRS')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'AMPMMVRS')))
WHERE VendCode = 'AMPMMVRS'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'AMJCMPBL')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'AMJCMPBL')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'AMJCMPBL')))
WHERE VendCode = 'AMJCMPBL'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ARMSTMVR')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ARMSTMVR')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ARMSTMVR')))
WHERE VendCode = 'ARMSTMVR'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ARWMVSY')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ARWMVSY')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ARWMVSY')))
WHERE VendCode = 'ARWMVSY'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BNDSRVCS')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BNDSRVCS')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BNDSRVCS')))
WHERE VendCode = 'BNDSRVCS'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BRLGSTCS')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BRLGSTCS')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BRLGSTCS')))
WHERE VendCode = 'BRLGSTCS'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BEAVX')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BEAVX')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BEAVX')))
WHERE VendCode = 'BEAVX'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BSTRNSRS')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BSTRNSRS')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BSTRNSRS')))
WHERE VendCode = 'BSTRNSRS'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BRSTCRTG')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BRSTCRTG')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BRSTCRTG')))
WHERE VendCode = 'BRSTCRTG'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'CBCMVNG')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'CBCMVNG')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'CBCMVNG')))
WHERE VendCode = 'CBCMVNG'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'CBCMVNPR')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'CBCMVNPR')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'CBCMVNPR')))
WHERE VendCode = 'CBCMVNPR'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'CNTWMVST')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'CNTWMVST')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'CNTWMVST')))
WHERE VendCode = 'CNTWMVST'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'DLTNLGST')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'DLTNLGST')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'DLTNLGST')))
WHERE VendCode = 'DLTNLGST'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ELSMVSTR')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ELSMVSTR')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'ELSMVSTR')))
WHERE VendCode = 'ELSMVSTR'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'FTSTRNSP')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'FTSTRNSP')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'FTSTRNSP')))
WHERE VendCode = 'FTSTRNSP'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'FRDMVNG')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'FRDMVNG')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'FRDMVNG')))
WHERE VendCode = 'FRDMVNG'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'GFFTHMS')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'GFFTHMS')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'GFFTHMS')))
WHERE VendCode = 'GFFTHMS'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'HVRTMVR')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'HVRTMVR')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'HVRTMVR')))
WHERE VendCode = 'HVRTMVR'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'INTREXDN')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'INTREXDN')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'INTREXDN')))
WHERE VendCode = 'INTREXDN'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'INTREXTL')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'INTREXTL')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'INTREXTL')))
WHERE VendCode = 'INTREXTL'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'LRCHMVNG')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'LRCHMVNG')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'LRCHMVNG')))
WHERE VendCode = 'LRCHMVNG'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'LNDTRNLG')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'LNDTRNLG')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'LNDTRNLG')))
WHERE VendCode = 'LNDTRNLG'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'LYKSCRTG')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'LYKSCRTG')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'LYKSCRTG')))
WHERE VendCode = 'LYKSCRTG'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'MCKMVSYS')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'MCKMVSYS')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'MCKMVSYS')))
WHERE VendCode = 'MCKMVSYS'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'NLYVNSTR')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'NLYVNSTR')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'NLYVNSTR')))
WHERE VendCode = 'NLYVNSTR'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'PNFMVSTR')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'PNFMVSTR')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'PNFMVSTR')))
WHERE VendCode = 'PNFMVSTR'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'TSPDEL')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'TSPDEL')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'TSPDEL')))
WHERE VendCode = 'TSPDEL'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'QHPMVSTR')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'QHPMVSTR')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'QHPMVSTR')))
WHERE VendCode = 'QHPMVSTR'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'SMDYWWD')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'SMDYWWD')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'SMDYWWD')))
WHERE VendCode = 'SMDYWWD'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'SHMHDLKS')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'SHMHDLKS')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'SHMHDLKS')))
WHERE VendCode = 'SHMHDLKS'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'SHMEHOMDEL')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'SHMEHOMDEL')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'SHMEHOMDEL')))
WHERE VendCode = 'SHMEHOMDEL'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'SRMVSTRG')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'SRMVSTRG')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'SRMVSTRG')))
WHERE VendCode = 'SRMVSTRG'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'THMVNGMN')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'THMVNGMN')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'THMVNGMN')))
WHERE VendCode = 'THMVNGMN'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'TPHTLGST')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'TPHTLGST')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'TPHTLGST')))
WHERE VendCode = 'TPHTLGST'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'TPHTLGWB')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'TPHTLGWB')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'TPHTLGWB')))
WHERE VendCode = 'TPHTLGWB'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'VLYRCLTN')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'VLYRCLTN')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'VLYRCLTN')))
WHERE VendCode = 'VLYRCLTN'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'WLKVNSTR')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'WLKVNSTR')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'WLKVNSTR')))
WHERE VendCode = 'WLKVNSTR'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'WLFHMOPR')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'WLFHMOPR')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'WLFHMOPR')))
WHERE VendCode = 'WLFHMOPR'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'FRDGMVST')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'FRDGMVST')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'FRDGMVST')))
WHERE VendCode = 'FRDGMVST'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'NWLTTD')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'NWLTTD')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'NWLTTD')))
WHERE VendCode = 'NWLTTD'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'TPHTLS')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'TPHTLS')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'TPHTLS')))
WHERE VendCode = 'TPHTLS'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'GLMVSTR')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'GLMVSTR')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'GLMVSTR')))
WHERE VendCode = 'GLMVSTR'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BSARMV')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BSARMV')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BSARMV')))
WHERE VendCode = 'BSARMV'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'INTREXP')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'INTREXP')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'INTREXP')))
WHERE VendCode = 'INTREXP'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'RDMNVNST')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'RDMNVNST')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'RDMNVNST')))
WHERE VendCode = 'RDMNVNST'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'INTEXMS')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'INTEXMS')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'INTEXMS')))
WHERE VendCode = 'INTEXMS'


update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'JETGRMV')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'JETGRMV')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'JETGRMV')))
WHERE VendCode = 'JETGRMV'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'AAAPCKNG')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'AAAPCKNG')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'AAAPCKNG')))
WHERE VendCode = 'AAAPCKNG'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BYNDSTR')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BYNDSTR')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'BYNDSTR')))
WHERE VendCode = 'BYNDSTR'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'REEDSHD')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'REEDSHD')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'REEDSHD')))
WHERE VendCode = 'REEDSHD'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'WATCA')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'WATCA')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'WATCA')))
WHERE VendCode = 'WATCA'

update [dbo].[VEND000Master] set
VendWorkAddressId = (SELECT TOP 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress in (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendWorkAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'OTAON')))
, VendBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendBusinessAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'OTAON')))
, VendCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
SELECT top 1 ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
SELECT TOP 1 VendCorporateAddressId FROM [M4PL_3030_Test].[dbo].[VEND000Master] WHERE VendOrgID = 1 AND VendCode = 'OTAON')))
WHERE VendCode = 'OTAON'

