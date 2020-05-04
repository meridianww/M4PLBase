SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program 
-- Execution:                 EXEC [dbo].[GetProgram]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================      
CREATE PROCEDURE  [dbo].[GetProgram]      
    @userId BIGINT,      
    @roleId BIGINT,      
    @orgId BIGINT,      
    @id BIGINT,
	@parentId BIGINT =NULL
AS      
BEGIN TRY                      
 SET NOCOUNT ON; 
 
  IF @id = 0
  BEGIN
    SELECT @id As Id
	       ,CAST(ISNULL((SELECT  PrgHierarchyLevel FROM PRGRM000Master WHERE Id = @parentId),0) + 1 AS smallint)  AS PrgHierarchyLevel
		   ,(SELECT  PrgProgramCode FROM PRGRM000Master WHERE Id = @parentId)   AS PrgProgramCode
		   ,(SELECT  PrgProjectCode FROM PRGRM000Master WHERE Id = @parentId)   AS PrgProjectCode
		   ,(SELECT  PrgCustID FROM PRGRM000Master WHERE Id = @parentId)   AS PrgCustID
		   ,@parentId   AS ParentId
		   ,CAST(1 AS BIT) AS DelDay
		   ,CAST(1 AS BIT) AS PckDay
           
  END
  ELSE 
  BEGIN
  DECLARE @PrgIsHavingPermission BIT = 1
		,@RoleType VARCHAR(100)
		,@IsSystemAdmin BIT = 0
		,@IsOrganizationEmplyee BIT = 0
		,@CompanyId INT
		,@UserContactId INT

	SELECT DISTINCT @IsSystemAdmin = CASE 
			WHEN ISNULL(SM.IsSysAdmin, 0) = 0
				THEN 0
			ELSE 1
			END
		,@IsOrganizationEmplyee = CASE 
			WHEN ISNULL(COMP.CompTableName, '') = 'Organization'
				THEN 1
			ELSE 0
			END
		,@CompanyId = COMP.Id
		,@RoleType = RO.SysOptionName
		,@UserContactId = SM.SysUserContactId
	FROM [dbo].[SYSTM000OpnSezMe] SM WITH (NOLOCK)
	LEFT JOIN CONTC010Bridge CB WITH (NOLOCK) ON SM.SysUserContactId = CB.ContactMSTRID
	INNER JOIN dbo.CONTC000Master CM WITH (NOLOCK) ON CM.Id = SM.SysUserContactID
	INNER JOIN dbo.COMP000Master COMP WITH (NOLOCK) ON COMP.Id = CM.ConCompanyId
	INNER JOIN dbo.ORGAN010Ref_Roles RR WITH (NOLOCK) ON RR.Id = SM.SysOrgRefRoleId
	LEFT JOIN dbo.SYSTM000Ref_Options RO WITH (NOLOCK) ON RO.Id = RR.RoleTypeId
	WHERE SM.Id = @userId
		AND COMP.CompOrgId = @orgId


		IF(@IsSystemAdmin = 0 AND @IsOrganizationEmplyee = 0 AND (@RoleType = 'Vendor' OR @RoleType = 'Driver'))
		BEGIN
		SELECT @PrgIsHavingPermission = CASE WHEN Count(ISNULL(PRC.Id, 0)) = 0 THEN 0 ELSE 1 END FROM dbo.PRGRM020Program_Role PRC 
		WHERE PRC.ProgramID = @id AND PRC.StatusId IN (1,2) AND PRC.PrgRoleContactID = @UserContactId
		
		SELECT @PrgIsHavingPermission = CASE WHEN @PrgIsHavingPermission = 1 THEN 1 
		WHEN Count(ISNULL(PGD.Id, 0)) > 0 THEN 1 
	    ELSE 0 END FROM dbo.PRGRM010Ref_GatewayDefaults PGD 
		WHERE PGD.PgdProgramID = @id AND PGD.StatusId IN (1,2) AND (PGD.PgdGatewayAnalyst = @UserContactId OR PGD.PgdGatewayResponsible = @UserContactId)
		
		SELECT @PrgIsHavingPermission = CASE WHEN @PrgIsHavingPermission = 1 THEN 1 
		WHEN Count(ISNULL(PVL.Id, 0)) > 0 THEN 1 
	    ELSE 0 END FROM dbo.PRGRM051VendorLocations PVL WHERE PVL.PvlProgramID = @id AND PVL.VendDCLocationId IN (
		SELECT VDL.Id FROM dbo.VEND040DCLocations VDL WHERE VDL.VdcVendorID IN (
		SELECT CB.ConPrimaryRecordId FROM dbo.CONTC010Bridge CB WHERE CB.ContactMSTRID = @UserContactId AND CB.ConTableName = 'VendContact'))
		
		SELECT @PrgIsHavingPermission = CASE WHEN @PrgIsHavingPermission = 1 THEN 1 
		WHEN Count(ISNULL(PVL.Id, 0)) > 0 THEN 1 
	    ELSE 0 END FROM dbo.PRGRM051VendorLocations PVL WHERE PVL.PvlProgramID = @id AND PVL.VendDCLocationId IN (
		SELECT CB.ConPrimaryRecordId FROM dbo.CONTC010Bridge CB WHERE CB.ContactMSTRID = @UserContactId AND CB.ConTableName = 'VendDcLocationContact'
		)
		END
  SELECT prg.[Id]      
  ,prg.[PrgOrgID]      
  ,prg.[PrgCustID]      
  ,prg.[PrgItemNumber]      
  ,prg.[PrgProgramCode]      
  ,prg.[PrgProjectCode]      
  ,prg.[PrgPhaseCode]      
  ,prg.[PrgProgramTitle]      
  ,prg.[PrgAccountCode] 
  ,prg.[DelEarliest] 
  ,prg.[DelLatest] 
  --,prg.[DelDay] 
   , CASE WHEN prg.[DelEarliest] IS NULL AND prg.[DelLatest] IS NULL  THEN CAST(1 AS BIT)
     ELSE  prg.[DelDay] END AS DelDay


  ,prg.[PckEarliest] 
  ,prg.[PckLatest] 
  , CASE WHEN prg.[PckEarliest] IS NULL AND prg.[PckLatest] IS NULL  THEN CAST(1 AS BIT)
     ELSE  prg.[PckDay] END AS PckDay
  ,prg.[StatusId]      
  ,prg.[PrgDateStart]      
  ,prg.[PrgDateEnd]      
  ,prg.[PrgDeliveryTimeDefault]      
  ,prg.[PrgPickUpTimeDefault]      
  ,prg.[PrgHierarchyID].ToString() As PrgHierarchyID       
  ,prg.[PrgHierarchyLevel] 
  ,prg.[PrgRollUpBilling]
  ,prg.[PrgRollUpBillingJobFieldId]    
  ,Col.[ColTableName] PrgRollUpBillingJobFieldIdName     
  ,prg.[PrgElectronicInvoice] 
  ,prg.[DateEntered]      
  ,prg.[EnteredBy]      
  ,prg.[DateChanged]      
  ,prg.[ChangedBy]
  ,@PrgIsHavingPermission AS PrgIsHavingPermission      
  FROM   [dbo].[PRGRM000Master] prg      
  LEFT JOIN SYSTM000ColumnsAlias Col ON Col.Id = prg.PrgRollUpBillingJobFieldId
 WHERE   prg.[Id] = @id   
 
  END   
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH

GO
