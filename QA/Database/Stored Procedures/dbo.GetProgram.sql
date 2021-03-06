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
  DECLARE @PrgIsHavingPermission BIT = 0
		,@RoleType VARCHAR(100)
		,@IsSystemAdmin BIT = 0
		,@IsOrganizationEmplyee BIT = 0
		,@CompanyId INT
		,@UserContactId INT

		------security start------
		IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
		BEGIN
		DROP TABLE #EntityIdTemp
		END
		CREATE TABLE #EntityIdTemp(EntityId BIGINT)
		INSERT INTO #EntityIdTemp
		EXEC [dbo].[GetCustomEntityIdByEntityName] @userId, @roleId, @orgId, 'Program', 0, 1
		
		IF EXISTS(SELECT 1 FROM #EntityIdTemp WHERE EntityId IN(-1, @id))
		BEGIN
			SET @PrgIsHavingPermission = 1
		END

		------security end------
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
