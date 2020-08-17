
GO
/* Copyright (2020) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal        
-- Create date:               08/17/2020      
-- Description:               Ins a Driver Contact To Job
-- Execution:                 EXEC [dbo].[InsDriverContact]
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsDriverContact]		  
	 @userId BIGINT = NULL 
	,@roleId BIGINT  =  NULL 
	,@entity NVARCHAR(100) = NULL
	,@orgId BIGINT = NULL
	,@bizMoblContactID  NVARCHAR(50)
	,@locationCode  NVARCHAR(50)
	,@firstName  NVARCHAR(50)
	,@lastName  NVARCHAR(50)
	,@jobId BIGINT
               

AS
BEGIN TRY                

 IF EXISTS ( SELECT 1 FROM [dbo].[JOBDL000Master] WHERE Id  = @jobId and StatusId =( SELECT ID FROM [SYSTM000Ref_Options] WHERE [SysOptionName] = 'Active' and [SysLookupCode] = 'Status'))
  BEGIN 
   DECLARE @driverId BIGINT = 0
   DECLARE @conCodeId INT = 0
   DECLARE @conTypeId INT = 0
   DECLARE @dcLocationId INT = 0


   SELECT @conCodeId =ID FROM  [dbo].[ORGAN010Ref_Roles]  WHERE  OrgRoleCode LIKE '%DRIVER%' 
   SELECT @conTypeId = ID FROM [SYSTM000Ref_Options] WHERE  SysLookupCode = 'ContactType' AND SysOptionName  LIKE '%DRIVER%' 

   SELECT @dcLocationId =  VDCL.ID FROM  [JOBDL000Master] JB
										   INNER JOIN   PRGRM051VendorLocations PVL ON PVL.PvlProgramID  = JB.ProgramID
										   INNER JOIN VEND040DCLocations VDCL  ON VDCL.ID =  PVL.VendDCLocationId where
										   VDCL.VdcLocationCode = @locationCode and  JB.Id = @jobId AND VDCL.StatusId = 1   AND PVL.StatusId =1 

	   IF(@dcLocationId<>0)
	   BEGIN
			   SELECT @driverId = CM.Id FROM  [JOBDL000Master] JB
			   INNER JOIN   PRGRM051VendorLocations PVL ON PVL.PvlProgramID  = JB.ProgramID
			   INNER JOIN VEND040DCLocations VDCL  ON VDCL.ID =  PVL.VendDCLocationId
			   INNER JOIN  [CONTC010Bridge] CB ON CB.ConPrimaryRecordId =VDCL.ID  AND   CB.ConTableName = 'VendDcLocationContact' AND   CB.ConCodeId = @conCodeId  AND  CB.ConTypeId =@conTypeId
			   INNER JOIN CONTC000Master CM ON  CM.Id = CB.ContactMSTRID WHERE   
			   VDCL.VdcLocationCode = @locationCode
			   AND  CM.ConFirstName = @firstName AND CM.ConLastName = @lastName AND JB.Id = @jobId   AND VDCL.StatusId = 1   AND PVL.StatusId =1
  
				  IF (@driverId <> 0)
					  BEGIN
						  UPDATE  [JOBDL000Master] SET  JobDriverId =  @driverId   WHERE Id=  @jobId 
						  UPDATE CONTC000Master SET [ConUDF02] = @bizMoblContactID WHERE ID = @driverId
						SELECT Id,@locationCode AS locationCode,ConFirstName AS firstName,ConLastName AS lastName, [ConUDF02] AS bizMoblContactID,@jobId AS jobId  FROM  CONTC000Master WHERE ID = @driverId 
					  END
				  ELSE
					  BEGIN
					  DECLARE @newContactId BIGINT = 0 
						DECLARE @compId BIGINT = 0 
						DECLARE @compTitle nvarchar(100)
						 
						   SELECT @compId = COMP.Id,  @compTitle =COMP.CompTitle FROM  [COMP000Master] COMP    
						   INNER JOIN [VEND000Master]  VM ON VM.Id = COMP.CompPrimaryRecordId  AND  VM.STATUSID = 1 and COMP.CompTableName = 'Vendor'
						   INNER JOIN VEND040DCLocations VDCL  ON  COMP.CompPrimaryRecordId = VDCL.VdcVendorID  AND VDCL.StatusId =1 AND   VDCL.Id  = @dcLocationId 
						 INSERT INTO CONTC000Master (
						   [ConOrgId]
						  ,[ConLastName]
						  ,[ConFirstName]
						  ,[ConEmailAddress]
						  ,[StatusId]
						  ,[ConTypeId]
						  ,[ConUDF02]
						  ,[ConCompanyId]
						  ,[ConCompanyName]
						   ,[ConJobTitle]
						  ) 
						  VALUES(
						   @orgId
						  ,@lastName
						  ,@firstName
						  ,(SELECT CONCAT(@bizMoblContactID, '@', @locationCode,'.com'))
						  ,1
						  ,@conTypeId
						  ,@bizMoblContactID
						  ,@compId
						  ,@compTitle
						  ,'Driver'
						  )
	                    SET @newContactId = SCOPE_IDENTITY();

                        UPDATE  [JOBDL000Master] SET  JobDriverId =  @newContactId   WHERE Id=  @jobId 

						INSERT INTO dbo.CONTC010Bridge (ConOrgId, ContactMSTRID, ConTableName, ConPrimaryRecordId, ConItemNumber, ConTitle, ConCodeId, ConTypeId, StatusId, ConIsDefault, ConDescription, ConInstruction, ConTableTypeId, EnteredBy, DateEntered, ChangedBy, DateChanged)
						VALUES (1, @newContactId, 'VendDcLocationContact', @dcLocationId, 3, 'Driver', @conCodeId, @conTypeId, 1, NULL, NULL, NULL, 183, 'nfujimoto', '2020-07-28 00:46:37.003', NULL, NULL)

						SELECT Id,@locationCode AS locationCode,ConFirstName AS firstName,ConLastName AS lastName, ConUDF02 AS bizMoblContactID,@jobId AS jobId  FROM  CONTC000Master WHERE ID = @newContactId
					END
	     END
   END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH