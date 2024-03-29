SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal       
-- Create date:               09/17/2019      
-- Description:               Get user securities 
-- Execution:                 EXEC [dbo].[IsJobPermissionPresentForUser] 20019,1,154506
-- =============================================   
ALTER PROCEDURE [dbo].[IsJobPermissionPresentForUser] (
	@userId BIGINT
	,@orgId BIGINT
	,@jobId BIGINT = 0
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @IsUserHavePermission BIT
	DECLARE @IsSystemAdmin BIT = 0
		,@IsOrganizationEmplyee BIT = 0
		,@RoleType VARCHAR(100)
		,@UserContactId BIGINT

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
		,@RoleType = RO.SysOptionName
		,@UserContactId = SM.SysUserContactId
	FROM [dbo].[SYSTM000OpnSezMe] SM WITH (NOLOCK)
	LEFT JOIN CONTC010Bridge CB WITH (NOLOCK) ON SM.SysUserContactId = CB.ContactMSTRID
	INNER JOIN dbo.CONTC000Master CM WITH (NOLOCK) ON CM.Id = SM.SysUserContactID
	INNER JOIN dbo.COMP000Master COMP WITH (NOLOCK) ON COMP.Id = CM.ConCompanyId
	INNER JOIN dbo.ORGAN010Ref_Roles RR WITH (NOLOCK) ON RR.Id = SM.SysOrgRefRoleId
	LEFT JOIN dbo.SYSTM000Ref_Options RO WITH (NOLOCK) ON RO.Id = RR.RoleTypeId
	LEFT JOIN dbo.PRGRM020Program_Role PPR WITH (NOLOCK) ON PPR.PrgRoleId = RR.RoleTypeId
		AND PPR.PrgRoleContactID = @UserContactId
		AND PPR.StatusId = 1
	WHERE SM.Id = @userId
		AND COMP.CompOrgId = @orgId

	SET @IsUserHavePermission = CASE 
			WHEN (
					ISNULL(@IsSystemAdmin, 0) = 1
					OR ISNULL(@IsOrganizationEmplyee, 0) = 1
					)
				THEN 1
			ELSE 0
			END
  
	IF (ISNULL(@IsUserHavePermission, 0) <> 1)
	BEGIN
			IF (@RoleType = 'Customer')
			BEGIN
			    IF EXISTS(SELECT 1 FROM CONTC010Bridge WHERE ConTableName = 'CustContact' AND StatusId =1 AND ContactMSTRID = @UserContactId)
			    BEGIN
					SELECT @IsUserHavePermission = CASE WHEN ISNULL(Job.ID, 0) > 0 THEN 1 ELSE 0 END 
					FROM dbo.COMP000Master COMP 
					INNER JOIN  dbo.CUST000Master CUST ON CUST.Id = COMP.CompPrimaryRecordId AND COMP.CompTableName = 'Customer'
					INNER JOIN dbo.PRGRM000Master Prg ON CUST.Id = Prg.PrgCustID 
					INNER JOIN dbo.JOBDL000Master Job ON Prg.Id = Job.ProgramID
					INNER JOIN dbo.CONTC010Bridge CB ON CUST.Id = CB.ConPrimaryRecordId AND CB.ConTableName = 'CustContact' 
					AND CB.StatusId = 1 AND CB.ContactMSTRID = @UserContactId
					Where Job.Id = @jobId
			   END
			   ELSE IF EXISTS(SELECT 1 FROM PRGRM020Program_Role WHERE PrgRoleContactID = @UserContactId AND StatusId =1)
				 BEGIN
					SELECT @IsUserHavePermission = CASE WHEN ISNULL(Job.ID, 0) > 0 THEN 1 ELSE 0 END 
					FROM dbo.PRGRM000Master Prg 
					INNER JOIN PRGRM020Program_Role PPR ON PPR.ProgramID = Prg.Id AND PPR.StatusId=1 AND PPR.PrgRoleContactID = @UserContactId 
					INNER JOIN dbo.JOBDL000Master Job ON Prg.Id = Job.ProgramID 
					Where Job.Id = @jobId			
				 END
			END
			IF (@RoleType = 'Vendor' OR @RoleType = 'Driver')
			BEGIN
				     SELECT @IsUserHavePermission = CASE WHEN ISNULL(Job.ID, 0) > 0 THEN 1 ELSE 0 END  FROM JOBDL000Master JOB
					 INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = JOB.ProgramID
					 AND PVL.PvlLocationCode = JOB.JobSiteCode AND PVL.StatusId IN (1, 2)
					 AND PVL.PvlLocationCode = JOB.JobSiteCode
					 AND ISNULL(JOB.JobSiteCode,'') <> ''
					 --AND JOB.StatusId IN (1, 2)  
					 INNER JOIN CONTC010Bridge CBR ON (CBR.ConPrimaryRecordId = PVL.VendDCLocationId
					 OR CBR.ConPrimaryRecordId = PVL.PvlVendorID)
					 AND CBR.ConTableName IN ('VendContact','VendDcLocationContact','VendDcLocation')
					 AND CBR.StatusId IN (1, 2) AND (CBR.ContactMSTRID =@UserContactId OR JOB.JobDriverId = @UserContactId)
					 LEFT JOIN JOBDL020Gateways JG  ON Job.Id = JG.JobID AND JG.StatusId IN (194,195) -- will chnage later
					 AND (JG.GwyGatewayAnalyst = @UserContactId OR JG.GwyGatewayResponsible = @UserContactId OR Job.JobDeliveryAnalystContactID = @UserContactId
					 OR Job.JobDeliveryResponsibleContactID = @UserContactId )
					 Where JOB.ID = @JobId
				END
	END
Select @IsUserHavePermission
END
GO
