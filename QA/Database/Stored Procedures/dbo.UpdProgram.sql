SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program  
-- Execution:                 EXEC [dbo].[UpdProgram]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdProgram]  
	(@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@id bigint
	,@parentId bigint  
	,@prgOrgId bigint  
	,@prgCustId bigint  
	,@prgItemNumber nvarchar(20)  
	,@prgProgramCode nvarchar(20)  
	,@prgProjectCode nvarchar(20)  
	,@prgPhaseCode nvarchar(20)  
	,@prgProgramTitle nvarchar(50)  
	,@prgAccountCode nvarchar(50)  
	,@delEarliest decimal(18,2) = NULL
	,@delLatest decimal(18,2) = NULL
	,@delDay BIT
	,@pckEarliest decimal(18,2)  = NULL
	,@pckLatest decimal(18,2) = NULL
	,@pckDay BIT
	,@statusId INT  
	,@prgDateStart datetime2(7)  
	,@prgDateEnd datetime2(7)  
	,@prgDeliveryTimeDefault datetime2(7)  
	,@prgPickUpTimeDefault datetime2(7)  
	,@dateChanged datetime2(7)  
	,@changedBy nvarchar(50)
	,@isFormView BIT = 0  )   
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 --DECLARE @parentNode hierarchyid, @lc hierarchyid, @currentId BIGINT      
 --   SELECT @parentNode = [PrgHierarchyID]      
 --   FROM  [dbo].[PRGRM000Master]      
 --   WHERE [Id] = @parentPrgId      
 --   SET TRANSACTION ISOLATION LEVEL SERIALIZABLE      
 --   BEGIN TRANSACTION      
 --   SELECT @lc = max(PrgHierarchyID)       
 --   FROM   [dbo].[PRGRM000Master]     
 --   WHERE PrgHierarchyID.GetAncestor(1)  =@parentNode ;  
 --INSERT INTO [dbo].[PRGRM000Master]  
 --          ([PrgOrgId]    
 --          ,[PrgCustId]    
 --          ,[PrgItemNumber]    
 --          ,[PrgProgramCode]    
 --          ,[PrgProjectCode]    
 --          ,[PrgPhaseCode]    
 --          ,[PrgProgramTitle]    
 --          ,[PrgAccountCode]    
 --          ,[StatusId]    
 --          ,[PrgDateStart]    
 --          ,[PrgDateEnd]    
 --          ,[PrgDeliveryTimeDefault]    
 --          ,[PrgPickUpTimeDefault]    
 --          ,[PrgDescription]    
 --          ,[PrgNotes]    
 --          ,[PrgHierarchyID]    
 --          ,[DateEntered]    
 --          ,[EnteredBy])  
 --    VALUES  
 --          (@prgOrgId    
 --          ,@prgCustId    
 --          ,@prgItemNumber    
 --          ,@prgProgramCode    
 --          ,@prgProjectCode    
 --          ,@prgPhaseCode    
 --          ,@prgProgramTitle    
 --          ,@prgAccountCode    
 --          ,@statusId    
 --          ,@prgDateStart    
 --          ,@prgDateEnd    
 --          ,@prgDeliveryTimeDefault    
 --          ,@prgPickUpTimeDefault    
 --          ,@prgDescription    
 --          ,@prgNotes    
 --          ,@parentNode.GetDescendant(@lc, NULL)    
 --          ,@dateEntered    
 --          ,@enteredBy)   
  
 --SET @currentId = SCOPE_IDENTITY();  

 UPDATE PRGRM000Master
        SET PrgOrgID				= CASE WHEN (@isFormView = 1) THEN @prgOrgId WHEN ((@isFormView = 0) AND (@prgOrgId=-100)) THEN NULL ELSE ISNULL(@prgOrgId,PrgOrgID) END
		   ,PrgCustId				= CASE WHEN (@isFormView = 1) THEN @prgCustId WHEN ((@isFormView = 0) AND (@prgCustId=-100)) THEN NULL ELSE ISNULL(@prgCustId,PrgCustID) END
		   ,PrgItemNumber			= CASE WHEN (@isFormView = 1) THEN @prgItemNumber WHEN ((@isFormView = 0) AND (@prgItemNumber='#M4PL#')) THEN NULL ELSE ISNULL(@prgItemNumber,PrgItemNumber) END
		   ,PrgProgramCode			= CASE WHEN (@isFormView = 1) THEN @prgProgramCode WHEN ((@isFormView = 0) AND (@prgProgramCode='#M4PL#')) THEN NULL ELSE ISNULL(@prgProgramCode,PrgProgramCode) END
		   ,PrgProjectCode			= CASE WHEN (@isFormView = 1) THEN @prgProjectCode WHEN ((@isFormView = 0) AND (@prgProjectCode='#M4PL#')) THEN NULL ELSE ISNULL(@prgProjectCode,PrgProjectCode) END
		   ,PrgPhaseCode			= CASE WHEN (@isFormView = 1) THEN @prgPhaseCode WHEN ((@isFormView = 0) AND (@prgPhaseCode='#M4PL#')) THEN NULL ELSE ISNULL(@prgPhaseCode,PrgPhaseCode) END
		   ,PrgProgramTitle			= CASE WHEN (@isFormView = 1) THEN @prgProgramTitle WHEN ((@isFormView = 0) AND (@prgProgramTitle='#M4PL#')) THEN NULL ELSE ISNULL(@prgProgramTitle,PrgProgramTitle) END
		   ,PrgAccountCode			= CASE WHEN (@isFormView = 1) THEN @prgAccountCode WHEN ((@isFormView = 0) AND (@prgAccountCode='#M4PL#')) THEN NULL ELSE ISNULL(@prgAccountCode,PrgAccountCode) END
		   ,DelEarliest				= CASE WHEN (@isFormView = 1) THEN @delEarliest WHEN ((@isFormView = 0) AND (@delEarliest=-100)) THEN NULL ELSE ISNULL(@delEarliest, DelEarliest) END
		   ,DelLatest				= CASE WHEN (@isFormView = 1) THEN @delLatest WHEN ((@isFormView = 0) AND (@delLatest=-100)) THEN NULL ELSE ISNULL(@delLatest, DelLatest) END
		   ,DelDay					= ISNULL(@delDay, DelDay)
		   ,PckEarliest				= CASE WHEN (@isFormView = 1) THEN @pckEarliest WHEN ((@isFormView = 0) AND (@pckEarliest=-100)) THEN NULL ELSE ISNULL(@pckEarliest, PckEarliest) END
		   ,PckLatest				= CASE WHEN (@isFormView = 1) THEN @pckLatest WHEN ((@isFormView = 0) AND (@pckLatest=-100)) THEN NULL ELSE ISNULL(@pckLatest, PckLatest) END
		   ,PckDay					= ISNULL(@pckDay, PckDay)
		   ,StatusId				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId,StatusId) END
		   ,PrgDateStart			= CASE WHEN (@isFormView = 1) THEN @prgDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @prgDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@prgDateStart,PrgDateStart) END
		   ,PrgDateEnd				= CASE WHEN (@isFormView = 1) THEN @prgDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @prgDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@prgDateEnd,PrgDateEnd) END
		   ,PrgDeliveryTimeDefault  = CASE WHEN (@isFormView = 1) THEN @prgDeliveryTimeDefault WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @prgDeliveryTimeDefault, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@prgDeliveryTimeDefault,PrgDeliveryTimeDefault) END
		   ,PrgPickUpTimeDefault	= CASE WHEN (@isFormView = 1) THEN @prgPickUpTimeDefault WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @prgPickUpTimeDefault, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@prgPickUpTimeDefault,PrgPickUpTimeDefault) END
		   ,DateChanged				= ISNULL(@dateChanged,DateChanged)
		   ,ChangedBy				= ISNULL(@changedBy,ChangedBy)
		   WHERE Id = @id

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
  ,prg.[DelDay] 
  ,prg.[PckEarliest] 
  ,prg.[PckLatest] 
  ,prg.[PckDay]        
  ,prg.[StatusId]        
  ,prg.[PrgDateStart]        
  ,prg.[PrgDateEnd]        
  ,prg.[PrgDeliveryTimeDefault]        
  ,prg.[PrgPickUpTimeDefault]        
  ,prg.[PrgHierarchyID].ToString() As PrgHierarchyID         
  ,prg.[PrgHierarchyLevel]        
  ,prg.[DateEntered]        
  ,prg.[EnteredBy]        
  ,prg.[DateChanged]        
  ,prg.[ChangedBy]        
  FROM   [dbo].[PRGRM000Master] prg   WHERE prg.Id = @id  
  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
