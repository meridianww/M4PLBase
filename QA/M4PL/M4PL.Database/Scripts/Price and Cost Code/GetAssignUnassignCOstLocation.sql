USE [M4PL_DEV]
GO
 

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               07/31/2019     
-- Description:               Get all Cost rates under the specified program 
-- Execution:                 EXEC [dbo].[GetAssignUnassignBillableLocations]
-- Modified on:  
-- Modified Desc:  
-- =============================================                            
ALTER PROCEDURE [dbo].[GetAssignUnassignCostLocations] @orgId BIGINT
	,@isAssignedCostLocation BIT
	,@parentId BIGINT = NULL
	,@programId BIGINT
	,@isChild BIT
AS
BEGIN TRY
	SET NOCOUNT ON;

	--assigned Program vendor locations      
	IF @isAssignedCostLocation = 1
	BEGIN
		IF @isChild = 0
		BEGIN
			SELECT vm.Id AS Id
				,NULL AS ParentId
				--,vm.VendCode  AS Name       
				,'0_' + CAST(vm.Id AS VARCHAR) AS Name
				,vm.VendCode + COALESCE('(' + VendTitle + ')', '') AS [Text]
				,vm.VendCode + COALESCE('(' + VendTitle + ')', '') AS [ToolTip]
			FROM VEND000Master(NOLOCK) vm
			WHERE vm.StatusId IN (
					1
					,2
					)
				AND vm.Id IN (
					SELECT PclVendorID
					FROM PRGRM043ProgramCostLocations pvl
					WHERE PclProgramID = @programId
						AND pvl.StatusId IN (
							1
							,2
							)
					)
				AND vm.VendOrgId = @orgId
			ORDER BY vm.VendCode
		END
		ELSE
		BEGIN
			SELECT pvl.Id AS Id
				,pvl.PclProgramID AS ParentId
				--,pvl.PvlLocationCode  AS Name        
				,CAST(pvl.PclProgramID AS VARCHAR) + '_' + CAST(pvl.Id AS VARCHAR) AS Name
				,pvl.PclLocationCode + COALESCE('(' + PclLocationTitle + ')', '') AS [Text]
				,pvl.PclLocationCode + COALESCE('(' + PclLocationTitle + ')', '') AS [ToolTip]
				,CAST(1 AS BIT) AS IsLeaf
			FROM PRGRM043ProgramCostLocations(NOLOCK) pvl
			INNER JOIN VEND000Master(NOLOCK) vm ON pvl.PclVendorID = vm.Id
			WHERE vm.StatusId IN (
					1
					,2
					)
				AND pvl.StatusId IN (
					1
					,2
					)
				AND pvl.PclVendorID = @parentId
				AND pvl.PclProgramID = @programId
			ORDER BY pvl.PclLocationCode
		END
	END
	ELSE -- --Unassigned Program vendor locations       
	BEGIN
		IF @isChild = 0
		BEGIN
			SELECT DISTINCT vm.Id AS Id
				,NULL AS ParentId
				,'0_' + CAST(vm.Id AS VARCHAR) AS Name
				,vm.VendCode + COALESCE('(' + VendTitle + ')', '') AS [Text]
				,vm.VendCode + COALESCE('(' + VendTitle + ')', '') AS [ToolTip]
				,CASE 
					WHEN vdc.Id IS NULL
						THEN CAST(1 AS BIT)
					ELSE CAST(0 AS BIT)
					END AS IsLeaf
				,CASE 
					WHEN ISNULL(vdc.Id, 0) > 0
						THEN CAST(1 AS BIT)
					WHEN (
							vm.[VendCorporateAddressId] IS NULL
							AND vm.[VendBusinessAddressId] IS NULL
							AND vm.[VendWorkAddressId] IS NULL
							)
						THEN CAST(0 AS BIT)
					ELSE CAST(1 AS BIT)
					END AS [Enabled]
			FROM [PRGRM051VendorLocations] t2
			INNER JOIN VEND000Master(NOLOCK) vm ON vm.Id = t2.PvlVendorID
			LEFT JOIN [VEND040DCLocations](NOLOCK) vdc ON vdc.VdcVendorID = vm.Id
			WHERE vm.StatusId IN (
					1
					,2
					)
				AND vm.VendOrgId = @orgId
				AND vdc.StatusId = 1
				AND t2.PvlProgramID = @programId
				AND NOT EXISTS (
					SELECT PclVendorID
						,PclLocationCode
					FROM [dbo].PRGRM043ProgramCostLocations pcl
					WHERE pcl.PclProgramID = @programId
						AND pcl.StatusId IN (
							1
							,2
							)
						AND vdc.VdcVendorID = pcl.PclVendorID
						AND vdc.VdcLocationCode = pcl.PclLocationCode
					)
		END
		ELSE
		BEGIN
			SELECT vdc.Id AS Id
				,vm.Id AS ParentId
				,CAST(vm.Id AS VARCHAR) + '_' + CAST(vdc.Id AS VARCHAR) AS Name
				,vdc.VdcLocationCode + COALESCE('(' + VdcLocationTitle + ')', '') AS [Text]
				,vdc.VdcLocationCode + COALESCE('(' + VdcLocationTitle + ')', '') AS [ToolTip]
				,CAST(1 AS BIT) AS IsLeaf
				,CAST(1 AS BIT) AS [Enabled]
			FROM VEND000Master(NOLOCK) vm
			LEFT JOIN [VEND040DCLocations](NOLOCK) vdc ON vdc.VdcVendorID = vm.Id
				AND vdc.StatusId = 1
			WHERE vm.StatusId IN (
					1
					,2
					)
				AND vdc.VdcVendorID = @parentId
				AND NOT EXISTS (
					SELECT PvlVendorID
						,PvlLocationCode
					FROM [dbo].[PRGRM051VendorLocations] t2
					WHERE t2.PvlProgramID = @programId
						AND t2.PvlVendorID = @parentId
						AND t2.StatusId IN (
							1
							,2
							)
						AND vdc.VdcVendorID = t2.PvlVendorID
						AND vdc.VdcLocationCode = t2.PvlLocationCode
					)
			ORDER BY vdc.VdcLocationCode
		END
	END
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH