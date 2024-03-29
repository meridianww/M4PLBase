SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a cust DCLocation
-- Execution:                 EXEC [dbo].[GetCustDcLocation]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetCustDcLocation]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT cust.[Id]
      ,cust.[CdcCustomerID]
      ,cust.[CdcItemNumber]
      ,cust.[CdcLocationCode]
	  ,ISNULL(cust.[CdcCustomerCode],cust.[CdcLocationCode]) AS  CdcCustomerCode
      ,cust.[CdcLocationTitle]
      ,cust.[CdcContactMSTRID]
      ,cust.[StatusId]
      ,cust.[EnteredBy]
      ,cust.[DateEntered]
      ,cust.[ChangedBy]
      ,cust.[DateChanged] 
	  ,COMP.Id CompanyId
  FROM [dbo].[CUST040DCLocations] cust
  INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = cust.CdcCustomerID AND COMP.CompTableName = 'Customer'
 WHERE CUST.[Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH