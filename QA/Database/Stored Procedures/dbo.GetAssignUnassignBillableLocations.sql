SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil         
-- Create date:               07/31/2019     
-- Description:               Get all Cost rates under the specified program 
-- Execution:                 EXEC [dbo].[GetAssignUnassignCostLocations]   
-- Modified on:  
-- Modified Desc:  
-- =============================================                           
CREATE PROCEDURE [dbo].[GetAssignUnassignBillableLocations]  @orgId BIGINT,        
 @isAssignedPriceLocation BIT,                       
 @parentId BIGINT = NULL,  
 @programId BIGINT,        
 @isChild BIT 
AS
BEGIN TRY
	SET NOCOUNT ON;

	--assigned Program vendor locations      
	IF @isAssignedPriceLocation = 1
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
					SELECT PblVendorID
					FROM PRGRM042ProgramBillableLocations pvl
					WHERE PblProgramID = @programId
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
			SELECT  pvl.Id  AS Id        
          ,pvl.PvlProgramID  AS ParentId        
    --,pvl.PvlLocationCode  AS Name        
 ,CAST(pvl.PvlProgramID AS VARCHAR) + '_'+CAST(pvl.Id AS VARCHAR) As Name     
    ,pvl.PvlLocationCode + COALESCE( '('+PvlLocationTitle+')', '')  as [Text]        
    ,pvl.PvlLocationCode + COALESCE( '('+PvlLocationTitle+')', '')  as [ToolTip]    
 ,CAST(1 AS BIT) As IsLeaf        
     FROM PRGRM051VendorLocations (NOLOCK) pvl        
  INNER JOIN VEND000Master (NOLOCK) vm ON pvl.PvlVendorID = vm.Id         
  WHERE vm.StatusId  IN( 1,2)          
       AND  pvl.StatusId  IN( 1,2)          
        AND pvl.PvlVendorID = @parentId 
		AND pvl.PvlProgramID = @programId    
		 AND EXISTS             
           (SELECT PblVendorID,PblLocationCode  FROM [dbo].[PRGRM042ProgramBillableLocations] t2               
            WHERE t2.PblProgramID = @programId   
       AND  t2.PblVendorID = @parentId  
       AND t2.StatusId IN (1,2)                 
                AND  pvl.pvlVendorID=t2.PblVendorID              
                AND  pvl.pvlLocationCode = t2.PblLocationCode )           
    ORDER BY  pvl.PvlLocationCode
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
			WHERE t2.StatusId IN (
					1
					,2
					)
				AND vm.VendOrgId = @orgId
				AND vdc.StatusId = 1
				AND t2.PvlProgramID = @programId
				AND NOT EXISTS (
					SELECT PblVenderDCLocationId
					FROM [dbo].PRGRM042ProgramBillableLocations pcl
					WHERE pcl.PblProgramID = @programId
						AND pcl.StatusId IN (
							1
							,2
							)
							AND t2.VendDCLocationId = pcl.PblVenderDCLocationId
					)
		END
		ELSE
		BEGIN
 SELECT vdc.Id  AS Id        
 ,vdc.PvlVendorID AS ParentId               
 ,CAST(vdc.PvlVendorID AS VARCHAR) + '_'+CAST(vdc.Id AS VARCHAR) As Name     
    ,vdc.PvlLocationCode + COALESCE( '('+PvlLocationTitle+')', '')  as [Text]        
    ,vdc.PvlLocationCode + COALESCE( '('+PvlLocationTitle+')', '')  as [ToolTip]       
 ,CAST(1 AS BIT) As IsLeaf     
  ,CAST(1 AS BIT) As [Enabled]    
  FROM  [PRGRM051VendorLocations] (NOLOCK) vdc  
  WHERE vdc.StatusId  IN( 1,2) AND vdc.PvlVendorID = @parentId AND vdc.PvlProgramId =  @programId     
      AND NOT EXISTS             
           (SELECT PblVenderDCLocationId  FROM [dbo].[PRGRM042ProgramBillableLocations] t2               
            WHERE t2.PblProgramID = @programId   
       AND  t2.PblVendorID = @parentId  
       AND t2.StatusId IN (1,2)                 
                AND  vdc.VendDCLocationId=t2.PblVenderDCLocationId )  
   ORDER BY  vdc.PvlLocationCode 
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

GO
