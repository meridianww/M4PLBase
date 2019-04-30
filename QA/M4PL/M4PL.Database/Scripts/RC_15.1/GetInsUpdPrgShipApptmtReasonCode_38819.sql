
------- INSERT INTO Lookup Table ---------
GO
PRINT N'Insert into [dbo].[SYSTM000Ref_Lookup]...';
GO
SET IDENTITY_INSERT [dbo].[SYSTM000Ref_Lookup] ON;
GO

INSERT INTO [dbo].[SYSTM000Ref_Lookup]([Id],[LkupCode],[LkupTableName]) VALUES(1032, 'PacApptCategoryCode', 'PrgShipApptmtReasonCode')

GO
SET IDENTITY_INSERT [dbo].[SYSTM000Ref_Lookup] OFF;
GO
------- INSERT INTO SYSTM000Ref_Options Table ---------

PRINT N'Insert into [dbo].[SYSTM000Ref_Options]...';
GO
insert into [dbo].[SYSTM000Ref_Options](
	 [SysLookupId]
      ,[SysLookupCode]
      ,[SysOptionName]
      ,[SysSortOrder]
      ,[SysDefault]
      ,[IsSysAdmin]
      ,[StatusId]
      ,[DateEntered]
	 )
	 VALUES(1032, 'PacApptCategoryCode', 'Normal', 0, 1, 0, 1, GETDATE())
	 ,(1032, 'PacApptCategoryCode', 'Controllable', 1, null, 0, 1, GETDATE())
	 ,(1032, 'PacApptCategoryCode', 'Noncontrollable', 2, null, 0, 1, GETDATE())
GO

----------- UPDATE PrgShipApptmtReasonCode table's PacApptCategoryCode value -----------------

PRINT N'UPDATE [dbo].[PRGRM031ShipApptmtReasonCodes]...';
GO

UPDATE [dbo].[PRGRM031ShipApptmtReasonCodes] SET PacApptCategoryCode=null WHERE PacApptCategoryCode not in('Noncontrollable','Normal', 'Controllable', 'Controllalbe')
UPDATE [dbo].[PRGRM031ShipApptmtReasonCodes] SET PacApptCategoryCode=(SELECT Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupCode='PacApptCategoryCode' AND SysOptionName = 'Normal') WHERE PacApptCategoryCode='Normal'
UPDATE [dbo].[PRGRM031ShipApptmtReasonCodes] SET PacApptCategoryCode=(SELECT Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupCode='PacApptCategoryCode' AND SysOptionName = 'Controllable') WHERE PacApptCategoryCode='Controllable' OR PacApptCategoryCode='Controllalbe'
UPDATE [dbo].[PRGRM031ShipApptmtReasonCodes] SET PacApptCategoryCode=(SELECT Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupCode='PacApptCategoryCode' AND SysOptionName = 'Noncontrollable') WHERE PacApptCategoryCode='Noncontrollable'

GO

----------- UPDATE Column Alias table's PrgShipApptmtReasonCode related data ----------------
PRINT N'UPDATE [dbo].[SYSTM000ColumnsAlias]...';
GO

UPDATE [dbo].[SYSTM000ColumnsAlias] set ColLookupId=1032, ColLookupCode='PacApptCategoryCode', ColColumnName='PacApptCategoryCodeId' where ColTableName='PrgShipApptmtReasonCode' and ColColumnName='PacApptCategoryCode'

Go

---------- UPDATE PrgShipApptmtReasonCode table's PacApptCategoryCode column ----------------

GO
ALTER TABLE [dbo].[PRGRM031ShipApptmtReasonCodes] ALTER COLUMN PacApptCategoryCode INT NULL;
Go
EXEC sp_RENAME 'PRGRM031ShipApptmtReasonCodes.PacApptCategoryCode' , 'PacApptCategoryCodeId', 'COLUMN'
GO

------------ DELETE from COLUMNSETTINGSBYUSER TABLE ---------------------------
GO
DELETE FROM [dbo].[SYSTM000ColumnSettingsByUser] where ColTableName = 'PrgShipApptmtReasonCode'
GO


---------------------------------------------------------         UPDATE PrgShipApptmtReasonCode related procedures            --------------------------------
GO
PRINT N'Altering [dbo].[GetPrgShipApptmtReasonCode]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program Ship Apptmt Reason Code
-- Execution:                 EXEC [dbo].[GetPrgShipApptmtReasonCode]
-- Modified on:  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetPrgShipApptmtReasonCode]
    @userId BIGINT,
    @roleCode NVARCHAR(25),
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[PacOrgID]
		,prg.[PacProgramID]
		,prg.[PacApptItem]
		,prg.[PacApptReasonCode]
		,prg.[PacApptLength]
		,prg.[PacApptInternalCode]
		,prg.[PacApptPriorityCode]
		,prg.[PacApptTitle]
		,prg.[PacApptCategoryCodeId]
		,prg.[PacApptUser01Code]
		,prg.[PacApptUser02Code]
		,prg.[PacApptUser03Code]
		,prg.[PacApptUser04Code]
		,prg.[PacApptUser05Code]
		,prg.[StatusId]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM031ShipApptmtReasonCodes] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[PrgShipApptmtReasonCodeCopy]...';


GO

  

  ALTER  PROCEDURE [dbo].[PrgShipApptmtReasonCodeCopy]
  (
    @programId BIGINT,
	@enteredBy NVARCHAR(50),
	@fromRecordId BIGINT
  )
  AS 
  BEGIN
   SET NOCOUNT ON;   

 INSERT INTO [dbo].[PRGRM031ShipApptmtReasonCodes]
           ( [PacOrgID]
			,[PacProgramID]
			,[PacApptItem]
			,[PacApptReasonCode]
			,[PacApptLength]
			,[PacApptInternalCode]
			,[PacApptPriorityCode]
			,[PacApptTitle]
			,[PacApptCategoryCodeId]
			,[PacApptUser01Code]
			,[PacApptUser02Code]
			,[PacApptUser03Code]
			,[PacApptUser04Code]
			,[PacApptUser05Code]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy])
      
			SELECT 
			 [PacOrgID]
			,@programId
			,[PacApptItem]
			,[PacApptReasonCode]
			,[PacApptLength]
			,[PacApptInternalCode]
			,[PacApptPriorityCode]
			,[PacApptTitle]
			,[PacApptCategoryCodeId]
			,[PacApptUser01Code]
			,[PacApptUser02Code]
			,[PacApptUser03Code]
			,[PacApptUser04Code]
			,[PacApptUser05Code]
			,[StatusId]
			,GETUTCDATE()      
			,@enteredBy            
			FROM PRGRM031ShipApptmtReasonCodes WHERE [PacProgramID]= @fromRecordId   AND StatusId IN(1,2)   
			
END
GO
PRINT N'Altering [dbo].[InsPrgShipApptmtReasonCode]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a  Program Ship Apptmt Reason Code
-- Execution:                 EXEC [dbo].[InsPrgShipApptmtReasonCode]
-- Modified on:  
-- Modified Desc:  
-- ============================================= 

ALTER PROCEDURE  [dbo].[InsPrgShipApptmtReasonCode]
		    (@userId BIGINT
		    ,@roleCode NVARCHAR(25)
			,@pacOrgId bigint
			,@pacProgramId bigint
			,@pacApptItem int
			,@pacApptReasonCode nvarchar(20)
			,@pacApptLength int
			,@pacApptInternalCode nvarchar(20)
			,@pacApptPriorityCode nvarchar(20)
			,@pacApptTitle nvarchar(50)
			,@pacApptCategoryCodeId int = null
			,@pacApptUser01Code nvarchar(20)
			,@pacApptUser02Code nvarchar(20)
			,@pacApptUser03Code nvarchar(20)
			,@pacApptUser04Code nvarchar(20)
			,@pacApptUser05Code nvarchar(20)
			,@statusId int
			,@dateEntered datetime2(7)
			,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
  DECLARE @where NVARCHAR(MAX) =    ' AND PacProgramID ='  +  CAST(@pacProgramId AS VARCHAR)    
  EXEC [dbo].[GetItemNumberAndUpdate] 0,'PRGRM031ShipApptmtReasonCodes','PacApptItem',@pacApptItem,@statusId, @where, @updatedItemNumber OUTPUT ;
  
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[PRGRM031ShipApptmtReasonCodes]
           ([PacOrgID]
			,[PacProgramID]
			,[PacApptItem]
			,[PacApptReasonCode]
			,[PacApptLength]
			,[PacApptInternalCode]
			,[PacApptPriorityCode]
			,[PacApptTitle]
			,[PacApptCategoryCodeId]
			,[PacApptUser01Code]
			,[PacApptUser02Code]
			,[PacApptUser03Code]
			,[PacApptUser04Code]
			,[PacApptUser05Code]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@pacOrgId
		   	,@pacProgramId
		   	,@updatedItemNumber
		   	,@pacApptReasonCode
		   	,@pacApptLength
		   	,@pacApptInternalCode
		   	,@pacApptPriorityCode
		   	,@pacApptTitle
		   	,@pacApptCategoryCodeId
		   	,@pacApptUser01Code
		   	,@pacApptUser02Code
		   	,@pacApptUser03Code
		   	,@pacApptUser04Code
		   	,@pacApptUser05Code
		   	,@statusId
		   	,@dateEntered
		   	,@enteredBy)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM031ShipApptmtReasonCodes] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[UpdPrgShipApptmtReasonCode]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Ship Apptmt Reason Code
-- Execution:                 EXEC [dbo].[UpdPrgShipApptmtReasonCode]
-- Modified on:  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdPrgShipApptmtReasonCode]
	       (@userId BIGINT
		    ,@roleCode NVARCHAR(25)
		    ,@id bigint
			,@pacOrgId bigint = NULL
			,@pacProgramId bigint = NULL
			,@pacApptItem int = NULL
			,@pacApptReasonCode nvarchar(20) = NULL
			,@pacApptLength int = NULL
			,@pacApptInternalCode nvarchar(20) = NULL
			,@pacApptPriorityCode nvarchar(20) = NULL
			,@pacApptTitle nvarchar(50) = NULL
			,@pacApptCategoryCodeId int = NULL
			,@pacApptUser01Code nvarchar(20) = NULL
			,@pacApptUser02Code nvarchar(20) = NULL
			,@pacApptUser03Code nvarchar(20) = NULL
			,@pacApptUser04Code nvarchar(20) = NULL
			,@pacApptUser05Code nvarchar(20) = NULL
			,@statusId int = NULL
			,@dateChanged datetime2(7) = NULL
			,@changedBy nvarchar(50) = NULL
			,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
  DECLARE @where NVARCHAR(MAX) =    ' AND PacProgramID ='  +  CAST(@pacProgramId AS VARCHAR)    
  EXEC [dbo].[GetItemNumberAndUpdate] @id,'PRGRM031ShipApptmtReasonCodes','PacApptItem',@pacApptItem,@statusId, @where, @updatedItemNumber OUTPUT ;

 UPDATE [dbo].[PRGRM031ShipApptmtReasonCodes]
		SET  [PacOrgID]              = CASE WHEN (@isFormView = 1) THEN @pacOrgID WHEN ((@isFormView = 0) AND (@pacOrgID=-100)) THEN NULL ELSE ISNULL(@pacOrgID, PacOrgID) END
			,[PacProgramID]          = CASE WHEN (@isFormView = 1) THEN @pacProgramID WHEN ((@isFormView = 0) AND (@pacProgramID=-100)) THEN NULL ELSE ISNULL(@pacProgramID, PacProgramID) END
			,[PacApptItem]           = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PacApptItem) END
			,[PacApptReasonCode]     = CASE WHEN (@isFormView = 1) THEN @pacApptReasonCode WHEN ((@isFormView = 0) AND (@pacApptReasonCode='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptReasonCode, PacApptReasonCode) END
			,[PacApptLength]         = CASE WHEN (@isFormView = 1) THEN @pacApptLength WHEN ((@isFormView = 0) AND (@pacApptLength=-100)) THEN NULL ELSE ISNULL(@pacApptLength, PacApptLength) END
			,[PacApptInternalCode]   = CASE WHEN (@isFormView = 1) THEN @pacApptInternalCode WHEN ((@isFormView = 0) AND (@pacApptInternalCode='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptInternalCode, PacApptInternalCode) END
			,[PacApptPriorityCode]   = CASE WHEN (@isFormView = 1) THEN @pacApptPriorityCode WHEN ((@isFormView = 0) AND (@pacApptPriorityCode='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptPriorityCode, PacApptPriorityCode) END
			,[PacApptTitle]          = CASE WHEN (@isFormView = 1) THEN @pacApptTitle WHEN ((@isFormView = 0) AND (@pacApptTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptTitle, PacApptTitle) END
			,[PacApptCategoryCodeId] = CASE WHEN (@isFormView = 1) THEN @pacApptCategoryCodeId WHEN ((@isFormView = 0) AND (@pacApptCategoryCodeId=-100)) THEN NULL ELSE ISNULL(@pacApptCategoryCodeId, PacApptCategoryCodeId) END
			,[PacApptUser01Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser01Code WHEN ((@isFormView = 0) AND (@pacApptUser01Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser01Code, PacApptUser01Code) END
			,[PacApptUser02Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser02Code WHEN ((@isFormView = 0) AND (@pacApptUser02Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser02Code, PacApptUser02Code) END
			,[PacApptUser03Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser03Code WHEN ((@isFormView = 0) AND (@pacApptUser03Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser03Code, PacApptUser03Code) END
			,[PacApptUser04Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser04Code WHEN ((@isFormView = 0) AND (@pacApptUser04Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser04Code, PacApptUser04Code) END
			,[PacApptUser05Code]     = CASE WHEN (@isFormView = 1) THEN @pacApptUser05Code WHEN ((@isFormView = 0) AND (@pacApptUser05Code='#M4PL#')) THEN NULL ELSE ISNULL(@pacApptUser05Code, PacApptUser05Code) END
			,[StatusId]				 = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId)	 END
			,[DateChanged]           = @dateChanged
			,[ChangedBy]             = @changedBy
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[PacOrgID]
		,prg.[PacProgramID]
		,prg.[PacApptItem]
		,prg.[PacApptReasonCode]
		,prg.[PacApptLength]
		,prg.[PacApptInternalCode]
		,prg.[PacApptPriorityCode]
		,prg.[PacApptTitle]
		,prg.[PacApptCategoryCodeId]
		,prg.[PacApptUser01Code]
		,prg.[PacApptUser02Code]
		,prg.[PacApptUser03Code]
		,prg.[PacApptUser04Code]
		,prg.[PacApptUser05Code]
		,prg.[StatusId]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM031ShipApptmtReasonCodes] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO