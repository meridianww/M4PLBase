

		   UPDATE [dbo].[CUST000Master] SET 
		   CustWorkAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
		   SELECT ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
		   SELECT CustWorkAddressId FROM [M4PL_3030_Test].[dbo].[CUST000Master] WHERE CustCode = 'AWC' and CustOrgId = 1)
		   )),

		   CustBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
		   SELECT ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
		   SELECT CustBusinessAddressId FROM [M4PL_3030_Test].[dbo].[CUST000Master] WHERE CustCode = 'AWC' and CustOrgId = 1)
		   )),

		   CustCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
		   SELECT ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
		   SELECT CustCorporateAddressId FROM [M4PL_3030_Test].[dbo].[CUST000Master] WHERE CustCode = 'AWC' and CustOrgId = 1)
		   ))
		   WHERE CustCode = 'AWC'
		   GO

		   UPDATE [dbo].[CUST000Master] SET 
		   CustWorkAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
		   SELECT ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
		   SELECT CustWorkAddressId FROM [M4PL_3030_Test].[dbo].[CUST000Master] WHERE CustCode = 'MBC' and CustOrgId = 1)
		   )),

		   CustBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
		   SELECT ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
		   SELECT CustBusinessAddressId FROM [M4PL_3030_Test].[dbo].[CUST000Master] WHERE CustCode = 'MBC' and CustOrgId = 1)
		   )),

		   CustCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
		   SELECT ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
		   SELECT CustCorporateAddressId FROM [M4PL_3030_Test].[dbo].[CUST000Master] WHERE CustCode = 'MBC' and CustOrgId = 1)
		   ))
		   WHERE CustCode = 'MBC'
		   GO


		   UPDATE [dbo].[CUST000Master] SET 
		   CustWorkAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
		   SELECT ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
		   SELECT CustWorkAddressId FROM [M4PL_3030_Test].[dbo].[CUST000Master] WHERE CustCode = 'DEKR1706' and CustOrgId = 1)
		   )),

		   CustBusinessAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
		   SELECT ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
		   SELECT CustBusinessAddressId FROM [M4PL_3030_Test].[dbo].[CUST000Master] WHERE CustCode = 'DEKR1706' and CustOrgId = 1)
		   )),

		   CustCorporateAddressId = (SELECT top 1 ID FROM [dbo].[CONTC000Master] WHERE ConEmailAddress IN (
		   SELECT ConEmailAddress FROM [M4PL_3030_Test].[dbo].[CONTC000Master] WHERE ID IN (
		   SELECT CustCorporateAddressId FROM [M4PL_3030_Test].[dbo].[CUST000Master] WHERE CustCode = 'DEKR1706' and CustOrgId = 1)
		   ))
		   WHERE CustCode = 'DEKR1706'
