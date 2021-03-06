SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:							Prashant Aggarwal        
-- Create date:						07/15/2019      
-- Description:						Get Company Corporate Address
-- Modified On:						07/23/2019
-- Modified By and description:		(Kirty)
-- =============================================
CREATE PROCEDURE [dbo].[GetCompanyCorporateAddress] 
@userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@id BIGINT
AS
BEGIN
	SET NOCOUNT ON;
SELECT COMP.[Id]
      ,COMP.[AddCompId]
      ,COMP.[AddItemNumber]
      ,COMP.[Address1]
      ,COMP.[Address2]
      ,COMP.[City]
      ,COMP.[StateId]
      ,COMP.[ZipPostal]
      ,COMP.[CountryId]
      ,COMP.[AddTypeId]
      ,COMP.[DateEntered]
      ,COMP.[EnteredBy]
      ,COMP.[DateChanged]
      ,COMP.[ChangedBy]
		,states.StateAbbr AS [StateIdName]
		,country.SysOptionName AS [CountryIdName]
  FROM [dbo].[COMPADD000Master] COMP
  INNER JOIN [dbo].[SYSTM000Ref_Options] RO ON RO.Id = COMP.AddTypeId
	LEFT JOIN [dbo].[SYSTM000Ref_Options] country ON COMP.[CountryId] = country.Id
	LEFT JOIN [dbo].[SYSTM000Ref_States] states ON COMP.[StateId] = states.Id
  Where [AddCompId]=@id AND RO.SysLookupCode = 'AddressType' AND RO.SysOptionName='Corporate'
END
GO
